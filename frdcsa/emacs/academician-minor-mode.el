(add-hook 'doc-view-minor-mode-hook 'academician-minor)

(defun academician-minor ()
 ""
 (interactive)
 (if (not (derived-mode-p 'academician-minor-mode))
  (progn 
   (academician-minor-mode))))

(defvar academician-minor-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Toggle between text and image display or editing
    (define-key map (kbd "C-c C-c") 'academician-toggle-display)
    map)
  "Keymap used by `doc-minor-view-mode'.")

(define-minor-mode academician-minor-mode
  "Toggle displaying buffer via Doc View (Doc View minor mode).
With a prefix argument ARG, enable Doc View minor mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

See the command `academician-minor-mode' for more information on this mode."
  nil " Academician" academician-minor-mode-map
  :group 'academician
  (when academician-minor-mode
    (add-hook 'change-major-mode-hook (lambda () (academician-minor-mode -1)) nil t)
    (message
     "%s"
     (substitute-command-keys
      "Type \\[academician-toggle-display] to toggle between editing or viewing the document."))

   (define-key academician-minor-mode-map "\C-c\C-t" 'academician-mode)))

(provide 'academician-minor-mode)
