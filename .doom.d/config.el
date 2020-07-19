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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

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

;; スクロール時に5行分残してスクロールする
(setq-default scroll-margin 5)

;; `jj' でevil-insert-stateから抜ける
(setq-default evil-escape-key-sequence "jj"
              evil-escape-delay 0.3
              ;; 選択モードの時はESCキーシーケンスを無効にする
              evil-escape-inhibit-functions '(evil-visual-state-p)
              ;; モードによってESCキーシーケンスを無効にする
              evil-escape-excluded-major-modes '(dired-mode))

;; 左右キーで一つ前・一つ後の行に移動できるようにする
(setq-default evil-cross-lines t)

;;; evil-snipeの設定を行う
(evil-define-key '(normal motion) evil-snipe-local-mode-map
  "s" 'evil-snipe-s
  "S" 'evil-snipe-S)
(evil-define-key 'motion evil-snipe-override-local-mode-map
  "f" 'evil-snipe-f
  "F" 'evil-snipe-F)

;; s/Sとf/Fの検索範囲を現在のバッファに設定する
(setq-default evil-snipe-scope 'buffer
              evil-snipe-repeat-scope 'whole-buffer)

;; s/Sとf/Fを繰り返し使えるようにする
(setq-default evil-snipe-repeat-keys t
              evil-snipe-override-evil t)

;;; companyの設定
(with-eval-after-load "company"
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

(after! haskell-mode
  (set-company-backend! 'haskell-mode 'company-dabbrev-code))
