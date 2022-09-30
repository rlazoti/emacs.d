;;Copyright (C) 2021 Category <category@[no_spam]quintendo.uk>

;;This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 2.

;;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

;;You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

(defgroup org-roam-search nil
  "Variables for the org-roam-search interface to org-roam databases."
  :group 'applications)

(defcustom org-roam-search-keep-window nil
  "Sets wether or not the search results window should be kept when a link is opened from org-roam-search.

If nil, the window is killed.
If true, the results window is kept.

Defaults to nil."
  :type 'boolean
  :group 'org-roam-search)

(defun org-roam-search (&optional search-term)
  "A function for searching the org-roam-database.

This function will ask user for a search term (grep-style regexp is accepted), then will iterate through all .org files within the org-roam-directory path searching for that pattern wihtin them. Results are displayed in read-only buffer, with links to follow directly.

If called with the argument SEARCH-TERM, user input is skipped and that pattern is searched directly."

  (interactive)

  ;; If old buffer exists, remove window (if it exists), and kill the buffer
  (if (get-buffer "*org-roam-search*")
      (progn
  (if (get-buffer-window "*org-roam-search*")
      (delete-window (get-buffer-window "*org-roam-search*")))
  (kill-buffer "*org-roam-search*")))

  ;; Check if org-roam has been initialized
  (if (not (boundp 'org-roam-directory))
      (error "org-roam-directory is void, has org-roam started?"))
  
  ;; Remember old mini-buffer settings
  ;; Prevents short(ish) output going into minibuffer
  (setq ors-old-mini-resize resize-mini-windows)
  (setq resize-mini-windows nil)

  ;; Get search-term from user if not provided
  (if (not search-term)
      (setq search-term (read-string "Search query: ")))

  ;; Save the search term in external variable for later use/hinting
  (setq org-roam-search-query search-term)

  (generate-new-buffer "*org-roam-search*")

  ;; Grep through all "*.org" files in the org-roam-directory, using search term as a regexp
  (shell-command (format "grep -r -e %s %s" search-term (concat org-roam-directory "/*.org")) "*org-roam-search*")


  ;; If this results in an empty buffer, show no results and throw an error
  (if (eq 0 (buffer-size (get-buffer "*org-roam-search*")))
      (progn
    (set-buffer "*org-roam-search*")
    (insert (format "No results found for search: %s" search-term))
    ;; Restore minibuffer setting before exit
    (setq resize-mini-windows ors-old-mini-resize)
    (error "No org-roam-search results found.")))

  ;; switch buffer (and enable org-mode)
  (set-buffer "*org-roam-search*")
  (org-mode)
  
  ;; Begin looping through search results to make links
  (beginning-of-buffer)
  (while (not (eq (point) (point-max))) ; While not at the end of the buffer...
    (progn
      
      ;; Replace filename in grep results with org link
      (beginning-of-line)
      (insert "[[")
      (goto-char (string-match ".org\:" (buffer-string) (point)))
      (forward-char 5)
      (insert "]]")
      
      ;; Extract current filename from beginning of this line
      (beginning-of-line)
      (setq-local current-link-end (string-match ":" (buffer-string) (point))) 
      (forward-char 2)
      (kill-ring-save (point) (- current-link-end 1)) ; Store on the kill ring without killing
      (setq-local current-file (current-kill 0))
      
      ;; Go to the end of the link, extract org-roam title from within the saved file (using grep again) and format to use as the text for the link
      (goto-char current-link-end)
      (setq-local current-link-title (replace-regexp-in-string "\n$" "" (shell-command-to-string (format "grep -m 1 title %s | cut -c 10-" current-file))))
      (insert (format "[%s]" current-link-title))
      (forward-char)
      (insert " ")
      (beginning-of-line)
      (insert "Node: ")
      
      ;; Go to next line in the file and loop to update the next link
      (next-logical-line)))
  
  ;; Highlight the search term in the results buffer
  (highlight-regexp search-term)
  
  ;; Add info about search/keybinds etc
  (beginning-of-buffer)
  (newline 2)
  (previous-line 2)
  (insert (format "| Open link %s | Next link %s | Prev link %s | Close %s |\nSearch results for query \"%s\""
      (format-kbd-macro (where-is-internal 'org-roam-search-open-link org-roam-search-keymap t))
      (format-kbd-macro (where-is-internal 'org-roam-search-next-link org-roam-search-keymap t))
      (format-kbd-macro (where-is-internal 'org-roam-search-prev-link org-roam-search-keymap t))
      (format-kbd-macro (where-is-internal 'delete-window org-roam-search-keymap t))
      search-term))
  
  ;; Set the buffer read only
  (read-only-mode 1)
  (beginning-of-buffer)

  ;; Enable org-roam-serach-mode for special keybinds
  (org-roam-search-mode t)

  ;; Restore minibuffer setting
  (setq resize-mini-windows ors-old-mini-resize)

  ;; Give search result window focus andstart on first link
  (select-window (get-buffer-window "*org-roam-search*"))
  (org-roam-search-next-link))

(defun org-roam-search--close-or-keep-window ()
  "Closes or keep the org-roam-search results window, based on user preference."
  (interactive)

  (if (not org-roam-search-keep-window)
      (if (get-buffer-window "*org-roam-search*")
    (delete-window (get-buffer-window "*org-roam-search*")))))

(defun org-roam-search-next-link ()
  
  "Navigate to the next link in the org-roam-search results buffer, moving via logical line."
  (interactive)

  ;; Avoid jumping to next line if already on the last-ine of the buffer
  (if (eq (org-current-line) (+ 1 (car (buffer-line-statistics))))
      (error "End of search buffer")
    (next-logical-line))
  
  (beginning-of-line)
  (goto-char (string-match "]\\[" (buffer-string) (point))))

(defun org-roam-search-prev-link ()
  "Navigate to the previous link in the org-roam-search results buffer, moving via logical line."
  (interactive)

  (previous-logical-line)
  (beginning-of-line)
  (goto-char (string-match "]\\[" (buffer-string) (point))))

(defun org-roam-search-open-link ()
  "Open the link at the current point, without highlighting result in the open buffer.

Respect rules for closing the search results window"
  (interactive)

  (org-open-at-point)
  (other-window 1)
  (org-roam-search--close-or-keep-window))

(defun org-roam-search-open-link-hinted ()
  "Open the link at the current point, without highlighting result in the open buffer.

Respect rules for closing the search results window"
  (interactive)

  (org-open-at-point)
  (if org-roam-search-query
      (highlight-regexp org-roam-search-query))
  (other-window 1)
  (org-roam-search--close-or-keep-window))

(setq org-roam-search-keymap (make-sparse-keymap "org-roam-search-keymap"))
(define-key org-roam-search-keymap "q" 'delete-window)
(define-key org-roam-search-keymap "s" 'org-roam-search)
(define-key org-roam-search-keymap "o" 'org-roam-search-open-link)
(define-key org-roam-search-keymap "\r" 'org-roam-search-open-link-hinted) ;For return key
(define-key org-roam-search-keymap "n" 'org-roam-search-next-link)
(define-key org-roam-search-keymap "p" 'org-roam-search-prev-link)

(define-minor-mode org-roam-search-mode
  "org-roam-search-mode provides keybinding and settings for use in results buffers after calling org-roam-search. This mode is not intended for use outside of this purpose."
  :lighter " ors"
  :keymap org-roam-search-keymap
  :interactive t)

(provide 'emacs-org-search)
