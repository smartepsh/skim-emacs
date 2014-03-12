;;; Public Domain by Stian Haklev 2014
;;; heavily under construction, mostly built for my own use, but
;;; feel free to improve and make more general
;;; I keep all my academic PDFs in the same directory, and want special
;;; handling for them - eventually I'll check if the PDF is in that dir
;;; and if not, I'll insert the whole path in the org-link etc.

(setq skim-pdf-path "~/Bibdesk")
(org-add-link-type "bib" 'org-skim-open)

(defun skim-page (&optional offset)
  (interactive)
  (when (not offset) (setq offset 1))
  (do-applescript (format "
tell document 1 of application \"Skim\" to set a to index of current page
tell document 1 of application \"Skim\" to go to page (a + %d)
a" offset)))

(defun skim-page-absolute (offset)
  (interactive)
  (do-applescript (format "
tell document 1 of application \"Skim\" to set a to index of current page
tell document 1 of application \"Skim\" to go to page %d
a" offset)))

(defun skim-get-highlights ()
  (interactive)
  (insert (do-applescript "
tell application \"Skim\"
	set pageNotes to notes of page 3 of document 1
	set out to \"\"
	repeat with i in pageNotes
		set txt to get text of i
		set out to out & txt & \"\n\n\"
	end repeat
end tell
out")))

(defun skim-current-page ()
  (interactive)
  (skim-page 0))

(defun skim-current-file ()
  (interactive)
  (do-applescript "tell document 1 of application \"Skim\" to set a to name
a"))

(defun skim-next-page ()
  (interactive)
  (skim-page 1))

(defun skim-prev-page ()
  (interactive)
  (skim-page -1))

(defun skim-insert-link ()
  (interactive)
  (insert (concat "[[bib:" (substring (skim-current-file) 0 -4) "#" (number-to-string (skim-current-page)) "][p. " (number-to-string (skim-current-page)) "]] ")))

(defun skim-kill-other-windows ()
  (interactive)
  (do-applescript "
tell application \"Skim\"
	set mainID to id of front window
	-- insert your code
	close (every window whose id ≠ mainID)
end tell"))

(defun org-skim-open (my-path)
  (interactive)
  (shell-command (concat "open " skim-pdf-path "/" (car (split-string my-path "#")) ".pdf"))
  (skim-page-absolute (string-to-number (nth 1 (split-string my-path "#"))))
  (skim-kill-other-windows)
  (sleep-for 0 100)
  (do-applescript "tell application \"Emacs\" to activate")
  (delete-other-windows))

(setq skim-minor-mode-keymap (make-sparse-keymap))
(define-key skim-minor-mode-keymap (kbd "M-<next>") 'skim-next-page)
(define-key skim-minor-mode-keymap (kbd "M-<prior>") 'skim-prev-page)
(define-key skim-minor-mode-keymap (kbd "M-l") 'skim-insert-link)
(define-key skim-minor-mode-keymap (kbd "M-i") 'skim-get-highlights)

(define-minor-mode skim-minor-mode "Mode for controlling Skim PDF reader" nil "Skim" skim-minor-mode-keymap)

(provide 'skim)
