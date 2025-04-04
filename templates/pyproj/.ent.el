;;; .ent.el --- local ent config file -*- lexical-binding: t; -*-

;;; commentary:

;;; code:

;; project settings
(setq ent-project-home (file-name-directory (if load-file-name load-file-name buffer-file-name)))
(setq ent-project-name "pyproject")
(setq ent-clean-regexp "~$")

(task :check '() "check code format" "ruff format --check")

(task :format '() "format code" "ruff format")

(task :lint '() "lint code" "ruff check")

(task :readme '() "build readme file" "pandoc -o README.md tmp/README.org")

(provide '.ent)
;;; .ent.el ends here

;; local variables:
;; no-byte-compile: t
;; no-update-autoloads: t
;; end:
