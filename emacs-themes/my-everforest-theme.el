;;; themes/my-everforest.el -*- lexical-binding: t; -*-

(require 'doom-themes)

;;; Variables

(defgroup doom-nord-aurora-theme nil
  "Options for doom-themes"
  :group 'doom-themes)


(defcustom doom-nord-aurora-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-nord-aurora-theme
  :type 'boolean)

(defcustom doom-nord-aurora-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-nord-aurora-theme
  :type 'boolean)

(defcustom doom-nord-aurora-comment-bg doom-nord-aurora-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-nord-aurora-theme
  :type 'boolean)

(defcustom doom-nord-aurora-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-nord-aurora-theme
  :type '(choice integer boolean))

(eval-and-compile
  (defcustom doom-nord-aurora-region-highlight t
    "Determines the selection highlight style. Can be 'frost, 'snowstorm or t
(default)."
    :group 'doom-nord-aurora-theme
    :type 'symbol))


;;
;;; Theme definition

(def-doom-theme my-everforest
  "A green theme with the everforest soft palette"

  ;; name        default   256       16
  ((bg         '("#2f383e" nil       nil            ))
   (bg-alt     '("#323c41" nil       nil            ))
   (base0      '("#434f55" "black"   "black"        ))
   (base1      '("#3a464c" "#3a464c" "brightblack"  ))
   (base2      '("#434f55" "#434f55" "brightblack"  ))
   (base3      '("#4d5960" "#4d5960" "brightblack"  ))
   (base4      '("#555f66" "#555f66" "brightblack"  ))
   (base5      '("#9099AB" "#9099AB" "brightblack"  ))
   (base6      '("#9099AB" "#9099AB" "brightblack"  ))
   (base7      '("#D8DEE9" "#D8DEE9" "brightblack"  ))
   (base8      '("#F0F4FC" "#F0F4FC" "white"        ))
   (fg         '("#d3c6aa" "#d3c6aa" "white"        ))
   (fg-alt     '("#c6d3ab" "#c6d3ab" "brightwhite"  ))

   (grey       '("#859289" "#859289" "grey"         ))
   (red        '("#e67e80" "#e67e80" "red"          )) ;; Nord11
   (orange     '("#e69875" "#e69875" "brightred"    )) ;; Nord12
   (green      '("#a7c080" "#a7c080" "green"        )) ;; Nord14
   (greend     '("#7ec168" "#7ec168" "green dark"   )) ;; Nord14
   (aqua       '("#83c092" "#83c092" "aqua"         )) ;; Nord7
   (yellow     '("#dbbc7f" "#dbbc7f" "yellow"       )) ;; Nord13
   (blue       '("#7fbbb3" "#7fbbb3" "brightblue"   )) ;; Nord9
   (magenta    '("#d699b6" "#d699b6" "magenta"      )) ;; Nord15
   (teal       '("#8FBCBB" "#44b9b1" "brightgreen"  )) ;; Nord7
   (dark-blue  '("#7fbbb3" "#2257A0" "blue"         )) ;; Nord10
   (violet     '("#d699b6" "#a9a1e1" "brightmagenta")) ;; ??
   (dark-cyan  '("#88C0D0" "#46D9FF" "cyan"         )) ;; Nord8
   (cyan       '("#83c092" "#83c092" "cyan"         )) ;; Nord7

   ;; face categories -- required for all themes
   (highlight      base3)
   (vertical-bar   (doom-darken base4 0.2))
   (selection      blue)
   (builtin        green)
   (comments       grey)
   (doc-comments   green)
   (constants      violet)
   (functions      teal)
   (keywords       red)
   (methods        dark-cyan)
   (operators      orange)
   (type           green)
   (strings        yellow)
   (variables      blue)
   (numbers        magenta)
   (region         base4)
   (error          red)
   (warning        orange)
   (success        green)
   (vc-modified    blue)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "white" "white"))
   (-modeline-bright doom-nord-aurora-brighter-modeline)
   (-modeline-pad
    (when doom-nord-aurora-padded-modeline
      (if (integerp doom-nord-aurora-padded-modeline) doom-nord-aurora-padded-modeline 4)))

   (region-fg
    (when (memq doom-nord-aurora-region-highlight '(frost snowstorm))
      base0))

   (modeline-fg     nil)
   (modeline-fg-alt base6)

   (modeline-bg
    (if -modeline-bright
        (doom-blend bg base5 0.2)
      base1))
   (modeline-bg-l
    (if -modeline-bright
        (doom-blend bg base5 0.2)
      `(,(doom-darken (car bg) 0.1) ,@(cdr base0))))
   (modeline-bg-inactive   (doom-darken bg 0.1))
   (modeline-bg-inactive-l `(,(car bg) ,@(cdr base1))))


  ;; --- extra faces ------------------------
  (((region &override) :foreground region-fg)

   ((line-number &override) :foreground base0)
   ((line-number-current-line &override) :foreground base3)
   ((paren-face-match &override) :foreground red :background base3 :weight 'ultra-bold)
   ((paren-face-mismatch &override) :foreground base3 :background red :weight 'ultra-bold)
   ((vimish-fold-overlay &override) :inherit 'font-lock-comment-face :background base3 :weight 'light)
   ((vimish-fold-fringe &override)  :foreground teal)

   (font-lock-comment-face
    :foreground comments
    :background (if doom-nord-aurora-comment-bg (doom-lighten bg 0.05)))
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
   (ediff-fine-diff-A    :background (doom-darken violet 0.4) :weight 'bold)
   (ediff-current-diff-A :background (doom-darken base0 0.25))

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
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)

   ;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))

   ;; org-mode
   (org-hide :foreground hidden)
   (org-block :background bg-alt)
   (org-link :foreground yellow)
   (solaire-org-hide-face :foreground hidden))


  ;; --- extra variables ---------------------
  (
  )
  )

;;; doom-nord-aurora-theme.el ends here
