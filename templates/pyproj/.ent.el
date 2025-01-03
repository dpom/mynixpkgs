;;; .ent.el --- local ent config file -*- lexical-binding: t; -*-

;;; commentary:

;;; code:

;; project settings
(setq ent-project-home (file-name-directory (if load-file-name load-file-name buffer-file-name)))
(setq ent-project-name "knowledge-insights")
(setq ent-clean-regexp "~$\\|\\.tex$")

(require 'ent)

(ent-tasks-init)

(task 'check '() "check code format" '(lambda (&optional x) "ruff format --check"))

(task 'format '() "format code" '(lambda (&optional x) "ruff format"))

(task 'lint '() "lint code" '(lambda (&optional x) "ruff check"))

(task 'readme '() "build readme file" '(lambda (&optional x) "pandoc -o README.md tmp/README.org"))

(provide '.ent)
;;; .ent.el ends here

;; local variables:
;; no-byte-compile: t
;; no-update-autoloads: t
;; end:
