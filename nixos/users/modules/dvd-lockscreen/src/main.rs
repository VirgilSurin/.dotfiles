use pam::Authenticator;
use rand::Rng;
use rpassword::read_password;
use std::thread::sleep;
use std::time::Duration;
use x11rb::connection::Connection;
use x11rb::protocol::xproto::*;
use x11rb::wrapper::ConnectionExt as _;
use x11rb::NONE;
use x11rb::protocol::Event;
use x11rb::protocol::xproto::{Rectangle, ConnectionExt};

const DVD_WIDTH: u16 = 100;
const DVD_HEIGHT: u16 = 50;
const SPEED: i16 = 2;

struct DvdLogo {
    x: i16,
    y: i16,
    dx: i16,
    dy: i16,
    color: u32,
}

impl DvdLogo {
    fn new(screen_width: i16, screen_height: i16) -> Self {
        let mut rng = rand::thread_rng();
        DvdLogo {
            x: rng.gen_range(0..screen_width - DVD_WIDTH as i16),
            y: rng.gen_range(0..screen_height - DVD_HEIGHT as i16),
            dx: SPEED,
            dy: SPEED,
            color: 0xFF_FF_FF,
        }
    }

    fn update(&mut self, screen_width: i16, screen_height: i16) {
        self.x += self.dx;
        self.y += self.dy;

        if self.x <= 0 || self.x >= screen_width - DVD_WIDTH as i16 {
            self.dx = -self.dx;
            self.color = rand::thread_rng().gen::<u32>() | 0xFF_00_00_00;
        }
        if self.y <= 0 || self.y >= screen_height - DVD_HEIGHT as i16 {
            self.dy = -self.dy;
            self.color = rand::thread_rng().gen::<u32>() | 0xFF_00_00_00;
        }
    }
}

fn authenticate() -> bool {
    let username = std::env::var("USER").unwrap_or_else(|_| String::from(""));
    let mut auth = Authenticator::with_password("system-auth")
        .expect("Failed to initialize PAM authenticator");

    auth.get_handler().set_credentials(username, read_password().unwrap());
    auth.authenticate().is_ok()
}

fn grab_keyboard_and_mouse(conn: &impl Connection, win: Window) -> Result<(), Box<dyn std::error::Error>> {
    conn.grab_keyboard(
        true,
        win,
        x11rb::CURRENT_TIME,
        GrabMode::ASYNC,
        GrabMode::ASYNC,
    )?;

    conn.grab_pointer(
        true,
        win,
        EventMask::NO_EVENT,
        GrabMode::ASYNC,
        GrabMode::ASYNC,
        win,
        NONE,
        x11rb::CURRENT_TIME,
    )?;

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let (conn, screen_num) = x11rb::connect(None)?;
    let screen = &conn.setup().roots[screen_num];

    let win = conn.generate_id()?;
    let gc = conn.generate_id()?;

    let values = CreateWindowAux::new()
        .background_pixel(0x000000)
        .event_mask(EventMask::EXPOSURE | EventMask::KEY_PRESS);

    conn.create_window(
        screen.root_depth,
        win,
        screen.root,
        0,
        0,
        screen.width_in_pixels,
        screen.height_in_pixels,
        0,
        WindowClass::INPUT_OUTPUT,
        screen.root_visual,
        &values,
    )?;

    conn.create_gc(gc, win, &CreateGCAux::new())?;

    let net_wm_state = conn.intern_atom(false, b"_NET_WM_STATE")?;
    let net_wm_state_fullscreen = conn.intern_atom(false, b"_NET_WM_STATE_FULLSCREEN")?;

    conn.change_property32(
        PropMode::REPLACE,
        win,
        net_wm_state.reply()?.atom,
        AtomEnum::ATOM,
        &[net_wm_state_fullscreen.reply()?.atom],
    )?;

    conn.map_window(win)?;
    grab_keyboard_and_mouse(&conn, win)?;
    conn.flush()?;

    let mut dvd = DvdLogo::new(
        screen.width_in_pixels as i16,
        screen.height_in_pixels as i16,
    );

    loop {
        while let Some(event) = conn.poll_for_event()? {
            if let Event::KeyPress(_) = event {
                if authenticate() {
                    return Ok(());
                }
            }
        }

        conn.clear_area(false, win, 0, 0, screen.width_in_pixels, screen.height_in_pixels)?;

        let values = ChangeGCAux::new().foreground(dvd.color);
        conn.change_gc(gc, &values)?;

        let rectangle = Rectangle {
            x: dvd.x,
            y: dvd.y,
            width: DVD_WIDTH,
            height: DVD_HEIGHT,
        };
        conn.poly_fill_rectangle(win, gc, &[rectangle])?;

        conn.flush()?;
        dvd.update(
            screen.width_in_pixels as i16,
            screen.height_in_pixels as i16,
        );

        sleep(Duration::from_millis(16));
    }
}
