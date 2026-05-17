;;; .ent.el --- local ent config file -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


;; project settings
(setq ent-project-home (file-name-directory (if load-file-name load-file-name buffer-file-name)))
(setq ent-project-name "mynixpkgs")
(setq ent-clean-regexp ".*~$\\|.*sync-conflict.*$")

(ent-load-default-tasks)

;; Aux functions


;; Tasks


(provide '.ent)
;;; .ent.el ends here

;; Local Variables:
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
