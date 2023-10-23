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

;; 追加ライブラリの読み込みパスの設定
;; NOTE: 相対パスだとエラーになるケースがある(?)
(add-load-path! "~/.doom.d/lisp")
(add-load-path! "~/.doom.d/lisp/copl-mode")

(use-package! dash)
(use-package! f)
(use-package! s)

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

;; TODO:
;; (use-package! pangu-spacing
;;   :config
;;   (dolist (mode '(python-mode))
;;     (add-to-list 'pangu-spacing-inhibit-mode-alist mode)))

(use-package! projectile
  :config
  (dolist (file '("spago.dhall" "go.mod"))
    (add-to-list 'projectile-project-root-files file)))

(use-package! lsp-haskell
  :after lsp-mode
  :config (setq lsp-haskell-formatting-provider "fourmolu"))

(use-package! command-log-mode
  :config
  ;; emacsのコマンドのログを取るようにする
  ;; (clm/toggle-command-log-buffer)で表示する
  (global-command-log-mode))

(use-package! fish-mode
  :mode "\\.fish\\'")

(use-package! dhall-mode
  :mode "\\.dhall\\'"
  :config (setq dhall-format-at-save nil))

(use-package! protobuf-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode)))

(use-package! graphql-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.graphql\\'" . graphql-mode)))

(use-package! mermaid-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.mmd\\'" . mermaid-mode)))

(use-package! hy-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.hy\\'" . hy-mode)))

;; org-modeをGitHub風にマークダウンをエクスポートできるようにする
;; org-gfm-export-as-markdown
(use-package! ox-gfm
  :after org-mode)

(use-package! ox-pandoc
  :after org-mode)

(use-package! org-pandoc-import :after org)

;; magitでのdiffを見やすくする
(use-package! magit-delta
  :hook (magit-mode . magit-delta-mode))

;; TabNineによる自動補完を有効にする
;; M-x company-tabnine-install-binaryでTabNineをインストールする必要がある
;; (use-package! company-tabnine
;;   :config
;;   (add-to-list 'company-backends #'company-tabnine)
;;   (setq company-idle-delay 0)
;;   (setq company-show-quick-access t))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(use-package! org-preview-html)

(use-package! golazo-v2-mode)

(use-package! copl-mode)

;; FIXME: This package causes strange behavior in Prompt2(iPad app).
;;        'q' is in current cursor position whenever cursor move.
;; (use-package! evil-terminal-cursor-changer
;;   :config
;;   (remove-hook 'tty-setup-hook #'evil-terminal-cursor-changer-activate))

;; FIXME: <https://github.com/emacs-evil/evil/issues/1122>
;; <https://github.com/emacs-evil/evil/issues/1122#issuecomment-740269730>の解決方法。
;; 何度もビジュアルモードでマーカーが出てこなくなる問題が発生しているので、問題発生時は以下の関数を手動で呼び出すようにする。
;; [Space]-; RET (fix-transient-mark-mode!)
(defun fix-transient-mark-mode! ()
  (setq-local transient-mark-mode t))

;; FIXME: <https://github.com/akermu/emacs-libvterm/pull/617>
;; 変更はマージされているので、更新が適用されたら以下のコードは削除する
(after! vterm
  (defconst vterm-control-seq-regexp
    (concat
     ;; A control character,
     "\\(?:[\r\n\000\007\t\b\016\017]\\|"
     ;; a C1 escape coded character (see [ECMA-48] section 5.3 "Elements
     ;; of the C1 set"),
     "\e\\(?:[DM78c=]\\|"
     ;; another Emacs specific control sequence for term.el,
     "AnSiT[^\n]+\n\\|"
     ;; another Emacs specific control sequence for vterm.el
     ;; printf "\e]%s\e\\"
     "\\][^\e]+\e\\\\\\|"
     ;; or an escape sequence (section 5.4 "Control Sequences"),
     "\\[\\([\x30-\x3F]*\\)[\x20-\x2F]*[\x40-\x7E]\\)\\)")
    "Regexp matching control sequences handled by term.el."))

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

;; evilのinsert状態でC-kでカーソルから行末までの文字を削除する
;; (evil-define-key 'insert 'global
;;   (kbd "C-k") 'kill-line)

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

;; カーソルの点滅を無効にする
(blink-cursor-mode 0)

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

;;; 言語によって、「_」を単語の一部として扱うように設定する
(let ((hooks '(org-mode-hook
               sh-mode
               fish-mode
               python-mode-hook
               ruby-mode-hook
               go-mode-hook
               rjsx-mode-hook
               js2-mode-hook
               sql-mode
               json-mode-hook
               yaml-mode-hook
               terraform-mode-hook
               dhall-mode
               html-mode-hook
               css-mode-hook)))
  (dolist (hook hooks)
    (add-hook hook #'(lambda () (modify-syntax-entry ?_ "w")))))

;;; Utilities
(defun my/copy-buffer-file-name ()
  "現在のバッファのファイル名をコピーする関数"
  (kill-new (buffer-file-name)))

(defun my/projectile-add-projects (dir)
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

;;; Hy
(add-hook 'hy-mode-hook #'evil-cleverparens-mode)
;;; PlantUML
;; 拡張子.puをplantuml-modeに紐づける
(add-to-list 'auto-mode-alist '("\\.pu\\'" . plantuml-mode))
;; FIXME: デフォルトのsvg形式だとplantuml-previewで日本語が表示されなかったため、出力をpng形式へ変更する
(setq plantuml-output-type "png")

;;; Ruby
;; flycheck checkerに `bundle exec rubocop' を使うようにする
;; cf. <https://emacs.stackexchange.com/a/60804>
;; (add-hook 'ruby-mode-hook
;;           (lambda ()
;;             (setq-local flycheck-command-wrapper-function
;;                         (lambda (commands) (append '("bundle" "exec") commands)))))

;; flycheckのrubocopを無効にする
;; NOTE: 無効にしないとflycheckが何度もrubocop関係のエラーを出す
(if (boundp 'flycheck-disabled-checkers)
    (add-to-list 'flycheck-disabled-checkers 'ruby-rubocop)
  (setq flycheck-disabled-checkers '(ruby-rubocop)))
;;; JavaScript
;; 拡張子.mjsをJavaScriptとして扱うようにする
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js2-mode))

;;; org-mode
;; 上付き文字・下付き文字を無効にする
;; cf. <https://orgmode.org/manual/Export-Settings.html>
(setq org-export-with-sub-superscripts nil)
(setq org-image-actual-width nil)

;;; formatter
;; 特定のモードで自動フォーマットを無効にする
(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode             ; elisp's mechanisms are good enough
        sql-mode                    ; sqlformat is currently broken
        tex-mode                    ; latexindent is broken
        latex-mode
        html-mode
        yaml-mode
        ruby-mode
        haskell-mode
        typescript-mode
        ))

;;; markdown
(cl-case system-type
  ('darwin (setq markdown-open-command "~/.local/bin/marked2")))

;;; DigDag
;; 拡張子.dagをyaml-modeに紐づける
(add-to-list 'auto-mode-alist '("\\.dig\\'" . yaml-mode))

;;; プロジェクトの設定
(projectile-add-known-project org-directory)
(projectile-add-known-project "~/dotfiles")
(my/projectile-add-projects "~/sanctum/projects")
