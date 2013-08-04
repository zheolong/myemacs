;;-------------------------mew邮件管理器-------------------------------------
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))
      

;;-------------------------emacs基本配置------------------------------------
;;设置emacs的插件搜索路径 递归搜索
(defconst my-emacs-path           "~/.emacs.d/" "我的emacs相关配置文件的路径")
(defconst my-emacs-lisps-path  (concat my-emacs-path "mylisps/") "我自己写的emacs lisp包的路径")

;; 可以保存你上次光标所在的位置
(require 'saveplace)
(setq-default save-place t)

;;菜单栏设置
(menu-bar-mode 1) ;;显示菜单栏
;;工具栏设置
(tool-bar-mode -1) ;;不显示工具栏 工具栏太丑
;;滚动条设置
(scroll-bar-mode -1) ;;不显示滚动条 太丑

;语法高亮
(global-font-lock-mode t) 
(which-function-mode t)                 ;在状态条上显示当前光标在哪个函数体内部   
(auto-compression-mode 1)               ;打开压缩文件时自动解压缩          

;; 用一个很大的kill ring. 这样防止我不小心删掉重要的东西
(setq kill-ring-max 1024)
(setq max-lisp-eval-depth 40000)        ;lisp最大执行深度
(setq max-specpdl-size 10000)           ;最大容量
(setq undo-outer-limit 5000000)         ;撤销限制
(setq message-log-max t)                ;设置message记录全部消息, 而不用截去
(setq eval-expression-print-length nil) ;设置执行表达式的长度没有限制
(setq eval-expression-print-level nil)  ;设置执行表达式的深度没有限制


;;emacs的模板系统
(add-to-list 'load-path "~/.emacs.d/mylisps/yasnippet")
(add-to-list 'load-path "~/.emacs.d/mylisps/auto-complete-1.3.1")
(add-to-list 'load-path "~/.emacs.d/mylisps")

(require 'yasnippet)         ;类似TextMate超酷的模版模式
;;(setq yas/snippet-dirs '(yas-snippets yas-snippets-extra)) ;;测试发现不行 不能载入模板文件 不明白原因
;;(setq yas/snippet-dirs '('(concat my-emacs-lisps-path "yasnippet/snippets") '(concat my-emacs-lisps-path "yasnippet/extras/imported")));;同上
(setq yas/snippet-dirs '("~/.emacs.d/mylisps/yasnippet/snippets" "~/.emacs.d/mylisps/yasnippet/extras/imported")) ;;测试发现可以载入模板文件
(yas/global-mode 1)
;; The `dropdown-list.el' extension is bundled with YASnippet, you
;; can optionally use it the preferred "prompting method"
(require 'dropdown-list)
(setq yas/prompt-functions '(yas/dropdown-prompt
			     yas/ido-prompt
			     yas/completing-prompt))

;;自动补全设置
;;http://cx4a.org/software/auto-complete/
(require 'auto-complete)
(require 'ac-dabbrev)
(require 'ac-math) ;;用于latex补全
(add-to-list 'ac-dictionary-directories  (concat my-emacs-lisps-path "auto-complete-1.3.1/dict"))
(require 'auto-complete-config)
(require 'auto-complete+) ;;ahei写的加强auto-complete功能的插件
(require 'auto-complete-extension nil t) ;optional
(require 'auto-complete-yasnippet nil t) ;optional
(require 'auto-complete-etags nil t)     ;optional
;;(require 'auto-complete-cpp nil t) ;optional 这个模式和最新的auto-complete模式冲突
(ac-config-default)

;; The sources for common all mode.
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ac-sources (quote (ac-source-yasnippet ac-source-semantic ac-source-imenu ac-source-abbrev ac-source-words-in-buffer ac-source-files-in-current-dir ac-source-filename)) t)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.bmk")
 '(safe-local-variable-values (quote ((eval add-hook (quote write-file-hooks) (quote time-stamp))))))
(defun ac-common-setup ()
      (setq ac-sources (append ac-sources '(ac-source-dabbrev))))

(add-hook 'auto-complete-mode-hook 'ac-common-setup)

;; The mode that automatically startup.
(setq ac-modes
      '(emacs-lisp-mode lisp-interaction-mode lisp-mode scheme-mode
                        c-mode  c++-mode java-mode org-mode
                        perl-mode cperl-mode python-mode ruby-mode
                        ecmascript-mode javascript-mode php-mode css-mode
                        makefile-mode sh-mode fortran-mode f90-mode ada-mode
                        xml-mode sgml-mode latex-mode
                        haskell-mode literate-haskell-mode
                        asm-mode))

;;;http://code.google.com/p/ac-math  latex模式下补全
;;;;增加补全项到latex-mode补全时用
(defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
  (setq ac-sources
     (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
               ac-sources))
)
(add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup) ;;latex-mode调用时启用补全源增加函数，见上

(setq ac-math-unicode-in-math-p t) ;;use unicode input

 

;;--------------------latex---------------------------------------------
(add-to-list 'load-path "~/.emacs.d/auctex-11.87")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(if (string-equal system-type "windows-nt")
     (require 'tex-mik))

(mapc (lambda (mode)
         (add-hook 'LaTeX-mode-hook mode))
         (list 'auto-fill-mode
               'LaTeX-math-mode
               'linum-mode
           'turn-on-auto-fill
           ))

(add-hook 'LaTeX-mode-hook
              (lambda ()
                (setq TeX-auto-untabify t     ; remove all tabs before saving
                      TeX-engine 'xetex       ; use xelatex default
                      TeX-show-compilation t    ;; display compilation windows
              turn-on-auto-fill t
              )

				(TeX-fold-mode 1)

                (TeX-global-PDF-mode t)       ; PDF mode enable, not plain
                (setq TeX-save-query nil)
                (imenu-add-menubar-index)
                (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))


;(global-set-key (kbd "M-q") 'auto-fill-mode)
(global-set-key (kbd "C-c j") 'auto-fill-mode)

;回车时自动缩进
(setq TeX-newline-function 'newline-and-indent)

;;(setq TeX-view-program-list
;;     '(("acroread" "acroread %s.pdf")))
;;(setq TeX-view-program-selection '((output-pdf "acroread")))
(setq TeX-view-program-list
     '(("okular" "okular %s.pdf")))
(setq TeX-view-program-selection '((output-pdf "okular")))

(setq TeX-fold-env-spec-list 
	(quote (("[comment]" ("comment"))
			("[figure]" ("figure")) 
			("[table]" ("table"))
			("[itemize]"("itemize"))
			("[enumerate]"("enumerate"))
			("[description]"("description"))
			("[overpic]"("overpic"))
			("[tabularx]"("tabularx"))
			("[code]"("code"))
			("[shell]"("shell")))))


;;------------------------reftex-------------------------
(require 'reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq reftex-toc-split-windows-horizontally t) ;;*toc*buffer在左侧。
(setq reftex-toc-split-windows-fraction 0.2)  ;;*toc*buffer 使用整个frame的比例。
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)  
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase mode" t)


;;------------------------predictive智能补全插件-------------------------------------------------
;; predictive install location
     (add-to-list 'load-path "~/.emacs.d/predictive/")
     ;; dictionary locations
     (add-to-list 'load-path "~/.emacs.d/predictive/latex/")
     (add-to-list 'load-path "~/.emacs.d/predictive/texinfo/")
     (add-to-list 'load-path "~/.emacs.d/predictive/html/")
     ;; load predictive package
     (require 'predictive)
;;-------------------------------------------------------------------------

;保存上次退出时emacs的session（桌面环境）
(desktop-save-mode 1)

;;----------------------------cdlatex--------------------------------------
;加入cdlatex，用于emacs数;;;;;;;;;;;;;;;CDLatex;;;;;;;;;;;;
;学公式的编辑，能够自动补全（例如equation）
(add-to-list 'load-path "~/.emacs.d/cdlatex")
(load "cdlatex.el" nil t t)
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
(autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
(autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil)

;;---------------------------yasnippet and auto-complete-------------------
;自动补全工具yasnippet
;; yasnippet
(add-to-list 'load-path "~/.emacs.d/mylisps/yasnippet/")
(require 'yasnippet)
(setq yas/snippet-dirs '("~/.emacs.d/mylisps/yasnippet/snippets" "~/.emacs.d/mylisps/yasnippet/extras/imported"))
(setq yas/prompt-functions 
      '(yas/dropdown-prompt yas/x-prompt yas/completing-prompt yas/ido-prompt yas/no-prompt))
(yas/global-mode 1)
(yas/minor-mode-on)

;; auto complete
(add-to-list 'load-path "~/.emacs.d/mylisps/auto-complete-1.3.1/")
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/mylisps/auto-complete-1.3.1/ac-dict")
(global-auto-complete-mode t)
(ac-config-default)

;;yasnippet-bundle.el里面有别人实现的模板(暂时没用)
;(add-to-list 'load-path "~/.emacs.d/mylisps")
;(require 'yasnippet-bundle)




(defun shk-yas/helm-prompt (prompt choices &optional display-fn)
    "Use helm to select a snippet. Put this into `yas/prompt-functions.'"
    (interactive)
    (setq display-fn (or display-fn 'identity))
    (if (require 'helm-config)
        (let (tmpsource cands result rmap)
          (setq cands (mapcar (lambda (x) (funcall display-fn x)) choices))
          (setq rmap (mapcar (lambda (x) (cons (funcall display-fn x) x)) choices))
          (setq tmpsource
                (list
                 (cons 'name prompt)
                 (cons 'candidates cands)
                 '(action . (("Expand" . (lambda (selection) selection))))
                 ))
          (setq result (helm-other-buffer '(tmpsource) "*helm-select-yasnippet"))
          (if (null result)
              (signal 'quit "user quit!")
            (cdr (assoc result rmap))))
      nil))



;;; use popup menu for yas-choose-value
(require 'popup)

;; add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))

(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))

;;解决yasnippet和cdlatex的兼容问题，这是目前最完美的解决方法
;
; yasnippet
; 
(yas/initialize)
;(yas/load-directory "~/.emacs.d/plugins/yasnippet/snippets")

; this breaks things; use the below advise solution instead
;(add-hook 'org-mode-hook
; 	  (lambda ()
; 	    (org-set-local 'yas/trigger-key [tab])
; 	    (define-key yas/keymap [tab] 'yas/next-field-group)))

; when cdlatex-mode or org-cdlatex-mode are loaded, we need to change
; the behaviour of yas/fallback to call cdlatex-tab

(defun yas/advise-indent-function (function-symbol)
  (eval `(defadvice ,function-symbol (around yas/try-expand-first activate)
           ,(format
             "Try to expand a snippet before point, then call `%s' as usual"
             function-symbol)
           (let ((yas/fallback-behavior nil))
             (unless (and (interactive-p)
                          (yas/expand))
               ad-do-it)))))

(yas/advise-indent-function 'cdlatex-tab)
(yas/advise-indent-function 'org-cycle)
(yas/advise-indent-function 'org-try-cdlatex-tab)
(add-hook 'org-mode-hook 'yas/minor-mode-on)

;;---------------------------markdown-mode---------------------------------
(add-to-list 'load-path my-emacs-lisps-path)
(autoload 'markdown-mode "markdown-mode.el"
    "Major mode for editing Markdown files" t)
(setq auto-mode-alist
    (cons '("\\.md" . markdown-mode) auto-mode-alist)) 

;设置master文件，在多文件管理中，设置master文件的作用是如果你处于其他文件中，编译时默认编译master文件，因为我在做毕设，所以主文件只是一个
;(setq-default TeX-master "/media/SUPER\ BOOTC/latex_thesis/sample-master.tex")


;;---------------------------网络编程--------------------------------------
;;---------------------------web-mode--------------------------------------
(add-to-list 'load-path my-emacs-lisps-path)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))


;;---------------------------zencodeing------------------------------------
;;很强大，大大提高编辑代码效率
(add-to-list 'load-path (concat my-emacs-lisps-path "zencoding/"))
(require 'zencoding-mode)
;; Auto-start on any markup mode
(add-hook 'sgml-mode-hook 'zencoding-mode)

;;---------------------------rainbow-mode------------------------------------
;;自动显示css中的颜色，比如black就显示为黑色
(add-to-list 'load-path "~/.emacs.d/plugins/")
(require 'rainbow-mode)
(dolist (hook '(css-mode-hook html-mode-hook sass-mode-hook))
(add-hook hook 'rainbow-turn-on))

