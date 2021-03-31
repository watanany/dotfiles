;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Shingo Watanabe"
      user-mail-address "s1170087@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;
(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; treemacs のテーマ設定
(setq doom-themes-treemacs-theme "doom-colors")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(use-package! f)

(use-package! lsp-haskell
  :after lsp-mode
  :config (setq lsp-haskell-formatting-provider "fourmolu"))

(use-package! dhall-mode
  :mode "\\.dhall\\'"
  :config (setq dhall-format-at-save nil))

(use-package! evil-cleverparens)

;; FIXME: https://github.com/hlissner/doom-emacs/issues/4555
(use-package! ace-window)

;; emacs のみの環境変数の設定ファイルを読み込む
;; (doom-load-envvars-file "~/.doom.d/myenv")

;; スクロール時に5行分残してスクロールする
(setq scroll-margin 5)

;; 行間の設定
(setq-default line-spacing 0.15)

;;; evilの設定
;; `jj' でevil-insert-stateから抜ける
(setq evil-escape-key-sequence "jj"
      evil-escape-delay 0.3
      ;; 選択モードの時はESCキーシーケンスを無効にする
      evil-escape-inhibit-functions '(evil-visual-state-p)
      ;; モードによってESCキーシーケンスを無効にする
      evil-escape-excluded-major-modes '(dired-mode vterm-mode))

;; 左右キーで一つ前・一つ後の行に移動できるようにする
(setq evil-cross-lines t)

;;; evil-snipeの設定
(evil-define-key '(normal motion) evil-snipe-local-mode-map
  "s" 'evil-snipe-s
  "S" 'evil-snipe-S)
(evil-define-key 'motion evil-snipe-override-local-mode-map
  "f" 'evil-snipe-f
  "F" 'evil-snipe-F)

;; s/Sとf/Fの検索範囲を現在のバッファに設定する
(setq evil-snipe-scope 'buffer
      evil-snipe-repeat-scope 'whole-buffer)

;; s/Sとf/Fを繰り返し使えるようにする
(setq evil-snipe-repeat-keys t
      evil-snipe-override-evil t)

;;; companyの設定
(with-eval-after-load 'company
  ;; Shift + <Space>で補完ポップアップを表示する
  (global-set-key (kbd "S-SPC") 'company-complete)
  ;; 補完ポップアップ上でCtrl-jとCtrl-kを無効にする
  (define-key company-active-map (kbd "C-j") nil)
  (define-key company-active-map (kbd "C-k") nil)
  ;; 補完ポップアップ上でCtrl-nとCtrl-pを有効にする
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  ;; 補完ポップアップの見た目を変更する
  (custom-set-faces
   '(company-tooltip-common
     ((t (:inherit company-tooltip :weight bold :underline nil))))
   '(company-tooltip-common-selection
     ((t (:inherit company-tooltip-selection :weight bold :underline nil))))))

;;; eshellの設定
;; 行指向ではないコマンドを ansi-term で開くようにする
(setq eshell-visual-commands
      '("vi"
        "vim"
        "less"
        "more"
        "top"
        "rlwrap"
        "ghci"
        "ipython"
        "irb"
        "pry"
        ))

(setq eshell-visual-subcommands
      '(("git" "log" "diff" "show" "pretty-log")
        ("stack" "ghci")
        ("ros" "run")
        ))

(setq eshell-visual-options
      '(("stack" "--file-watch")
        ))

;; プロセス終了後に eshell を終了する
(setq eshell-destroy-buffer-when-process-dies t)

;;; sql-postgresの設定
(setq sql-postgres-login-params
      '((server :default "localhost")
        (port :default 5432)
        (user :default "postgres")))

;;; Ligature の設定
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

;;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)

;;; Haskell
;; GHCiでのキーマップ設定
(add-hook 'haskell-interactive-mode-hook
          (lambda ()
            (evil-local-set-key 'insert (kbd "C-p") 'haskell-interactive-mode-history-previous)
            (evil-local-set-key 'insert (kbd "C-n") 'haskell-interactive-mode-history-next)))

;;; Common Lisp
(setq inferior-lisp-program "ros-run")
(add-hook 'lisp-mode-hook #'evil-cleverparens-mode)

;;; Clojure
(add-hook 'clojure-mode-hook #'evil-cleverparens-mode)

