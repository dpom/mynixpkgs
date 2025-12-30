;;; .ent.el --- local ent config file -*- lexical-binding: t; -*-

;;; commentary:

;;; code:

;; project settings
(setq ent-project-home (file-name-directory (if load-file-name load-file-name buffer-file-name)))
(setq ent-project-name "pyproject")

(ent-load-default-tasks)

(task "check"
      :doc "Check code format"
      :action "ruff format --check")

(task "format"
      :doc "Format code"
      :action "ruff format")

(task "lint"
      :doc "Lint code"
      :action "ruff check")

(task "readme"
      :doc "Build readme file"
      :action "pandoc -o README.md tmp/README.org")

(provide '.ent)
;;; .ent.el ends here

;; local variables:
;; no-byte-compile: t
;; no-update-autoloads: t
;; end:
