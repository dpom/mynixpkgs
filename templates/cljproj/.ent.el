;;; .ent.el --- local ent config file -*- lexical-binding: t; -*-

;;; commentary:

;;; code:

;; project settings
(setq ent-project-home (file-name-directory (if load-file-name load-file-name buffer-file-name)))
(setq ent-project-name "cljproj")

(ent-load-default-tasks)

(task "style"
      :doc "Check code"
      :action "bb style")

(task "format"
      :doc "Format code"
      :action "bb format")

(task "kondo"
      :doc "Lint with kondo"
      :action "bb kondo")

(task "libupdate"
      :doc "Search for new libs versions"
      :action "bb libupdate" )

(task "tests"
      :doc "Run tests"
      :action "bb test")

(task "readme"
      :doc "Build readme file"
      :action "pandoc -o README.md tmp/README.org")

(provide '.ent)
;;; .ent.el ends here

;; local variables:
;; no-byte-compile: t
;; no-update-autoloads: t
;; end:
