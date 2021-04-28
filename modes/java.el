;;; java.el --- java-mode configs

;;; Commentary:

;;; Code:

;;(setq indent-tabs-mode t)
(setq whitespace-line-column 100) ;; Java can be verbose.
(setq c-basic-offset 4)
(setq indent-tabs-mode nil)
(setq tab-width 4)


(require 'java-mode)

(add-to-list 'ac-modes 'java-mode) ;; Java-mode is not one of the default auto-complete modes.

(provide 'java)
;;; java.el ends here
