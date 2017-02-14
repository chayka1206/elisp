;;; --------------------------------------------------------------------------------
;;; package
;;; --------------------------------------------------------------------------------

(require 'package)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)
(require 'cl)
(defvar installing-package-list '(
			       ;;package list
			       linum
			       tabbar
			       hiwin
			       auto-complete
			       popwin
			       rainbow-delimiters
			       anything
			       migemo
			       eldoc
			       rainbow-mode
			       hl-line+
			       magit
			       ag
			       regex-tool
			       material-theme
			       google-translate))
(let ((not-installed (loop for x in installing-package-list
			   when (not (package-installed-p x))
			   collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))



;;;================================================================================
;;; title-insert
;;; init.el 編集用
;;;================================================================================

(defun title-insert()
  (interactive)
  (insert ";;;================================================================================
;;; title
;;; comment
;;;================================================================================"
	  ))

;;;================================================================================
;;; my-config                                                                    
;;;================================================================================

(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

(define-key global-map (kbd "\C-h") 'delete-backward-char)
(define-key key-translation-map (kbd "\C-h") (kbd "<DEL>"))
(define-key global-map (kbd "\C-k") 'kill-whole-line)
(define-key global-map (kbd "\C-c C-k") 'kill-line)
(define-key global-map (kbd "\C-a") 'back-to-indentation)
(define-key global-map (kbd "\C-x C-M-x") 'edebug-defun)
(define-key global-map (kbd "\C-z") 'set-mark-command)
(global-set-key [f8] 'eshell)

(setq scroll-step 1)
(scroll-bar-mode -1)
(menu-bar-mode 1)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; window-split
(defun other-window-or-split()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)

;; all-indent
(defun all-indent()
  (interactive)
  (save-excursion
    (indent-region(point-min)(point-max))))

;; use-region    => cut-region
;; no use-region => backward-kill-word
(defun cut-or-kill-word()
  (interactive)
  (save-excursion
    (if (use-region-p)
	(kill-region (region-beginning) (region-end))
      (backward-kill-word 1))))
(define-key global-map (kbd "\C-w") 'cut-or-kill-word)

;; 行番号の表示
(line-number-mode t)

;; 列番号の表示
(column-number-mode t)

(require 'linum)

;; 行移動を契機に描画
(defvar linum-line-number 0)
(declare-function linum-update-current "linum" ())
(defadvice linum-update-current
    (around linum-update-current-around activate compile)
  (unless (= linum-line-number (line-number-at-pos))
    (setq linum-line-number (line-number-at-pos))
    ad-do-it
    ))

;; バッファ中の行番号表示の遅延設定
(defvar linum-delay nil)
(setq linum-delay t)
(defadvice linum-schedule (around linum-schedule-around () activate)
  (run-with-idle-timer 1.0 nil #'linum-update-current))

;; 行番号の書式
(defvar linum-format nil)
(setq linum-format "%5d")

;; バッファ中の行番号表示
(global-linum-mode t)

;; 文字サイズ
(set-face-attribute 'linum nil :height 0.50)

;;;================================================================================
;;; anything
;;;================================================================================

(require 'anything-config)
(require 'anything-match-plugin)
(require 'anything-startup nil t)
(require 'anything-migemo)
(define-key global-map (kbd "\C-x C-b") 'anything)
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)
(define-key global-map (kbd "\C-c i") 'anything-imenu)
(define-key global-map (kbd "M-x") 'anything-M-x)
(setq desktop-globals-to-save '(extended-command-history))
(setq desktop-files-not-to-save "")
(desktop-save-mode 1)

;;;================================================================================
;;; auto-complete
;;;================================================================================

(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-delay 0.5)
(setq ac-auto-start 4)
(ac-set-trigger-key "TAB")

;;;================================================================================
;;; eldoc
;;;================================================================================

(require 'eldoc)
(require 'eldoc-extension)
(setq eldoc-idle-delay 0.05)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;;;================================================================================
;;; rainbow-mode
;;;================================================================================

(require 'rainbow-mode)
(add-hook 'python-mode-hook 'rainbow-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)

;;;================================================================================
;;; rainbow-delimiters
;;;================================================================================

(require 'rainbow-delimiters)
(defun my-rainbow-delimiters-mode-turn-on ()
  (rainbow-delimiters-mode t))
(add-hook 'emacs-lisp-mode-hook 'my-rainbow-delimiters-mode-turn-on)
(add-hook 'java-mode-hook 'my-rainbow-delimiters-mode-turn-on)
(add-hook 'python-mode-hook 'my-rainbow-delimiters-mode-turn-on)

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ screen - tabbar                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(require 'tabbar)

;; tabbar有効化
(call-interactively 'tabbar-mode t)

;; タブ切替にマウスホイールを使用（0：有効，-1：無効）
(call-interactively 'tabbar-mwheel-mode -1)
(remove-hook 'tabbar-mode-hook      'tabbar-mwheel-follow)
(remove-hook 'mouse-wheel-mode-hook 'tabbar-mwheel-follow)

;; タブグループを使用（t：有効，nil：無効）
(defvar tabbar-buffer-groups-function nil)
(setq tabbar-buffer-groups-function nil)

;; タブの表示間隔
(defvar tabbar-separator nil)
(setq tabbar-separator '(1.0))

;; タブ切り替え
(global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
(global-set-key (kbd "<C-S-iso-lefttab>") 'tabbar-backward-tab)

;; フレーム タイトル
(setq frame-title-format
      '("emacs " emacs-version (buffer-file-name " - %f")))

;; recenter-top-bottomのポジション
(setq recenter-positions '(middle top bottom))

(setq-default truncate-partial-width-windows nil)


(require 'hl-line+)
(toggle-hl-line-when-idle)
(set-face-background 'hl-line "navy")

(require 'my-comment-out)
(define-key global-map (kbd "C-;") 'my-comment-out)
(define-key global-map (kbd "C-x ;") 'my-comment-out)

(require 'google-translate)
(global-set-key (kbd "\C-x C-t") 'google-translate-at-point)
;; 翻訳のデフォルト値を設定（en -> ja）

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
;; ポップアップを画面下に表示
(setq popwin:popup-window-position 'bottom)
;; latex-pdf.elの出力バッファをポップアップ
(push '("*result-latex-pdf*") popwin:special-display-config)
;; Google-translate.elの翻訳バッファをポップアップで表示させる
(push '("*Google Translate*") popwin:special-display-config)

;; aspell
(setq-default ispell-program-name "aspell")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (manoj-dark)))
 '(google-translate-default-source-language "en")
 '(google-translate-default-target-language "ja")
 '(package-selected-packages
   (quote
    (gas-mode hiwin regex-tool ## migemo auto-install popwin google-translate tabbar php-mode hl-line+ anything)))
 '(show-paren-mode t)
 '(tabbar-mode t nil (tabbar))
 '(tabbar-mwheel-mode t nil (tabbar))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Migu 1M" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

(setq org-latex-defult-class "jarticle")

;; (require 'migemo)
;; (setq migemo-command "cmigemo")
;; (setq migemo-options '("-q" "--emacs"))

;; ;; Set your installed path
;; (setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
;; (setq migemo-user-dictionary nil)
;; (setq migemo-regex-dictionary nil)
;; (setq migemo-coding-system 'utf-8-unix)
;; (load-library "migemo")
;; (migemo-init)

;; latex => pdf
(require 'latex-pdf)

;; regex-tool
(require 'regex-tool)

(load-theme 'material t)