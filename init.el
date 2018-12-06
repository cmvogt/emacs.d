;;; package: --- init.el
;;; Commentary:

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paths
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lib")
(add-to-list 'load-path "~/share/emacs/site-lisp")

;; Add all top-level subdirectories of .emacs.d to the load path
(progn (cd "~/.emacs.d")
       (normal-top-level-add-subdirs-to-load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'packages)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable auto-save, which produces those #* files.
;;(setq auto-save-default nil)

(if (not (eq system-type 'windows-nt))
    (progn
      ;; Make emacs shell stuff slightly nicer.
      (setenv "PAGER" "/bin/cat")
      (setenv "EDITOR" "/usr/bin/emacsclient"))
  nil
)

(load "server")
(unless (server-running-p) (server-start))

;; View column and line numbers by default
(setq-default line-number-mode t)
(setq-default column-number-mode t)

(global-linum-mode 1)
(setq linum-format "%d\u0020")
;;(setq-default line-spacing 0)

;; No tabs, tab inserts 4 spaces by default
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq auto-revert-mode t)
(global-auto-revert-mode 1)

(menu-bar-mode -1)
(tool-bar-mode -1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EditorConfig
;; https://github.com/editorconfig/editorconfig-emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This requires the editorconfig core to be installed separately.
;; brew install editorconfig || apt-get install editorconfig
(require 'editorconfig)
(load "editorconfig")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rainbow Mode
;; https://elpa.gnu.org/packages/rainbow-mode.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'rainbow-mode)
(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
  (lambda () (rainbow-mode 1)
    )
  )

(my-global-rainbow-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Whitespace Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'whitespace)
(setq whitespace-line-column 100)
(setq fill-column 100)
(global-whitespace-mode 1)
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. try
      ;; (insert-char 182 ) to see it
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT '·', 46 FULL STOP '.'
        (tab-mark 9 [10230 9] [92 9]) ; 9 TAB, 10230 LONG RIGHTWARDS ARROW '⟶ '
        (newline-mark 10 [8629 10]) ; 10 LINE FEED, 8629 DOWNWARDS ARROW WITH CORNER LEFTWARDS '↵''
        ))

(setq whitespace-style (quote
                        (face
                         tabs
                         spaces
                         trailing
                         lines-tail
                         newline
                         ;;indentation::space
                         empty
                         space-mark
                         tab-mark
                         newline-mark)))

(add-hook 'before-save-hook 'whitespace-cleanup)

(defvar background-color "black") ;; Black renders as transparent if
                                  ;; your terminal supports it.
(defvar foreground-color "gray20")
(defvar violation-foreground-color "chartreuse1")

(set-face-attribute 'whitespace-space nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-hspace nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-tab nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-newline nil
                    :background background-color
                    :foreground foreground-color)
(set-face-attribute 'whitespace-trailing nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-line nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-space-before-tab nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-indentation nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-empty nil
                    :background background-color
                    :foreground violation-foreground-color)
(set-face-attribute 'whitespace-space-after-tab nil
                    :background background-color
                    :foreground violation-foreground-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'after-init-hook #'global-flycheck-mode)
;;(setq flycheck-check-syntax-automatically '(mode-enabled save idle-change))
;;(setq flycheck-idle-change-delay 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Autocomplete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;(setq ac-stop-flymake-on-completing t
;      ac-dwim t
;      ac-use-fuzzy t)
;(ac-config-default)
;(global-auto-complete-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company Mode
;; https://company-mode.github.io/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs-ycmd
;; https://github.com/abingham/emacs-ycmd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This won't work on windows without more work.
(if (not (eq system-type 'windows-nt))
    (progn
      (require 'ycmd)
      (add-hook 'after-init-hook #'global-ycmd-mode)
      (set-variable 'ycmd-server-command '("python3.6" "/home/cvogt/src/ycmd/ycmd"))
      (set-variable 'ycmd-extra-conf-whitelist '("/home/cvogt/projects/*"))

      (require 'company-ycmd)
      (company-ycmd-setup)

      (require 'flycheck-ycmd)
      (flycheck-ycmd-setup)
      )
  nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ag (search)
;; https://github.com/Wilfred/ag.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ag)
(setq ag-highlight-search t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'python-mode-hook (lambda () (require 'py)))

;; Change python version for flycheck
(setq flycheck-python-pycompile-executable "python3.6")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JS/JS2 Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
(add-hook 'js-mode-hook (lambda () (require 'javascript)))
(add-hook 'js2-mode-hook (lambda () (require 'javascript)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'json-mode-hook (lambda () (require 'json-config)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Coffee Mode
;; https://github.com/defunkt/coffee-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(add-hook 'coffee-mode-hook (lambda () (require 'coffee)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SASS/SCSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(autoload 'sass-mode "sass" "" t)
;;(autoload 'scss-mode "sass" "" t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Java Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(add-hook 'java-mode-hook (lambda () (require 'java)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Web Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(add-hook 'web-mode-hook (lambda () (require 'web)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(add-hook 'c-mode-common-hook (lambda () (require 'c)))
(setq c-default-style "k&r"
      c-basic-offset 4)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OSX plist bullshit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Allow editing of binary .plist files.
(add-to-list 'jka-compr-compression-info-list
             ["\\.plist$"
              "converting text XML to binary plist"
              "plutil"
              ("-convert" "binary1" "-o" "-" "-")
              "converting binary plist to text XML"
              "plutil"
              ("-convert" "xml1" "-o" "-" "-")
              nil nil "bplist"])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Intel Hex Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'intel-hex-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GTags Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'gtags-mode "gtags" "" t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'helm-cfg-cv)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm-projectile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'helm-projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm
      projectile-enable-caching t)
(helm-projectile-on)

;;For Windows
(if (eq system-type 'windows-nt)
    (setq projectile-indexing-method 'alien
          projectile-file-exists-local-cache-expire (* 5 60)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Projectile Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doxymacs config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (string-equal system-name "cv-VirtualBox")
    (require 'doxymacs)
  ;;(setq doxymacs-use-external-xml-parser t)

    (add-to-list 'doxymacs-doxygen-dirs '("~/win_docs/projects/common/doc/xml/"
                                          "~/win_docs/projects/common/doc/xml/index.xml"
                                          "~/win_docs/projects/common/doc/"))

    (add-hook 'c-mode-common-hook 'doxymacs-mode)
    (defun my-doxymacs-font-lock-hook ()
      (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
          (doxymacs-font-lock)))
    (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook))


;;It is necessary to perform an update!
(jka-compr-update)

;; Load prefered theme
(load-theme 'zenburn t)

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(company-idle-delay 0.1)
 '(custom-safe-themes
   (quote
    ("40f6a7af0dfad67c0d4df2a1dd86175436d79fc69ea61614d668a635c2cd94ab" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(doxymacs-doxygen-style "Qt")
 '(doxymacs-group-comment-end "/**@}*/")
 '(doxymacs-group-comment-start "/**@{*/")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (markdown-mode tern-auto-complete tern js3-mode web-beautify json-mode ggtags helm-ag zenburn-theme yasnippet web-mode volatile-highlights undo-tree solarized-theme rainbow-mode magit helm-projectile guru-mode gist flycheck expand-region exec-path-from-shell elisp-slime-nav editorconfig auto-complete ag ack-and-a-half ace-jump-mode)))
 '(safe-local-variable-values
   (quote
    ((eval setq flycheck-clang-include-path
           (list "/home/cvogt/gecko_sdk_suite/v2.0/protocol/bluetooth_2.6/ble_stack/inc/common" "/home/cvogt/gecko_sdk_suite/v2.0/protocol/bluetooth_2.6/ble_stack/inc/soc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/emlib/inc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/emdrv/common/inc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/emdrv/dmadrv/inc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/emdrv/gpiointerrupt/inc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/emdrv/nvm/inc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/emdrv/ustimer/inc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/emdrv/spidrv/inc" "/home/cvogt/gecko_sdk_suite/v2.0/platform/Device/SiliconLabs/EFR32BG1B/Include" "/home/cvogt/gecko_sdk_suite/v2.0/platform/CMSIS/Include" "/home/cvogt/gecko_sdk_suite/v2.0/platform/bootloader/api" "/home/cvogt/projects/LeftyDev/IAR_LeftyTwo/bgbuild" "/home/cvogt/projects/LeftyDev/LeftyTwo/src" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/accel" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/BIT" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/bluetooth" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/led_drivers" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/lightshow" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/lightshow/EB3" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/pressure" "/home/cvogt/projects/LeftyDev/LeftyTwo/src/spi_flash" "/home/cvogt/projects/LeftyDev/LeftyCommon" "/home/cvogt/projects/LeftyDev/LeftyCommon/accel" "/home/cvogt/projects/LeftyDev/LeftyCommon/pressure" "/home/cvogt/projects/LeftyDev/LeftyCommon/states" "/home/cvogt/projects/common/src/" "/home/cvogt/projects/common/src/accel" "/home/cvogt/projects/common/src/led_drivers" "/home/cvogt/projects/common/src/lightshow" "/home/cvogt/projects/common/src/pressure" "/home/cvogt/projects/common/src/spi_flash" "/home/cvogt/projects/common/src/spi_flash/MX25"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "PfEd" :slant normal :weight normal :height 113 :width normal)))))
