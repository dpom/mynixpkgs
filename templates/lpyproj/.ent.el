;;; .ent.el --- local ent config file -*- lexical-binding: t; -*-

;;; commentary:

;;; code:

;; project settings
(setq ent-project-home (file-name-directory (if load-file-name load-file-name buffer-file-name)))
(setq ent-project-name "lpyproj")
(setq ent-clean-regexp "~$")

(ent-load-default-tasks)


(task "style"
      :doc "check code"
      :action "bb style")

(task "format"
      :doc "format code"
      :action "bb format")

(task "kondo"
      :doc "lint with kondo"
      :action "bb kondo")

(task "tests"
      :doc "run tests"
      :action "bb test")

(task "readme"
      :doc "build readme file"
      :action "pandoc -o README.md tmp/README.org")

(provide '.ent)
;;; .ent.el ends here

;; local variables:
;; no-byte-compile: t
;; no-update-autoloads: t
;; end:
