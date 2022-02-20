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
(setq org-directory "~/sanctum/org/")

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


(use-package! dash)
(use-package! f)
(use-package! s)

(use-package! lsp-haskell
  :after lsp-mode
  :config (setq lsp-haskell-formatting-provider "fourmolu"))

(use-package! dhall-mode
  :mode "\\.dhall\\'"
  :config (setq dhall-format-at-save nil))

(use-package! evil-cleverparens
  :init
  (setq evil-cleverparens-use-additional-bindings nil)
  :config
  ;; terminal内のemacs使用時に矢印キーが暴走するのを修正するコード
  ;; cf. <https://github.com/luxbock/evil-cleverparens/issues/58>
  (setq evil-cleverparens-use-additional-bindings t)
  (unless window-system
    (setq evil-cp-additional-bindings (assoc-delete-all "M-[" evil-cp-additional-bindings))
    (setq evil-cp-additional-bindings (assoc-delete-all "M-]" evil-cp-additional-bindings)))
  (evil-cp-set-additional-bindings))

(use-package! protobuf-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode)))
(use-package! graphql-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.graphql\\'" . graphql-mode)))

;; org-modeをGitHub風にマークダウンをエクスポートできるようにする
(use-package! ox-gfm
  :after org-mode)

;; FIXME: <https://github.com/hlissner/doom-emacs/issues/4555>
(use-package! ace-window)

;; FIXME: <https://github.com/hlissner/doom-emacs/issues/3172>
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))

;; FIXME: This package causes strange behavior in Prompt2(iPad app).
;;        'q' is in current cursor position whenever cursor move.
;; (use-package! evil-terminal-cursor-changer
;;   :config
;;   (remove-hook 'tty-setup-hook #'evil-terminal-cursor-changer-activate))

;; FIXME: <https://github.com/emacs-evil/evil/issues/1122>
;; <https://github.com/emacs-evil/evil/issues/1122#issuecomment-740269730>の解決方法。
;; 何度もビジュアルモードでマーカーが出てこなくなる問題が発生しているので、問題発生時は以下の関数を手動で呼び出すようにする。
;; [Space]-; RET (fix-transient-mark-mode)
(defun fix-transient-mark-mode ()
    (setq-local transient-mark-mode t))

;; emacs のみの環境変数の設定ファイルを読み込む
;; (doom-load-envvars-file "~/.doom.d/myenv")

;; スクロール時に5行分残してスクロールする
(setq scroll-margin 5)

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

;; カーソルの色を設定する
(setq evil-normal-state-cursor '(box "light blue")
      evil-insert-state-cursor '(bar "medium sea green")
      evil-visual-state-cursor '(hollow "orange"))

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

;;; Ligatureの設定
;; 表示化けするのでorg-mode時はLigatureを無効にする
(when (boundp '+ligatures-in-modes)
  (let ((disabled-modes '(org-mode markdown-mode ruby-mode)))
    (if (eq (car +ligatures-in-modes) 'not)
        (dolist (mode disabled-modes)
          (add-to-list '+ligatures-in-modes mode t))
      (dolist (mode disabled-modes)
        (delete mode +ligatures-in-modes)))))

;;; Utilities
(defun copy-buffer-file-name ()
  "現在のバッファのファイル名をコピーする関数"
  (kill-new (buffer-file-name)))

(defun projectile-add-projects (dir)
  "projectileプロジェクトにdir直下の全てのプロジェクトを追加する"
  ;; ミニバッファーから引数dirを入力できるようにする
  (interactive (list (read-directory-name "Add to known projects: ")))
  (let ( ;; 引数dir直下のディレクトリのリストを取得する
        (paths
         (-filter #'file-directory-p
                  (file-expand-wildcards (concat dir "*")))))
    ;; プロジェクトのリストを全てprojectileプロジェクトとして追加する
    (dolist (path paths)
      (projectile-add-known-project path))))

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
        "gore"
        "peco"
        "fzf"
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

;; eshell内でBashと同じようにC-k,C-p,C-nを使用できるようにする
(with-eval-after-load 'eshell
  (evil-define-key 'insert eshell-mode-map
    (kbd "C-k") 'kill-line
    (kbd "C-p") 'eshell-previous-matching-input-from-input
    (kbd "C-n") 'eshell-next-matching-input-from-input))

;;; sql-postgresの設定
(setq sql-postgres-login-params
      '((server :default "localhost")
        (port :default 5432)
        (user :default "postgres")))

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

(defvar clojure-built-in-vars
  '(;; clojure.core
    "accessor" "aclone"
    "agent" "agent-errors" "aget" "alength" "alias"
    "all-ns" "alter" "alter-meta!" "alter-var-root" "amap"
    ;; omitted for brevity
    ))

(defvar clojure-built-in-dynamic-vars
  '(;; clojure.test
    "*initial-report-counters*" "*load-tests*" "*report-counters*"
    "*stack-trace-depth*" "*test-out*" "*testing-contexts*" "*testing-vars*"
    ;; clojure.xml
    "*current*" "*sb*" "*stack*" "*state*"
    ))

(font-lock-add-keywords 'clojure-mode
                        `((,(concat "(\\(?:\.*/\\)?"
                                    (regexp-opt clojure-built-in-vars t)
                                    "\\>")
                           1 font-lock-builtin-face)))

(font-lock-add-keywords 'clojure-mode
                        `((,(concat "\\<"
                                    (regexp-opt clojure-built-in-dynamic-vars t)
                                    "\\>")
                           0 font-lock-builtin-face)))

;;; PlantUML
;; 拡張子.puをplantuml-modeに紐づける
(add-to-list 'auto-mode-alist '("\\.pu\\'" . plantuml-mode))
;; FIXME: デフォルトのsvg形式だとplantuml-previewで日本語が表示されなかったため、出力をpng形式へ変更する
(setq plantuml-output-type "png")

;;; JavaScript
;; 拡張子.mjsをjs-modeに紐付ける
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-mode))

;;; org-mode
;; 上付き文字・下付き文字を無効にする
;; cf. https://orgmode.org/manual/Export-Settings.html
(setq org-export-with-sub-superscripts nil)

;; ディレクトリを追加する
(projectile-add-known-project org-directory)

;;; formatter
;; 特定のモードで自動フォーマットを無効にする
(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode             ; elisp's mechanisms are good enough
            sql-mode                    ; sqlformat is currently broken
            tex-mode                    ; latexindent is broken
            latex-mode
            html-mode))
