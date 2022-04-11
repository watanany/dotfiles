;;; $DOOMDIR/golazo-mode.el -*- lexical-binding: t; -*-

(defvar golazo-mode-syntax-table
  (let ((table (make-syntax-table)))
    table))

(defun golazo-types ()
  '("Bool" "Natural" "Float" "Text" "URL" "UUID" "ISO8601" "ISO3166"
    "Maybe" "List"))

(defun golazo-functions ()
  '("get" "post" "put" "delete" "note" "match" "satisfy" "not"))

(defun golazo-keywords ()
  '("forall" "exists" "in" "&" "and" "or"))

(defun golazo-font-lock-keywords ()
  (list
   `(,(regexp-opt (golazo-keywords) 'symbols) . font-lock-keyword-face)
   `(,(regexp-opt (golazo-types) 'symbols)  . font-lock-type-face)
   `(,(regexp-opt (golazo-functions) 'symbols) . font-lock-function-name-face)
   `("@include" . font-lock-preprocessor-face)
   `("#.*" . font-lock-comment-face)                       ;; #以降はアノテーション
   `("\\\\\\(\\w+\\)" . (1 font-lock-variable-name-face))  ;; 関数の引数
   `("/{\\(\\w+\\)}/" . (1 font-lock-variable-name-face))  ;; 関数の引数(パス形式)
   ))

(define-derived-mode golazo-mode prog-mode "Golazo"
  "Simple major mode for editing Golazo files."
  :syntax-table golazo-mode-syntax-table
  (setq-local font-lock-defaults '(golazo-font-lock-keywords)))

(provide 'golazo-mode)
 ;;; golazo-mode.el ends here
