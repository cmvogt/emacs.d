;;; py.el --- configs for python-mode

;;; Commentary:

;;; Code:
(message "PY")

;;(ensure-module-deps '(elpy flycheck))
(ensure-module-deps '(flycheck))
(package-initialize)
;;(elpy-enable)

;; Disable tab characters, set default tab spacing to 4 chars wide.
;; This is the default in init.el already.

(setq python-shell-interpreter "python3.6")

(setq indent-tabs-mode nil)
(setq tab-width 4)
(setq python-indent 4)

(provide 'py)
;;; py.el ends here
