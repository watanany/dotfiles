;;; $DOOMDIR/mojo-mode.el -*- lexical-binding: t; -*-
;; Mojo

(defgroup mojo-mode nil
  "Major mode for editing Mojo file."
  :group 'languages)

;; Mojoのキーワード、関数、タイプを定義
(defvar mojo-extra-keywords
  '("self" "let" "var" "fn" "struct" "owned" "inout" "borrowed" "^"))

(defvar mojo-extra-functions
  '())

(defvar mojo-extra-types
  '("PythonObject"
    "Self"
    "Error"
    "SIMD"
    "Bool"
    "DTypePointer"
    "DType"
    "Float16"
    "Float32"
    "Float64"
    "Int8"
    "Int16"
    "Int32"
    "Int64"
    "UInt8"
    "UInt16"
    "UInt32"
    "UInt64"
    "String"
    "DynamicVector"
    "Int"
    "FloatLiteral"
    "ListLiteral"
    "Tuple"
    "Slice"))



;; 追加のシンタックスハイライトのルールを定義
(defvar mojo-font-lock-extra-keywords
  (let* ((fns-regexp (concat
                      "\\_<fn\\_>"
                      "\\s-+"
                      "\\(\\_<\\w+\\_>\\)")))
    `((,(regexp-opt mojo-extra-keywords 'words) . font-lock-keyword-face)
      (,(regexp-opt mojo-extra-functions 'words) . font-lock-function-name-face)
      (,(regexp-opt mojo-extra-types 'words) . font-lock-type-face)
      (,fns-regexp . (1 font-lock-function-name-face))
      )))

(defun mojo-indent-line ()
  "Indent current line for a simplified Mojo mode considering only colons."
  (interactive)
  (let ((current-point (point))
        (indent-level 0))
    (save-excursion
      (beginning-of-line)
      (if (bobp)
          (setq indent-level 0)
        (forward-line -1)
        (if (looking-at ".*:$")
            (setq indent-level (+ (current-indentation) 4))
          (setq indent-level (current-indentation)))))
    (print "DEBUG-DEBUG-DEBUG")
    (indent-line-to indent-level)
    (skip-chars-forward " \t")))

;;;###autoload
(define-derived-mode mojo-mode python-mode "Mojo"
  "Major mode for editing Mojo code derived from python-mode."
  (font-lock-add-keywords nil mojo-font-lock-extra-keywords)
  (setq-local indent-line-function 'mojo-indent-line))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.mojo\\'" . mojo-mode))

(provide 'mojo-mode)
