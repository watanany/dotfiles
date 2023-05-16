;;; $DOOMDIR/golazo-mode.el -*- lexical-binding: t; -*-
;; Golazo v2

(defgroup golazo-v2-mode nil
  "Major mode for editing Golazo v2 file."
  :group 'languages)

(defvar golazo-v2-mode-syntax-table
  (let ((table (make-syntax-table)))
    table))

(defun golazo-v2-types ()
  '("Bool" "Natural" "Float" "Text" "URL" "UUID" "ISO8601" "ISO3166"
    "Maybe" "List"))

(defun golazo-v2-functions ()
  '("get" "post" "put" "delete" "note" "match" "satisfy" "not"))

(defun golazo-v2-keywords ()
  '("forall" "exists" "in" "&" "and" "or"))

(defun golazo-v2-font-lock-keywords ()
  (list
   `(,(regexp-opt (golazo-v2-keywords) 'symbols) . font-lock-keyword-face)
   `(,(regexp-opt (golazo-v2-types) 'symbols)  . font-lock-type-face)
   `(,(regexp-opt (golazo-v2-functions) 'symbols) . font-lock-function-name-face)
   `("@include" . font-lock-preprocessor-face)
   `("#.*" . font-lock-comment-face)                       ;; "#"以降の文字列
   `("/{\\(\\w+\\)}/" . (1 font-lock-variable-name-face))  ;; 関数の引数(パス形式)
   `("\\\\\\(\\w+\\)" . (1 font-lock-variable-name-face))  ;; 無名関数の引数
   ))

;;;###autoload
(define-derived-mode golazo-v2-mode prog-mode "Golazo v2"
  "Major mode for editing Golazo-V2 code."
  :syntax-table golazo-v2-mode-syntax-table
  (setq-local font-lock-defaults '(golazo-v2-font-lock-keywords)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.gol\\'" . golazo-v2-mode))

(provide 'golazo-v2-mode)
 ;;; golazo-v2-mode.el ends here
