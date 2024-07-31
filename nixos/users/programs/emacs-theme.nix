{ config, lib, pkgs, ... }:

{

  # home.file."my-theme.el".source = ../../../emacs-themes;
  home.file."os-theme.el".enable = true;
  home.file."os-theme.el".target = ".dotfiles/emacs-themes/os-theme.el";
  home.file."os-theme.el".text = ''
;;; themes/os-theme.el -*- lexical-binding: t; -*-

(require 'doom-themes)

;;; Variables

(defgroup doom-os-theme nil
  "Options for doom-themes"
  :group 'doom-themes)


(defcustom doom-os-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-os-theme
  :type 'boolean)

(defcustom doom-os-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-os-theme
  :type 'boolean)

(defcustom doom-os-comment-bg doom-os-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-os-theme
  :type 'boolean)

(defcustom doom-os-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-os-theme
  :type '(choice integer boolean))

(eval-and-compile
  (defcustom doom-os-region-highlight t
    "Determines the selection highlight style. Can be 'frost, 'snowstorm or t
(default)."
    :group 'doom-os-theme
    :type 'symbol))


;;
;;; Theme definition

(def-doom-theme my-everforest
  "A green theme with the everforest soft palette"

  ;; name        default   256       16
  ((bg         '("#${config.colorScheme.palette.base00}" nil       nil            ))
   (bg-alt     '("#${config.colorScheme.palette.base01}" nil       nil            )) ;; lighter bg
   (base02      '("#${config.colorScheme.palette.base02}" "black"   "black"        )) ;; selection bg
   (base03      '("#${config.colorScheme.palette.base03}" "#3a464c" "brightblack"  )) ;; comments, line highlight
   (base04      '("#${config.colorScheme.palette.base04}" "#434f55" "brightblack"  )) ;; dark fg
   (fg         '("#${config.colorScheme.palette.base05}" "#${config.colorScheme.palette.base05}" "white"        )) ;; fg
   (base06      '("#${config.colorScheme.palette.base06}" "#4d5960" "brightblack"  )) ;; light fg
   (fg-alt     '("#${config.colorScheme.palette.base07}" "#${config.colorScheme.palette.base07}" "brightwhite"  )) ;; brightest fg
   (base08       '("#${config.colorScheme.palette.base08}" "#${config.colorScheme.palette.base08}" "brightblue"   )) ;; var, tags,...
   (base09    '("#${config.colorScheme.palette.base09}" "#${config.colorScheme.palette.base09}" "base09"      )) ;; int, bool, constant, attr,...
   (base0A     '("#${config.colorScheme.palette.base0A}" "#${config.colorScheme.palette.base0A}" "base0A"       )) ;; classes, search text bg
   (base0B      '("#${config.colorScheme.palette.base0B}" "#${config.colorScheme.palette.base0B}" "base0B"        )) ;; str, diff, ...
   (base0C     '("#${config.colorScheme.palette.base0C}" "#${config.colorScheme.palette.base0C}" "brightred"    )) ;; supp, escape char, regexp
   (base0D        '("#${config.colorScheme.palette.base0D}" "#${config.colorScheme.palette.base0D}" "base0D"          )) ;; function, methods, attr id
   (base0E     '("#${config.colorScheme.palette.base0E}" "#${config.colorScheme.palette.base0E}" "brightmagenta")) ;; keywords, selector, storage
   (base0F       '("#${config.colorScheme.palette.base0F}" "#${config.colorScheme.palette.base0F}" "base0F"         )) ;; deprecated, embedded open/close tag

   ;; face categories -- required for all themes
   (highlight      base06)
   (vertical-bar   (doom-darken base4 0.2))
   (selection      base08)
   (builtin        base0B)
   (comments       base4)
   (doc-comments   base0B)
   (constants      base0E)
   (functions      teal)
   (keywords       base0D)
   (methods        dark-cyan)
   (operators      base0A)
   (type           aqua)
   (strings        base0A)
   (variables      base08)
   (numbers        base09)
   (region         base4)
   (error          base0D)
   (warning        base0C)
   (success        base0B)
   (vc-modified    base08)
   (vc-added       base0B)
   (vc-deleted     base0D)

   ;; custom categories
   (hidden     `(,(car bg) "white" "white"))
   (-modeline-bright doom-os-brighter-modeline)
   (-modeline-pad
    (when doom-os-padded-modeline
      (if (integerp doom-os-padded-modeline) doom-os-padded-modeline 4)))

   (region-fg
    (when (memq doom-os-region-highlight '(frost snowstorm))
      base02))

   (modeline-fg     nil)
   (modeline-fg-alt base6)

   (modeline-bg
    (if -modeline-bright
        (doom-blend bg base5 0.2)
      base03))
   (modeline-bg-l
    (if -modeline-bright
        (doom-blend bg base5 0.2)
      `(,(doom-darken (car bg) 0.1) ,@(cdr base02))))
   (modeline-bg-inactive   (doom-darken bg 0.1))
   (modeline-bg-inactive-l `(,(car bg) ,@(cdr base03))))


  ;; --- extra faces ------------------------
  (((region &override) :foreground region-fg)

   ((line-number &override) :foreground base02)
   ((line-number-current-line &override) :foreground base06)
   ((paren-face-match &override) :foreground base0D :background base06 :weight 'ultra-bold)
   ((paren-face-mismatch &override) :foreground base06 :background base0D :weight 'ultra-bold)
   ((vimish-fold-overlay &override) :inherit 'font-lock-comment-face :background base06 :weight 'light)
   ((vimish-fold-fringe &override)  :foreground teal)

   (font-lock-comment-face
    :foreground comments
    :background (if doom-os-comment-bg (doom-lighten bg 0.05)))
   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)

   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if -modeline-bright base8 highlight))

   (doom-modeline-project-root-dir :foreground base6)
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))

   ;; ediff
   (ediff-fine-diff-A    :background (doom-darken base0E 0.4) :weight 'bold)
   (ediff-current-diff-A :background (doom-darken base02 0.25))

   ;; elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")

   ;; highlight-symbol
   (highlight-symbol-face :background (doom-lighten base4 0.1) :distant-foreground fg-alt)

   ;; highlight-thing
   (highlight-thing :background (doom-lighten base4 0.1) :distant-foreground fg-alt)

   ;; ivy
   ((ivy-current-match &override) :foreground region-fg :weight 'semi-bold)


   ;; --- major-mode faces -------------------
   ;; css-mode / scss-mode
   (css-proprietary-property :foreground base0C)
   (css-property             :foreground base0B)
   (css-selector             :foreground base08)

   ;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground base0D)
   ((markdown-code-face &override) :background (doom-lighten base06 0.05))

   ;; org-mode
   (org-hide :foreground hidden)
   (org-block :background bg-alt)
   (solaire-org-hide-face :foreground hidden))


  ;; --- extra variables ---------------------
  (
  )
  )

;;; doom-os-theme.el ends here

'';

}
