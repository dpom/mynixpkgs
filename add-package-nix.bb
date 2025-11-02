#!/usr/bin/env bb

(require
  '[babashka.process :refer [shell]]
  '[clojure.string :as str]
  '[babashka.fs :as fs]) 

(defn shell-to-string
  [cmd]
  (->> cmd
       (shell {:out :string})
       :out
       str/split-lines
       first))

(defn run
  [package-path]
  (->> package-path
      fs/absolutize
      (str "nix-prefetch-url --type sha256 file:///")
      shell-to-string
      (str "nix-hash --type sha256 --to-sri ")
      shell)
  (System/exit 0))

(let [arg (first *command-line-args*)]
  (when (empty? arg)
    (println "Usage:add-package-nix.bb <package-path>")
    (System/exit 1))
  (run arg))
