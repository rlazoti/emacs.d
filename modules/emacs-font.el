(set-face-attribute 'default nil :font "JetBrains Mono" :height 140)

(let ((ligatures `((?-  . ,(regexp-opt '("-|" "-~" "---" "-<<" "-<" "--" "->" "->>" "-->")))
                   (?/  . ,(regexp-opt '("/**" "/*" "///" "/=" "/==" "/>" "//")))
                   (?*  . ,(regexp-opt '("*>" "***" "*/")))
                   (?<  . ,(regexp-opt '("<-" "<<-" "<=>" "<=" "<|" "<||" "<|||::=" "<|>" "<:" "<>" "<-<"
                                         "<<<" "<==" "<<=" "<=<" "<==>" "<-|" "<<" "<~>" "<=|" "<~~" "<~"
                                         "<$>" "<$" "<+>" "<+" "</>" "</" "<*" "<*>" "<->" "<!--")))
                   (?:  . ,(regexp-opt '(":>" ":<" ":::" "::" ":?" ":?>" ":=")))
                   (?=  . ,(regexp-opt '("=>>" "==>" "=/=" "=!=" "=>" "===" "=:=" "==")))
                   (?!  . ,(regexp-opt '("!==" "!!" "!=")))
                   (?>  . ,(regexp-opt '(">]" ">:" ">>-" ">>=" ">=>" ">>>" ">-" ">=")))
                   (?&  . ,(regexp-opt '("&&&" "&&")))
                   (?|  . ,(regexp-opt '("|||>" "||>" "|>" "|]" "|}" "|=>" "|->" "|=" "||-" "|-" "||=" "||")))
                   (?.  . ,(regexp-opt '(".." ".?" ".=" ".-" "..<" "...")))
                   (?+  . ,(regexp-opt '("+++" "+>" "++")))
                   (?\[ . ,(regexp-opt '("[||]" "[<" "[|")))
                   (?\{ . ,(regexp-opt '("{|")))
                   (?\? . ,(regexp-opt '("??" "?." "?=" "?:")))
                   (?#  . ,(regexp-opt '("####" "###" "#[" "#{" "#=" "#!" "#:" "#_(" "#_" "#?" "#(" "##")))
                   (?\; . ,(regexp-opt '(";;")))
                   (?_  . ,(regexp-opt '("_|_" "__")))
                   (?\\ . ,(regexp-opt '("\\" "\\/")))
                   (?~  . ,(regexp-opt '("~~" "~~>" "~>" "~=" "~-" "~@")))
                   (?$  . ,(regexp-opt '("$>")))
                   (?^  . ,(regexp-opt '("^=")))
                   (?\] . ,(regexp-opt '("]#"))))))
  (dolist (char-regexp ligatures)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

(provide 'emacs-font)
