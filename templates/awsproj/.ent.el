;;; .ent.el --- local ent config file -*- lexical-binding: t; -*-

;;; commentary:

;;; code:

;; project settings
(setq ent-project-home (file-name-directory (if load-file-name load-file-name buffer-file-name)))
(setq ent-project-name "awsproj")
(setq ent-clean-regexp "~$")


(task :style '() "check code" "bb style")

(task :format '() "format code" "bb format")

(task :kondo '() "lint with kondo" "bb kondo")

(task :libupdate '() "search for new libs versions" "bb libupdate" )

(task :tests '() "run tests" "bb test")

(task :readme '() "build readme file" "pandoc -o README.md tmp/README.org")

(provide '.ent)
;;; .ent.el ends here

;; local variables:
;; no-byte-compile: t
;; no-update-autoloads: t
;; end:
