(defvar academician-cycle-choice-last nil)

(define-derived-mode academician-mode
 doc-view-mode "Academician"
 "Major mode for research.
\\{academician-mode-map}"
 (setq case-fold-search nil)
 (define-key academician-mode-map (kbd "aa") 'academician-analyze-region)
 (define-key academician-mode-map (kbd "an") 'academician-declare-page-of-document-read)
 (define-key academician-mode-map (kbd "ae") 'academician-declare-currently-reading-document)
 (define-key academician-mode-map (kbd "aE") 'academician-retract-currently-reading-document)
 (define-key academician-mode-map (kbd "aS") 'academician-declare-page-of-document-partly-read)
 (define-key academician-mode-map (kbd "as") 'academician-declare-page-of-document-skimmed)
 (define-key academician-mode-map (kbd "aN") 'academician-declare-page-of-document-unread)
 (define-key academician-mode-map (kbd "af") 'academician-declare-desire-to-formalize-text-from-digilib)
 (define-key academician-mode-map (kbd "kc") 'academician-assert-kbfs-knowledge-comment-from-text)
 (define-key academician-mode-map (kbd "ka") 'academician-assert-kbfs-knowledge)
 (define-key academician-mode-map (kbd "kv") 'academician-view-kbfs-knowledge)
 (define-key academician-mode-map (kbd "ax") 'academician-process-document-with-knext)
 (define-key academician-mode-map (kbd "aX") 'academician-display-knext-processing-result)
 (define-key academician-mode-map (kbd "ar") 'academician-reload-document)
 (define-key academician-mode-map (kbd "ac") 'academician-search-for-citation)
 (define-key academician-mode-map (kbd "ap") 'academician-page-read-p)
 (define-key academician-mode-map (kbd "aP") 'academician-next-unread-page)
 (define-key academician-mode-map (kbd "aR") 'academician-show-pages-read)
 (define-key academician-mode-map (kbd "av") 'academician-view-kbfs-knowledge)
 (define-key academician-mode-map (kbd "at") 'academician-see-title-of-publication)
 (define-key academician-mode-map (kbd "aF") 'academician-push-buffer-file-name-to-stack)
 (define-key academician-mode-map (kbd "aT") 'academician-override-title)
 (define-key academician-mode-map (kbd "ay") 'academician-cycle-next-publication)
 (define-key academician-mode-map (kbd "aY") 'academician-cycle-previous-publication)
 (define-key academician-mode-map (kbd "ao") 'academician-choose-reading-topic)
 (define-key academician-mode-map (kbd "aq") 'academician-make-citation)

 (define-key academician-mode-map (kbd "ad") 'academician-formalize-current-document)

;;  (define-key academician-mode-map (kbd "a"))
 (define-key academician-mode-map (kbd "cb") 'clear-queue-current-buffer-referent)
 (define-key academician-mode-map (kbd "cp") 'clear-pause)
 ;; (define-key academician-mode-map (kbd "li") 'academician-index-document)
 ;; (define-key academician-mode-map (kbd "lr") 'academician-retrieve-document-for-analysis-from-url-at-point)
 (define-key academician-mode-map (kbd "lt") 'academician-search-papers)
 (define-key academician-mode-map (kbd "lp") 'academician-choose-paper)
 ;; (define-key academician-mode-map (kbd "lR") 'academician-w3m-view-html-with-doc-view-mode)
 (define-key academician-mode-map (kbd "lc") 'academician-search-for-citation)
 (define-key academician-mode-map (kbd "lx") 'academician-lookup-publication-on-citeseer-x)
 (define-key academician-mode-map (kbd "lst") 'academician-see-title-of-publication)
 (define-key academician-mode-map (kbd "lsp") 'academician-see-parscit-results)
 (define-key academician-mode-map (kbd "lse") 'academician-extract-parscit-value)

 (define-key academician-mode-map (kbd "aG") 'nlu-mf-sync-texts-pagenos)
 )

(defun academician ()
 ""
 (interactive)
 (if (not (derived-mode-p 'academician-mode))
  (progn 
   (academician-mode))))

(add-hook 'doc-view-mode-hook 'academician)

;; (setq auto-mode-alist
;;  (cons '("\\.\\(?:PDF\\|DVI\\|OD[FGPST]\\|DOCX?\\|XLSX?\\|PPTX?\\|pdf\\|dvi\\|od[fgpst]\\|docx?\\|xlsx?\\|pptx?\\)\\'" . academician-mode)
;;   auto-mode-alist))

(global-set-key "\C-cnlT" 'academician-jump-to-any-pdf)

(global-set-key "\C-cnar" 'academician-start-reading)
(global-set-key "\C-cnli" 'academician-index-document)
(global-set-key "\C-cnlr" 'academician-retrieve-document-for-analysis-from-url-at-point)
(global-set-key "\C-cnla" 'academician-get-actual-url)
(global-set-key "\C-cnlt" 'academician-search-papers)
(global-set-key "\C-cnlp" 'academician-choose-paper)
(global-set-key "\C-cnlR" 'academician-w3m-view-html-with-doc-view-mode)
(global-set-key "\C-cnlc" 'academician-search-for-citation)
(global-set-key "\C-cnlx" 'academician-lookup-publication-on-citeseer-x)
(global-set-key "\C-cnlst" 'academician-see-title-of-publication)
(global-set-key "\C-cnlsp" 'academician-see-parscit-results)
(global-set-key "\C-cnlse" 'academician-extract-parscit-value)
(global-set-key "\C-cnl3" 'academician-divide-into-three-windows)
(global-set-key "\C-cnsx" 'academician-set-default-context)
(global-set-key "\C-cnsd?" 'academician-declare-has-question)
(global-set-key "\C-cnsdc" 'academician-declare-requires-clarification)
(global-set-key "\C-cnsdd" 'academician-declare-requires-definition-of-item-on-top-of-stack)
(global-set-key "\C-cnsda" 'academician-declare-academic-research-interest-in-item-on-top-of-stack)
(global-set-key "\C-cnsdi" 'academician-declare-isa-for-item-on-top-of-stack)
(global-set-key "\C-cnsdr" 'academician-declare-desire-to-read-document)
(global-set-key "\C-cnsdt" 'academician-declare-desire-to-obtain-title)
(global-set-key "\C-cnsdR" 'academician-declare-document-read)
(global-set-key "\C-cnsdS" 'academician-declare-document-skimmed)
(global-set-key "\C-cnsdg" 'academician-declare-currently-reading-document)
(global-set-key "\C-cnsdk" 'academician-declare-desire-to-know-more-about-item-on-top-of-stack)
(global-set-key "\C-cnsdK" 'academician-declare-desire-to-review-item-on-top-of-stack)
(global-set-key "\C-cnsdu" 'academician-declare-item-on-top-of-stack-is-understood)
(global-set-key "\C-cnsdp" 'academician-declare-desire-to-have-software)
(global-set-key "\C-cnsdP" 'academician-declare-desire-to-have-software-implementing-capability)
(global-set-key "\C-cnsdx" 'academician-declare-desire-to-have-software-implementing-capability-described-in-current-document)
(global-set-key "\C-cnpu" 'academician-extract-all-urls-from-document)
(global-set-key "\C-cnpU" 'academician-extract-all-urls-from-document-and-open-in-firefox)
(global-set-key "\C-cnpa" 'academician-extract-all-abbrev-from-document)
(global-set-key "\C-cnpp" 'academician-declare-page-of-document-read)
(global-set-key "\C-cnps" 'academician-declare-page-of-document-skimmed)
(global-set-key "\C-cnpS" 'academician-declare-page-of-document-partly-read)
(global-set-key "\C-cnpN" 'academician-declare-page-of-document-unread)
(global-set-key "\C-cnpf" 'academician-declare-desire-to-formalize-text-from-digilib)
(global-set-key "\C-cnpP" 'academician-page-read-p)
;; (global-set-key "\C-cntosg" 'academician-search-google-for-topic-on-top-of-stack)
;; (global-set-key "\C-cntosr" 'academician-research-topic-on-top-of-stack)
(global-set-key "\C-cnpl" 'academician-list-documents)
(global-set-key "\C-cnxk" 'academician-process-document-with-knext)

(defvar academician-current-document "" "The current document to view")

(defvar academician-parscit-hash (make-hash-table :test 'equal))
;; (setq academician-parscit-hash (make-hash-table :test 'equal))
(defvar academician-title-override-hash (make-hash-table :test 'equal))
;; (setq academician-title-override-hash (make-hash-table :test 'equal))

(defvar academician-default-context "Org::FRDCSA::Academician")
;; (setq academician-default-context "Org::FRDCSA::Academician::2013")

(defvar academician-debug nil)
;; (setq academician-debug t)
;; (setq academician-debug nil)
(defvar academician-clean-documents-before-analysis t)
(defvar academician-reading-topic nil)

(defun academician-set-default-context ()
 ""
 (interactive)
 ;; get a list of contexts that begin with Org::FRDCSA::Academician
 ;; for now, do it manually to save time
 (setq academician-default-contexts (list "Org::FRDCSA::Academician" "Org::FRDCSA::Academician::Ionzero" "Org::FRDCSA::Academician::Essentia"))
 (setq academician-default-context (completing-read "Context: " academician-default-contexts)))

(defun academician-doc-view-open-text-without-switch-to-buffer ()
 "Open a buffer with the current doc's contents as text."
 (interactive)
 (setq academician-converted-to-text nil)
 (if doc-view--current-converter-processes
  (message "Academician: DocView: please wait till conversion finished.")
  (let ((txt (expand-file-name "doc.txt" (doc-view--current-cache-dir))))
   (if (file-readable-p txt)
    (progn 
     (find-file-noselect txt)
     (setq academician-converted-to-text t))
    (doc-view-doc->txt txt 'academician-doc-view-open-text-without-switch-to-buffer)))))

(defun academician-process-with-parscit (&optional overwrite)
 "Take the document in the current buffer, process the text of it
 and return the citations, allowing the user to add the citations
 to the list of papers to at-least-skim"
 (interactive "P")
 (if (derived-mode-p 'doc-view-mode)
  (if doc-view--current-converter-processes
   (message "Academician: DocView: please wait till conversion finished.")
   (let ((academician-current-buffer (current-buffer)))
    (academician-doc-view-open-text-without-switch-to-buffer)
    (while (not academician-converted-to-text)
     (sit-for 0.1))
    (let* ((filename (buffer-file-name))
	   (current-cache-dir (doc-view--current-cache-dir))
	   (txt (expand-file-name "doc.txt" current-cache-dir)))
     (if (equal "fail" (gethash current-cache-dir academician-parscit-hash "fail"))
      (progn
       ;; check to see if there is a cached version of the parscit data
       (if (file-readable-p txt)
	(let* ((command
		(concat 
		 "/var/lib/myfrdcsa/codebases/minor/academician/scripts/process-parscit-results.pl -f "
		 (shell-quote-argument filename)
		 (if overwrite " -o " "")
		 " -t "
		 (shell-quote-argument txt)
		 " | grep -vE \"^(File is |Processing with ParsCit: )\""
		 ))
	       (debug-1 (if academician-debug (see (list "command: " command))))
	       (result (progn
			(message (concat "Processing with ParsCit: " txt " ..."))
			(shell-command-to-string command)
			)))
	 (if academician-debug (see (list "result: " result)))
	 (ignore-errors
	  (puthash current-cache-dir (eval (read result)) academician-parscit-hash))
	 )
	(message (concat "File not readable: " txt)))
       ;; (freekbs2-assert-formula (list "has-title") academician-default-context)
       )))))))

(defun academician-choose-citation-by-rawstring ()
 ""
 (interactive)
 (let* ((current-cache-dir (doc-view--current-cache-dir))
	(current-document-hash (gethash current-cache-dir academician-parscit-hash))
	)
  (setq academician-current-document-citations nil)
  (dolist
   (hash (cdr (assoc "citation" 
	       (cdr (assoc "citationList"
		     (cdr (assoc "ParsCit" 
			   (cdr (assoc "algorithm" current-document-hash))))))))) 
   (push (cons (cdr (assoc "rawString" hash)) hash) academician-current-document-citations))
  (let* ((citation (completing-read "Citation: " academician-current-document-citations))
	 (data (assoc citation academician-current-document-citations)))
   data)))

(defun academician-choose-citation-by-title ()
 ""
 (interactive)
 (let* ((current-cache-dir (doc-view--current-cache-dir))
	(current-document-hash (gethash current-cache-dir academician-parscit-hash))
	)
  (setq academician-current-document-citations nil)
  (let* ((results (cdr (assoc "citation" 
			(cdr (assoc "citationList"
			      (cdr (assoc "ParsCit" 
				    (cdr (assoc "algorithm" current-document-hash))))))))))
   (see current-document-hash)
   (dolist
    (hash results) 
    (push (cons (cdr (assoc "title" hash)) hash) academician-current-document-citations)))
   (let* ((citation (completing-read "Citation: " academician-current-document-citations))
	  (data (assoc citation academician-current-document-citations)))
    data)))

(defun academician-search-for-citation (&optional overwrite)
 "Does all the things we want, rebuilds citation info if needed,
 selects a chosen citation, pushes it onto stack and executes a
 search for it"
 (interactive "P")
 (academician-process-with-parscit overwrite)
 (let* ((document-title (academician-get-title-of-publication-nuanced))
	(citation-data (academician-choose-citation-by-title))
	(citation-title (cdr (assoc "title" citation-data))))
  (freekbs2-push-onto-stack citation-title)
  ;; add an assertion here that we followed this citation from this paper
  ;; (freekbs2-assert-formula
  ;;  (list "followed-citation-from-to" document-title citation-title)
  ;;  academician-default-context)
  (freekbs2-execute2-emacs-function-on-tos "kmax-w3m-search")))

(defun academician-see-parscit-results (&optional overwrite)
 (interactive "P")
 (academician-process-with-parscit overwrite)
 (kmax-util-message-buffer "temp"
  (prin1-to-string (gethash (doc-view--current-cache-dir) academician-parscit-hash))))

(defun academician-extract-parscit-value (&optional key-arg)
 ""
 (interactive)
 (let* ((key (or key-arg
	      (completing-read "Key to extract from parscit: "
	       (list "email"))))
	(parcit-tree (gethash (doc-view--current-cache-dir) academician-parscit-hash)))
  (see
   (pcase key
    ("email"
     (mapcar
      (lambda (value) (k-assoc "content" value))
      (k-assoc "email"
       (k-assoc "variant"
	(k-assoc "ParsHed"
	 (k-assoc "algorithm"
	  parcit-tree))))))
    ("title"
     (k-assoc "content"
      (k-assoc "title"
       (k-assoc "variant"
	(k-assoc "ParsHed"
	 (k-assoc "algorithm"
	  parcit-tree))))))))))

(defun academician-petition-authors-of-document-for-their-software ()
 ""
 (interactive)
 ;; (academician-extract-parscit-value "title")
 ;; (academician-extract-parscit-value "email")
 )

(defun academician-see-title-of-publication (&optional overwrite)
 (interactive "P")
 (see (academician-get-title-of-publication overwrite)))

(defun academician-get-title-of-publication (&optional overwrite)
 ""
 (interactive "P")
 (let* ((current-cache-dir (doc-view--current-cache-dir))
	(current-document-hash (gethash current-cache-dir academician-parscit-hash))
	(title0 (gethash current-cache-dir academician-title-override-hash)))
  (if (non-nil title0)
   title0
   (progn
    (academician-process-with-parscit overwrite)
    (let* ((title1
	    (progn
	     ;; (see current-document-hash)
	     (cdr (assoc "content" 
		   (cdr (assoc "title" 
			 (cdr (assoc "variant" 
			       (cdr (assoc "ParsHed" 
				     (cdr (assoc "algorithm" current-document-hash))))))))))))
	   (title2
	    (cdr (assoc "content" 
		  (cdr (assoc "title" 
			(cdr (assoc "variant" 
			      (cdr (assoc "SectLabel" 
				    (cdr (assoc "algorithm" current-document-hash)))))))))))
	   (title 
	    (chomp (or title1 title2))))
     (if (not (equal title "nil"))
      title
      (academician-override-title)))))))

(defun academician-override-title ()
 (interactive)
 ""
 (let* 
  ((filename (buffer-file-name))
   (current-cache-dir (doc-view--current-cache-dir))
   (title (gethash current-cache-dir academician-title-override-hash))
   (basename (eshell/basename filename))
   (temp-title
    (progn 
     (string-match "^\\(.+?\\)\\(\.[^\.]+\\)?$" basename)
     (match-string 1 basename))))
  (if (non-nil title)
   (see title)
   (let* ((new-title (read-from-minibuffer 
		      (concat "Title for current publication: " filename ": ")
		      temp-title)))
    (puthash current-cache-dir new-title academician-title-override-hash)
    new-title))))

(defun academician-declare-document-read ()
 "Declare the document that is being visited in the current
 buffer as being read"
 ;; use academician to retrieve the title of the paper
 (interactive)
 (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	(formula (list "done"
		  (list "page-read" user (list "publication-fn" title))
		  )))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))))

(defun academician-declare-document-skimmed ()
 "Declare the document that is being visited in the current
 buffer as being read"
 ;; use academician to retrieve the title of the paper
 (interactive)
 (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	(formula (list "done"
		  (list "skim" user (list "publication-fn" title))
		  )))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))))

(defun academician-get-title-of-document-in-buffer-or-on-top-of-stack ()
 ""
 (interactive)
 (if (derived-mode-p 'doc-view-mode)
  (academician-get-title-of-publication)
  (if (derived-mode-p 'w3m-mode)
   (kmax-w3m-get-current-url)
   (if (derived-mode-p 'Man-mode)
    (buffer-name)
    (if (derived-mode-p 'gnus-article-mode)
     (substring-no-properties (car mode-line-buffer-identification))
     ;; FIXME change this to a completing read
     (if (derived-mode-p 'Info-mode)
      (concat "info://" Info-current-file "/" Info-current-subfile)
      (if (equal mode-name "ACL2-Doc")
       "ACL2-Doc"
       (if (buffer-file-name)
	(buffer-file-name)
	(if (nth 0 freekbs2-stack)
	 (nth 0 freekbs2-stack)
	 (read-from-minibuffer "What is the title of the current document? "))))))))))

(defun academician-has-publication-been-read ()
 "Query whether the current academic publication has been read"
 (interactive)
 ;; need to fix the ground case of the freekbs2-query-formula
 
 )

;; develop a bookmark functionality, so that I can resume reading
;; appropriately

(defun academician-lookup-publication-on-citeseer-x ()
 ""
 (interactive)
 ;; assert here that you are on a particular document
 (let ((title (academician-get-title-of-publication-nuanced)))
  (w3m-goto-url
   (format
    "http://citeseerx.ist.psu.edu/search?q=%s&submit=Search&sort=rel"
    (w3m-search-escape-query-string title)))))

(defun academician-declare-page-of-document-read ()
 "Declare the document that is being visited in the current buffer as being read"
 ;; use academician to retrieve the title of the paper
 (interactive)
 (academician-declare-page-of-document-read-skimmed-or-partly-read "page-read"))

(defun academician-declare-page-of-document-skimmed ()
 "Declare the document that is being visited in the current buffer as being read"
 ;; use academician to retrieve the title of the paper
 (interactive)
 (academician-declare-page-of-document-read-skimmed-or-partly-read "skim"))

(defun academician-declare-page-of-document-partly-read ()
 "Declare the document that is being visited in the current buffer as being read"
 ;; use academician to retrieve the title of the paper
 (interactive)
 (academician-declare-page-of-document-read-skimmed-or-partly-read "partly-read"))

(defun academician-declare-page-of-document-read-skimmed-or-partly-read (predicate &optional publication page-no)
 "Declare the document that is being visited in the current buffer as being read"
 ;; use academician to retrieve the title of the paper
 (interactive)
 (let* ((user (kmax-get-user))
	(context academician-default-context)
	(formula (list "done"
		  (list predicate user
		   (list "page-no"
		    (or page-no (academician-current-page-or-node))
		    (or publication (academician-publication-fn))))
		  )))
  (message (concat "Asserted " (prin1-to-string formula) " to " context))
  (freekbs2-assert-formula formula context "check-ist-asserted")
  (if (derived-mode-p 'doc-view-mode)
   (academician-check-whether-should-assert-entire-document-read))
  (cond
   ((derived-mode-p 'doc-view-mode) 
    (progn
     (doc-view-next-page)
     (set-window-vscroll (selected-window) 0)))
   ((derived-mode-p 'Info-mode) (Info-next-preorder))
   ((derived-mode-p 'ACL2-Doc) (message "hi"))
   )))

(defun academician-check-whether-should-assert-entire-document-read ()
 ""
 (if (equal (academician-current-page-or-node) (doc-view-last-page-number))
  (progn 
   (see "On Last Page")
   ;; ordinarily we would then query the KB to see if (done (read
   ;; andrewdo 1 (doc-view-last-page-number) ("publication-fn"
   ;; (get-title))))

   ;; or rather add a rule about the length of the publication and
   ;; automatically infer that predicate
   )))

(defun academician-publication-fn ()
 (interactive)
 "Return a KB function which describes the current publication,
or nil if there is no such publication"
 (condition-case nil
  (list "publication-fn"
   (academician-get-title-of-publication-nuanced))
  (error nil)))

(defun academician-declare-page-of-document-read-kbfs ()
 "Declare the document that is being visited in the current buffer as being read"
 ;; use academician to retrieve the title of the paper
 (interactive)
 (let* ((filename (buffer-file-name))
	(user (kmax-get-user))
	(context academician-default-context)
	(formula (list "done"
		  (list "page-read" user 
		   (list "page-no" (academician-current-page-or-node) 
		    "var"
		    ))
		  )))
  (kbfs-mode-assert-knowledge-about-marked-files formula context 1 (list filename))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))
  (doc-view-next-page)
  (set-window-vscroll (selected-window) 0)
  ))

(defun academician-correct-title ()
 "Set the correct title for a publication"
 (interactive)
 )

(defun academician-extract-all-urls-from-document (&optional arg)
 "rotate the ring and push all URLs in text document onto the stack"
 (interactive)
 (let* ((filename (make-temp-file "academician-"))
	(list (save-excursion
	       (mark-whole-buffer)
	       (write-region (mark) (point) filename)
	       (eval (read 
		      (shell-command-to-string
		       (concat "/var/lib/myfrdcsa/codebases/internal/perllib/scripts/extract-links.pl --emacs -i "
			(shell-quote-argument filename))))))))
  (freekbs2-push-onto-stack list nil)))

(defun academician-extract-all-urls-from-document-and-open-in-firefox (&optional arg)
 "rotate the ring and push all URLs in text document onto the stack"
 (interactive)
 (assert (kmax-mode-is-derived-from 'academician-mode))
 (shell-command
  (concat
   "/var/lib/myfrdcsa/codebases/internal/perllib/scripts/extract-links.pl -o "
   (shell-quote-argument buffer-file-name))))

(defun academician-extract-all-abbrev-from-document ()
 "rotate the ring and push all URLs in text document onto the stack"
 (interactive)
 (let* ((filename (make-temp-file "academician-")))
  (save-excursion
   (mark-whole-buffer)
   (write-region (mark) (point) filename)
   (message
    (shell-command-to-string
     (concat "/var/lib/myfrdcsa/codebases/internal/perllib/scripts/test-system-extractabbrev.pl "
      (shell-quote-argument filename)))))))
  
(defun academician-w3m-view-html-with-doc-view-mode ()
 "Take the url link at point, retrieve the html, convert to
 text, make read-only and open in ACADEMICIAN"
 (interactive)
 ;; first determine whether the link under point is a url or a w3m-link
 (let* 
  ((actual-url (kmax-w3m-get-a-url))
   (file-location
    (progn
     (shell-command-to-string
      (concat "/var/lib/myfrdcsa/codebases/internal/digilib/scripts/retrieve-paper.pl -u "
       (shell-quote-argument actual-url)))))
   (original-document-file 
    (progn
     (string-match "Docfile: \\(.+\\)" file-location)
     (match-string 1 file-location)))
   (text-file 
    (progn
     (string-match "Textfile: \\(.+\\)" file-location)
     (match-string 1 file-location)))
   )
  (if
   (and
    (not x-no-window-manager)
    (or 
     (and (= emacs-minor-version 2) (>= emacs-major-version 23))
     (> emacs-minor-version 2)))
   (progn
    (ffap (academician-w3m-convert-html-to-ps original-document-file))
    (doc-view-mode)
    )
   (ffap text-file))))

(defun academician-w3m-convert-html-to-ps (file)
 "Take an html file, convert it to ps using htmldoc, and return
 the resulting filename"
 (shell-command-to-string
  (concat 
   "htmldoc " 
   (shell-quote-argument file) 
   " -t ps > "
   (shell-quote-argument (concat file ".ps"))))
 (concat file ".ps"))

(defun academician-search-papers ()
 "Search the titles of all available papers, loading the selected one"
 (interactive)
 (let* ((command "/var/lib/myfrdcsa/codebases/minor/academician/scripts/search-index.pl")
	(result (shell-command-to-string command))
	(title (progn
		(setq academician-available-papers-list (eval (read result)))
		(completing-read "Choose Paper: " academician-available-papers-list)))
	(file (cdr (assoc title academician-available-papers-list)))
	)
  (ffap file)))

(defun academician-choose-paper ()
 "List all of the academician-mode buffers and allow the user to
 select between them"
 (interactive)
 (setq academician-paper-hash (make-hash-table :test 'equal))
 (setq academician-paper-list nil)
 (save-excursion
  (dolist (buffer (buffer-list)) 
   (set-buffer buffer)
   (if (derived-mode-p 'academician-mode)
    (let* ((temp (academician-get-title-of-publication-nuanced))
	   (title (if (not (string= temp "nil")) temp (buffer-name buffer))))
     (puthash title (buffer-name buffer) academician-paper-hash)
     (push title academician-paper-list)
     )
    )
   )
  )
 (switch-to-buffer 
  (gethash (completing-read "Choose Paper Buffer: " academician-paper-list) academician-paper-hash)))

(defun academician-get-list-of-files-and-names ()
 "List all of the doc-view-mode buffers and allow the user to
 select between them"
 (interactive)
 (setq academician-paper-hash (make-hash-table :test 'equal))
 (setq academician-file-list nil)
 (save-excursion
  (dolist (buffer (buffer-list)) 
   (set-buffer buffer)
   (if (derived-mode-p 'doc-view-mode)
    (let* ((title (academician-get-title-of-publication-nuanced))
	   (filename (buffer-file-name buffer)))
     (puthash title filename academician-paper-hash)
     (push filename academician-file-list)))))
 (kmax-util-message-buffer "File list of publications" (join "\n" academician-file-list)))

(defun academician-declare-academic-research-interest-in-item-on-top-of-stack ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (if (nth 0 freekbs2-stack)
  (let* ((context academician-default-context)
	 (formula (list "has-academic-research-interest"
		   (kmax-get-user)
		   (nth 0 freekbs2-stack))))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   )
  (message "No item on stack to add to interests")))

(defun academician-declare-desire-to-know-more-about-item-on-top-of-stack ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (if (nth 0 freekbs2-stack)
  (let* ((user (kmax-get-user))
	 (context academician-default-context)
	 (formula (list "desires"
		   user
		   (list "know-more-about" user (nth 0 freekbs2-stack)))))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   )
  (message "No item on stack to add to interests")))

(defun academician-declare-desire-to-review-item-on-top-of-stack ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (if (nth 0 freekbs2-stack)
  (let* ((user (kmax-get-user))
	 (context academician-default-context)
	 (formula (list "desires"
		   user
		   (list "review-subject" user (nth 0 freekbs2-stack)))))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   )
  (message "No item on stack to add to interests")))

(defun academician-declare-item-on-top-of-stack-is-understood ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (if (nth 0 freekbs2-stack)
  (let* ((user (kmax-get-user))
	 (context academician-default-context)
	 (formula (list "understands"
		   user
		   (nth 0 freekbs2-stack))))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   )
  (message "No item on stack to add to interests")))

(defun academician-declare-desire-to-read-document ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	(formula (list "desires"
		  user
		  (list "read-document" user title)
		  )))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))))

(defun academician-declare-desire-to-obtain-title ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((title (freekbs2-get-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	(formula (list "desires"
		  user
		  (list "obtain-title" user title)
		  )))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))))

(defun academician-declare-currently-reading-document ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	(topic (academician-choose-reading-topic))
	(formula (list "currently-reading" user title (buffer-file-name) topic)))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))))

(defun academician-retract-currently-reading-document ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	;; FIXME: have it freekbs2-query for the topic
	(topic (academician-choose-reading-topic))
	(formula (list "currently-reading" user title (buffer-file-name) topic)))
  (freekbs2-unassert-formula formula context)
  (message (concat "Unasserted " (prin1-to-string formula) " to " context))))

(defun kbfs-mode-system-academician--declare-desire-to-read-document ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((user (kmax-get-user))
	(context academician-default-context)
	(formula (list "desires"
		  user
		  (list "read-document" user 'var-_)
		  )))
  (kbfs-mode-assert-knowledge-about-marked-files-class formula)))

(defun academician-declare-requires-definition-of-item-on-top-of-stack ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (if (nth 0 freekbs2-stack)
  (let* ((context academician-default-context)
	 (formula (list "requires-definition-of"
		   (kmax-get-user)
		   (nth 0 freekbs2-stack))))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   )
  (message "No item on stack to add to interests")))

(defun academician-declare-isa-for-item-on-top-of-stack ()
 "List the available actions for the nugget at point"
 (interactive)
 (if (nth 0 freekbs2-stack)
  (let* ((potential-isas (list "thing" "place"))
	 ;; (potential-isas (eval
	 ;; 		  (read
	 ;; 		   (shell-command-to-string
	 ;; 		    (concat
	 ;; 		     "/var/lib/myfrdcsa/codebases/internal/freekbs2/scripts/helper/potential-isas.pl "
	 ;; 		     (shell-quote-argument freekbs2-database)
	 ;; 		     " "
	 ;; 		     (shell-quote-argument freekbs2-context))))))
	 (isa (completing-read "Which Class should this belong to: " potential-isas)))
   (see isa)
   (if isa 
    (let* ((formula (list "isa"
		     (nth 0 freekbs2-stack)
		     isa)))
     (freekbs2-assert-formula formula freekbs2-context)
     (message (concat "Asserted " (prin1-to-string formula) " to " freekbs2-context))
     )
    (message "No class selected")))
  (message "No item on stack to classify")))

(defun academician-declare-desire-to-have-software-implementing-capability ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (if (nth 0 freekbs2-stack)
  (let* ((user (kmax-get-user))
	 (context academician-default-context)
	 (formula (list "desires"
		   user
		   (list "have-software-having-capability" (nth 0 freekbs2-stack))
		   )))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   )
  (message "No item on stack to add to reading list")))

(defun academician-declare-desire-to-have-software-implementing-capability-described-in-current-document ()
 ""
 (interactive)
 (let* ((user (kmax-get-user))
	(context academician-default-context)
	(formula (list "desires"
		  user
		  (list "have-software-having-capability" (academician-publication-fn))
		  )))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))
  ))

(defun academician-declare-desire-to-have-software ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (if (nth 0 freekbs2-stack)
  (let* ((user (kmax-get-user))
	 (context academician-default-context)
	 (formula (list "desires"
		   user
		   (list "have-software" user (nth 0 freekbs2-stack))
		   )))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   )
  (message "No item on stack to add to reading list")))

(defun academician-declare-desire-to-obtain-publication ()
 "We really should have a publication at point function, process
 the whole document with the citation extraction software"
 )

(defun academician-get-actual-url (&optional arg)
 ""
 (interactive "P")
 (let ((actual-url
	(cond
	 ((derived-mode-p 'academician-mode)
	  (let* ((name (buffer-file-name (current-buffer))))
	   (string-match "^(https?://)" name)
	   (if (not (string= "" (match-string 1)))
	    name)))
	 ((derived-mode-p 'w3m-mode)
	  (let*
	   ((url1 (w3m-url-valid (w3m-anchor)))
	    (url2 (w3m-url-valid (thing-at-point 'url))))
	   (if url1 url1 (if url2 url2 nil))))
	 ((or 
	   (derived-mode-p 'dired-mode)
	   (string= mode-name "KBFS"))
	  (concat "file://" (dired-get-filename)))
	 ((derived-mode-p 'doc-view-mode)
	  (concat "file://" (buffer-file-name))))))
  (if arg (see actual-url))
  actual-url))

(defun academician-retrieve-document-for-analysis-from-url-at-point (&optional overwrite)
 "Take the url link at point, retrieve the document, convert to
 text, make read-only and open in ACADEMICIAN"
 (interactive "P")
 ;; first determine whether the link under point is a url or a w3m-link
 (let* 
  ((actual-url (academician-get-actual-url))
   (file-location
    (shell-command-to-string
     (concat "/var/lib/myfrdcsa/codebases/internal/digilib/scripts/retrieve-paper.pl -u "
      (shell-quote-argument actual-url))))
   (original-document-file 
    (progn
     (string-match "Docfile: \\(.+\\)" file-location)
     (match-string 1 file-location)))
   (text-file 
    (progn
     (string-match "Textfile: \\(.+\\)" file-location)
     (match-string 1 file-location)))
   )
  (if
   (and
    (not x-no-window-manager)
    (or 
     (and (= emacs-minor-version 2) (>= emacs-major-version 23))
     (> emacs-minor-version 2)))
   (progn
    (ffap original-document-file)
    (doc-view-mode)
    ;; run the parser here and cache the results
    (academician-process-with-parscit overwrite)
    )
   (ffap text-file))))

;; desired features

;; to be able to search with iswitchb style completing read over
;; citations

;; (have it so that it records the pages we have read completely)

;; (completed (have it so that it can mark an entire document as having been read))

;; (ensure it can relate different queries to specific documents)

;; develop more of the NLU capabilities

;; 
(defun academician-add-entry-to-dictionary ()
 "Ensure it can add entries to dictionaries as needed"
 (interactive)
 )

;; possibly use OCR to determine page boundaries in text versions of
;; documents, for use in the clear system for knowing what has been
;; read.  also note that ^L character is often seen with page
;; boundaries

;; do not bother with eye tracking

;; ensure it knows which path through documents we traversed, for
;; instance, that we got to a certain document by following its
;; citation in another document


;; have a listing of all open papers, and be able to browse between
;; them and see relationships between them

;; create a listing of all papers that have been indexed by the system

;; fix problem whereby if the name of the doc.txt cache dir is too
;; complicated, or if the page has not been generated,
;; academician-search-for-citation fails to recompute the citations

;; develop functions for quoting from a given document, and taking
;; that quote in context, also for using a particular quote as part of
;; an argument or evidence

(defun academician-search-contents-of-open-publications ()
 ""
 (interactive)
 ;; ./digi -n academician-papers --t2 "practical reasoning"
 )

(defun academician-search-contents-of-all-publications ()
 ""
 (interactive)
 ;; ./digi -n academician-papers --t2 "practical reasoning" 
 )

(defun academician-write-review-of-publication ()
 ""
 (interactive)
 )

;; mark utility of paper towards different goals

;; have tools for mapping out knowledge, for instance, obtain items
;; that should be defined from all documents we read

(defun academician-process-with-capability-textanalysis ()
 "Run the NLU program on this document to derive items that need to be defined, etc, for building up our informational resources"
 (interactive)
 
 )

;; record google searches for topics into what was searched for and
;; when

(defun academician-search-google-for-topic-on-top-of-stack ()
 "take the item on stack and run radar web search on the it"
 (interactive)
 (if (nth 0 freekbs2-stack)
  (let* ((user (kmax-get-user))
	 (context academician-default-context)
	 (formula (list "searched-google-for-topic"
		   user
		   (nth 0 freekbs2-stack)
		   )))
   (freekbs2-assert-formula formula context)
   (message (concat "Asserted " (prin1-to-string formula) " to " context))
   (if (string= mode-name "w3m")
    (w3m-copy-buffer))
   (w3m-search "google" (nth 0 freekbs2-stack)))))

(defun academician-research-topic-on-top-of-stack ()
 "Take the item on stack and begin researching it"
 (interactive)
 (academician-search-google-for-topic-on-top-of-stack))

;; add functions for retrieving a particular book or paper

;; try to think of ways to incorporate additional media types, like
;; rss and streaming, email, etc

(defun academician-read-paper-using-clear ()
 "Read the paper using the CLEAR ITS"
 (interactive))

(defun academician-declare-publication-related-to-project ()
 "Assert into the KB that the publication at point is related to
 an FRDCSA project"
 (interactive))

(defun academician-declare-current-w3m-url-to-be-proceedings-of-a-conference ()
 "Store the conference proceedings for later retrieval"
 (interactive))

(defun academician-declare-requires-clarification ()
 "Clarify a piece of text from a given document"
 (interactive)
 (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	(formula (list "requires-clarification" 
		  user
		  (list "publication-fn" title)
		  (buffer-substring-no-properties (point) (mark))
		  )))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))))

(defun academician-declare-has-question ()
 "Clarify a piece of text from a given document"
 (interactive)
 (freekbs2-assert 
  (list "has-question" 
   (kmax-get-user)
   (read-from-minibuffer "Question?: "))
  academician-default-context))

(defun academician-man ()
 "A wrapper around Man that first checks for "
 (interactive)
 )

(defun academician-w3m-browse-url ()
 "A wrapper around w3m that first checks for Ghosted copies"
 (interactive) 
 )

(defun academician-choose-reading-topic ()
 ""
 (interactive)
 (let* ((topics (freekbs2-get-variable-value-from-cycl
    (freekbs2-query
     (list "reading-topic" (kmax-get-user) 'var-TOPIC)
     academician-default-context)
    'var-TOPIC))
	(topic (completing-read "Topic?: " topics nil nil academician-reading-topic)))
  (if
   (not (non-nil (kmax-grep-list topics (lambda (tmp) (string= tmp topic)))))
   (if (yes-or-no-p (concat "Add new topic <" topic ">?: "))
    (freekbs2-assert
     (list "reading-topic" (kmax-get-user) topic)
     academician-default-context)))
  (setq academician-reading-topic topic)))

(defun academician-start-reading ()
 "Load the current reading topics and set them to their pages"
 (interactive)
 (mapcar (lambda (filename) 
	  (if (file-exists-p filename) 
	   (progn
	    (see filename 0)
	    (ffap filename)
	    ;; jump to the first unread page 
	    ;; ()
	    )
	   )
	  )
  (let* ((topic (completing-read "Topic?: " 
		 (delete-dups
		  (freekbs2-get-variable-value-from-cycl
		   (freekbs2-query
		    (list "currently-reading" (kmax-get-user) 'var-TITLE 'var-FILENAME 'var-TOPIC)
		    academician-default-context)
		   'var-TOPIC))))
	 (query (freekbs2-query
		 (list "currently-reading" (kmax-get-user) 'var-TITLE 'var-FILENAME topic)
		 academician-default-context)))
   (freekbs2-get-variable-value-from-cycl
    query
    'var-FILENAME))))

;; (freekbs2-util-convert-from-emacs-to-perl-data-structures (list "currently-reading" "#$temp" (kmax-get-user) 'var-TITLE 'var-FILENAME 'var-\\))
;;      (freekbs2-util-data-dumper
;;       (list
;;        (cons "_DoNotLog" 1)
;;        (cons "Database" freekbs2-database)
;;        (cons "Formula" (list "currently-reading" (kmax-get-user) 'var-TITLE 'var-FILENAME 'var-TOPIC))
;;        (cons "InputType" "Interlingua")
;;        (cons "OutputType" "CycL String")
;;        (cons "Flags" (list 
;; 		      ;; (cons "Quiet" 1)
;; 		      (cons "OutputType" "CycL String"))
	
;; 	)
;;        )
;;       )
;; (prin1-to-string )

(defun academician-start-reading-old ()
 "Load the current reading topics and set them to their pages"
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/rayon/flora2/part1-foundations.ppt")
 (ffap "/var/lib/myfrdcsa/codebases/minor/rayon/flora2/part2-programming.ppt")
 )

;; to add to docview or a derived mode

;; display-whether-page-has-been-read-or-not

;; display last read time

;; page-has-been-read-p

;; ocr-page

;; ocr-document

;; get-text-for-page-by-using-ocred-text-and-extracted-text

;; read-text-for-page ;; clear clear functionality

;; (or maybe just use the emacs reading software already extant)
;; forward-sentence
;; backward-sentence

;; have the ability to process the meaning of the sentences read and
;; assert to the user's knowledge base

;; mark paragraph read

(defun academician-ocr-page ()
 ""
 (interactive)
 (let* 
  ((filename (plist-get (cdr (doc-view-current-image)) :file))
   (text (shell-command-to-string (concat "cuneiform " (shell-quote-argument filename)))))
  (see text)))

;; (cdr (assq prop (cdr winprops)))

;;    (file (assq :file (doc-view-current-image)))
;; ;;  (gethash :file )
;; ;; (image :type png :file "<REDACTED>" :pointer arrow))
;;  )

(defun academician-next-unread-page ()
 ""
 (interactive)
 (kmax-check-mode 'academician-mode)
 (let* ((title (academician-get-title-of-publication-nuanced))
	(page (academician-agent-query
	       title
	       "FirstUnreadPage" 
	       (list "Doc" title))))
  (see page)))
;;  (academician-goto-page-of-doc page (buffer-file-name))))

(defun academician-next-unread-page-using-vampire ()
 ""
 (interactive)
 (kmax-check-mode 'academician-mode)
 (let ((title (academician-get-title-of-publication-nuanced)))
 (freekbs2-query 
  ;; what is the least such page number such that for all pages less
  ;; than it, they are read, but it is not that case that it is read
  ;; (list "and" 
  ;;  (list "not" 
  ;;   (list "done" 
  ;;    (list "page-read" 
  ;;     (kmax-get-user)
  ;;     (list "page-no" 'var-PAGENO1 
  ;;      (list
  ;; 	"publication-fn"
  ;; 	title)))))
  ;;  (list "forall"
  ;;   (list 'var-PAGENO2)
  ;;   (list "implies" 
  ;;    (list ">="
  ;;     'var-PAGENO1
  ;;     'var-PAGENO2
  ;;     ))
  ;;   (list "or"
  ;;    (list "done" 
  ;;    (list "page-read" 
  ;;     (kmax-get-user)
  ;;     (list "page-no" 'var-PAGENO2
  ;;      (list
  ;; 	"publication-fn"
  ;; 	title))))
  ;;    (list "equal" 
  ;;     'var-PAGENO1
  ;;     'var-PAGENO2))))
  academician-default-context)))

(defun academician-list-documents ()
 "Display a list of open documents"
 (interactive)
 (kmax-not-yet-implemented))

(defun academician-process-document-with-knext ()
 ""
 (interactive)
 (let*
  ((filename 
    ;; (cond ((string= mode-name "DocView") (buffer-name (current-buffer))) ())
    (buffer-name (current-buffer))))
  (academician-process-filename-with-knext filename)))

(defun academician-process-filename-with-knext (filename &optional async)
 ""
 (interactive)
 (let*
  ((dir "/var/lib/myfrdcsa/codebases/minor/workhorse/data/1/")
   (to-analyze-dir (concat dir "to-analyze"))
   (command1
    (concat "/var/lib/myfrdcsa/codebases/minor/workhorse/scripts/preprocess-to-analyze.pl -a -d "
     to-analyze-dir "/"))
   (command2
    (concat
     "/var/lib/myfrdcsa/codebases/minor/free-knext/scripts/process-directories-with-knext.pl -d "
     dir " &")))
  (condition-case nil
   (copy-file filename to-analyze-dir)
   (error nil))
  (if async
   (progn 
    (shell-command command1)
    (shell-command command2))
   (progn 
    (kmax-async-shell-command-new-buffer command1)
    (kmax-async-shell-command-new-buffer command2)))))

(defun academician-process-filename-with-nlu (filename)
 ""
 (interactive)
 (let*
  ((command
    (concat "/var/lib/myfrdcsa/codebases/minor/nlu/scripts/nlu-client -c Org::FRDCSA::NewsMonitor::Temp -f " (shell-quote-argument filename) " -o")))
  (kmax-async-shell-command-new-buffer command)))

(defun academician-research-paper-p ()
 "Determine if the paper in the current doc-view buffer is a research paper"
 (interactive)
 (kmax-not-yet-implemented))

(defun academician-browse-recently-read-pages ()
 ""
 (interactive))

(defun academician-choose-study-topic ()
 "Completing read the list of study topics"
 (interactive)
 (completing-read "Which topic do you wish to study?: "
  (academician-get-study-topics)))

(defun academician-get-study-topics ()
 "Query the Knowledge Base to determine which topics the user has
expressed interest in learning"
 (interactive)
 (let* ((topics (freekbs2-query
		 (list "desires" 
		  (kmax-get-user)
		  (list "know-more-about" (kmax-get-user) 'var-TOPIC))
		 academician-default-context)))
  (mapcar (lambda (binding) (car (cdr (car binding)))) (cdr (assoc "CycL" topics)))))


(defun academician-test-debug-freekbs2-query-formula-read-predicate ()
 ""
 (interactive)
 (freekbs2-query-formula-read-predicate
  '("desires" var-PERSON ("know-more-about" var-PERSON var-TOPIC)) academician-default-context)
 (freekbs2-query-formula-read-predicate '("a" var-X) "default") ;; academician-default-context)
 (freekbs2-send-command "query" '("p" var-X) academician-default-context)

 (see (freekbs2-send-command "query" '("a" var-X) "default"))
 (see (freekbs2-send-command "query" '("desires" var-PERSON ("know-more-about" var-PERSON var-TOPIC)) academician-default-context))
 (uea-query-agent-raw "echo hi" "UniLang" nil)

 (uea-query-agent-raw nil "KBS2"
  (freekbs2-util-data-dumper
   (list
    (cons "_DoNotLog" 1)
    (cons "Command" "query")
    (cons "Method" freekbs2-method)
    (cons "Database" freekbs2-database)
    (cons "Context" academician-default-context)
    (cons "FormulaString" (freekbs2-print-formula '("p" var-X)))
    (cons "InputType" "Emacs String")
    (cons "OutputType" "CycL String")
    (cons "Flags" (list 
		   ;; (cons "Quiet" 1)
		   (cons "OutputType" "CycL String")
		   )
     )
    )
   )
  )
 
 (freekbs2-query-formula-read-predicate
  (list "done" 
   (list "page-read" "andrewdo"
    (list "page-no" "1"
     (list "publication-fn" "grosof-haley-talk-semtech2013-ver6-10-13"))))
  academician-default-context)

 (freekbs2-send-command "query" 
  (list "done" 
   (list "page-read" "andrewdo"
    (list "page-no" "1"
     (list "publication-fn" "grosof-haley-talk-semtech2013-ver6-10-13")))) academician-default-context)

 (freekbs2-query-formula-read-predicate
  '("desires" var-PERSON ("know-more-about" var-PERSON var-TOPIC))
  academician-default-context)
 )

(defun academician-analyze-region ()
 "analyze the "
 (interactive)
 (doc-view-open-text)
 (sit-for 5)
 (save-excursion
  (set-buffer
   (concat "Text contents of "
    (file-name-nondirectory buffer-file-name)))
  ;; (academician-clean-buffer-if-desired)
  (nlu-analyze-region-light)
  ))

(defun academician-clean-buffer-if-desired ()
 ""
 (if (and 
      academician-clean-documents-before-analysis
      (not (string-match "^Cleaned:" (buffer-name))))
  (let* ((buffer-name (concat "Cleaned: " (buffer-name))))
   (mark-whole-buffer)
   (kmax-util-message-buffer buffer-name (buffer-substring-no-properties (point) (mark)))
   (switch-to-buffer buffer-name)
   (mark-whole-buffer)
   ;; FIXME: need to somehow invoke this with the prefix arg
   (shell-command-on-region (point) (mark) "/var/lib/myfrdcsa/codebases/internal/perllib/scripts/remove-ligatures.pl")
   )))

(defun academician-quote-region ()
 "Record a quote from a particular source. (see also
news-monitor.el)"
 (interactive)
 (kmax-not-yet-implemented)
 ()
 )

(defun academician-display-knext-processing-result ()
 ""
 (interactive)
 (let* ((basename (eshell/basename (buffer-name (current-buffer)))))
  (find-file-other-window 
   (concat
    "/var/lib/myfrdcsa/codebases/minor/workhorse/data/1/complete/"
    basename
    ".workhorse.knext.dat"))
  (find-file-other-window 
   (concat
    "/var/lib/myfrdcsa/codebases/minor/workhorse/data/1/complete/"
    basename
    ".workhorse.knext.kbs"))))

(provide 'academician)

(defun kbfs-mode-system-academician--declare-file-research-paper ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((user (kmax-get-user))
	(context "Org::FRDCSA::RADAR")
	(formula (list "desires"
		  user
		  (list "package-file" user 'var-_)
		  )))
  (kbfs-mode-assert-knowledge-about-marked-files-class formula)))

(defun academician-assert-kbfs-knowledge (&optional formula context)
 "Use KBFS to assert some knowledge about the file containing hte document"
 ;; should this be -for-file-containing-publication?
 (interactive)
 (kmax-check-mode 'academician-mode)
 (let* ((user (kmax-get-user))
	(context academician-default-context) 
	(formula freekbs2-stack))
  (kbfs-mode-assert-knowledge-about-marked-files formula context t (list (buffer-file-name)))))

(defun academician-view-kbfs-knowledge ()
 ""
 (interactive)
 (kmax-check-mode 'academician-mode)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic
 (let* ((user (kmax-get-user))
	(context academician-default-context))
  (kbfs-mode-view-knowledge-about-marked-files context t (list (buffer-file-name)))))

(defun academician-assert-kbfs-knowledge-comment-from-text ()
 "Use KBFS to assert some knowledge about the file containing hte document"
 ;; should this be -for-file-containing-publication?
 (interactive)
 (kmax-check-mode 'academician-mode)
 (let* ((user (kmax-get-user))
	;; (context academician-default-context) 

	;; FIXME: Make it so that this actually converts the text you
	;; enter into a usable formula.  Maybe use researchcyc or
	;; something.

	(formula (list "has-comment" 'var-_ (academician-obtain-formula-from-text))))

  (kbfs-mode-assert-knowledge-about-marked-files formula nil t (list (buffer-file-name)))))

(defun academician-obtain-formula-from-text ()
 "Extract a formula to assert about an academician by processing text"
 (interactive)
 (read-from-minibuffer "Assert what?: "))

(defun academician-page-read-p ()
 "Query whether the page has been read or not"
 (interactive)
 (or 
  (derived-mode-p 'academician-mode)
  (derived-mode-p 'Info-mode)
  (derived-mode-p 'w3m-mode)
  )
 (see 
  (freekbs2-query
   (list "done" 
    (list "page-read" (kmax-get-user)
     (list "page-no"
      (academician-current-page-or-node)
      (list "publication-fn"
       (academician-get-title-of-publication-nuanced)))))
   academician-default-context)))

(defun academician-show-pages-read ()
 "Query whether the page has been read or not"
 (interactive)
 (kmax-check-mode 'academician-mode)
 (see
  (freekbs2-query
   (list "done" 
    (list "page-read" (kmax-get-user)
     (list "page-no"
      'var-PAGENO
      (list "publication-fn"
       (academician-get-title-of-publication-nuanced)))))
   academician-default-context)))

(defun academician-add-to-default-reading-list ()
 ""
 (interactive)
 (kmax-check-mode 'academician-mode)
 (academician-get-title-of-publication-nuanced) 
 )

(defun academician-sort-buffer-predicate (buffer-a buffer-b)
 "Buffer sorting predicate"
 (string< (buffer-name buffer-a) (buffer-name buffer-b)))

(defun academician-cycle-next-publication ()
 "Go to the next document in the ring of academician documents"
 (interactive)
 (let* ((academician-buffer-list
	 (reverse (sort
		   (kmax-list-buffers-derived-from-mode 'academician-mode)
		   'academician-sort-buffer-predicate))))
  (unshift (nth 0 academician-buffer-list) academician-buffer-list)
  ;; (see academician-buffer-list)
  (mapcar
   (lambda (buffer) 
    (if (eq (current-buffer) buffer)
     (setq academician-cycle-choice academician-cycle-choice-last))
    (setq academician-cycle-choice-last buffer))
   academician-buffer-list)
  (switch-to-buffer academician-cycle-choice)
  ))

(defun academician-cycle-next-publication ()
 "Go to the next document in the ring of academician documents"
 (interactive)
 (kmax-cycle-next-buffer-with-mode 'academician-mode 'academician-sort-buffer-predicate))

(defun academician-cycle-previous-publication ()
 "Go to the next document in the ring of academician documents"
 (interactive)
 (kmax-cycle-previous-buffer-with-mode 'academician-mode 'academician-sort-buffer-predicate))

(defun academician-get-date-of-publication ()
 "Return the date"
 (interactive)
 (kmax-not-yet-implemented))

(defun academician-get-title-of-publication-nuanced ()
 "Return the publication that is being referred to most likely"
 (interactive)
 (academician-get-title-of-document-in-buffer-or-on-top-of-stack))

(defun academician-current-page-or-node ()
 "Print the current page or equivalent."
 (cond
  ((derived-mode-p 'doc-view-mode) (doc-view-current-page))
  ((derived-mode-p 'Info-mode) Info-current-node)
  ((derived-mode-p 'w3m-mode) (kmax-w3m-get-current-named-anchor))
  ((equal mode-name "ACL2-Doc") (prin1-to-string (nth 1 (car *acl2-doc-history*))))
  )
 )

(defun academician-save-text-for-current-document (&optional filename)
 ""
 (cond
  ((derived-mode-p 'doc-view-mode)
   (progn
    ;;(doc-view-open-text)
    ;; (sit-for 5)
    ;; (nlu-ghost-buffer)
    ;; "/var/lib/myfrdcsa/codebases/minor/academician/scripts/test.txt"
    ))
  ((derived-mode-p 'Info-mode) (kmax-not-yet-implemented))
  ((derived-mode-p 'w3m-mode) (kmax-not-yet-implemented))
  )
 )

(defun academician-get-text-for-page ()
 ""
 (interactive)
 (if (derived-mode-p 'doc-view-mode)
  (let* ((pageno (doc-view-current-page))
	 (filename (academician-save-text-for-current-document)))
   (with-output-to-temp-buffer
    "temp"
    (prin1 (shell-command-to-string 
     (concat "/var/lib/myfrdcsa/codebases/minor/academician/scripts/get-text-for-page.pl"
      " -p " (shell-quote-argument (int-to-string pageno))
      " -f " (shell-quote-argument filename)
      )))))))

;; todo: convert all necessary instances of doc-view-mode to academician-mode

(defun academician-goto-page-of-doc (pageno file)
 (setq academician-remote-command-intended-buffer nil)
 (let* ((truename-of-file (file-truename file)))
  (mapcar 
   (lambda (buffer) 
    (if (string= (file-truename (buffer-file-name buffer)) 
	 truename-of-file)
     (setq academician-remote-command-intended-buffer buffer)))
   (kmax-list-buffers-derived-from-mode 'academician-mode))
  (if
   (non-nil academician-remote-command-intended-buffer) 
   (academician-goto-page-of-buffer academician-remote-command-intended-buffer pageno))))

(defun academician-goto-page-of-buffer (buffer pageno)
 (if (kmax-buffer-visible-p academician-remote-command-intended-buffer)
  (let* ((current (current-buffer)))
   (save-excursion
    (pop-to-buffer academician-remote-command-intended-buffer)
    (doc-view-goto-page pageno)
    (pop-to-buffer current)))))

(defun academician-list-documents ()
 ""
 (interactive)
 (let ((buffers (kmax-list-buffers-derived-from-mode 'academician-mode)))
  (switch-to-buffer (nth 0 buffers))
  (see buffers)))

(defun academician-agent-query (title message data)
 (interactive)
 (push (cons "_DoNotLog" 1) data)
 (uea-query-agent-raw message "Academician" (freekbs2-util-data-dumper data)))

(defun academician-record-citation ()
 (interactive)
 (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
	(user (kmax-get-user))
	(context academician-default-context)
	(formula (list "hasCitation"
		  user
		  (list "publication-fn" title)
		  (buffer-substring-no-properties (point) (mark)))))
  (freekbs2-assert-formula formula context)
  (message (concat "Asserted " (prin1-to-string formula) " to " context))))

(defun academician-open-text ()
 ""
 (interactive)
 (doc-view-open-text)
 (academician-minor-mode))

(defun academician-jump-to-any-pdf ()
 ""
 (interactive)
 (switch-to-buffer (car (kmax-search-buffer-file-names "\.pdf$"))))

(defun academician-declare-desire-to-formalize-text-from-digilib ()
 "Declare that we desired to formalize manually with NLU the
 document being visited"
 (interactive)
 (assert (or
	  (kmax-mode-is-derived-from 'academician-mode)
	  (kmax-mode-is-derived-from 'academician-minor-mode)))
 (let* ((user (kmax-get-user))
	(context nlu-mf-default-context)
	(formula (list "desires"
		  user
		  (list "formalize-with-nlu-mf"
		   (list "fileFn"
		    buffer-file-name)))))
  (message (concat "Asserted " (prin1-to-string formula) " to " context))
  (freekbs2-assert-formula formula context)))

(defun academician-push-buffer-file-name-to-stack ()
 ""
 (interactive)
 (freekbs2-push-onto-stack buffer-file-name))

(add-to-list 'load-path "/var/lib/myfrdcsa/codebases/minor/academician/frdcsa/emacs")

(require 'academician-minor-mode)
(require 'highlights)

(defun academician-divide-into-three-windows ()
 ""
 (interactive)
 (delete-other-windows)
 (let* ((width (window-width))
	(delta (/ width 6)))
  (split-window-right)
  (shrink-window-horizontally delta)
  (other-window 1)
  (split-window-right)
  (other-window -1)))

;; (defun academician-record-definition ()
;;  (interactive)

;;  (let* ((title (academician-get-title-of-document-in-buffer-or-on-top-of-stack))
;; 	(user (kmax-get-user))
;; 	(context academician-default-context)
;; 	(formula (list "hasCitation"
;; 		  user
;; 		  (list "publication-fn" title)
;; 		  (buffer-substring-no-properties (point) (mark)))))
;;   (freekbs2-assert-formula formula context)
;;   (message (concat "Asserted " (prin1-to-string formula) " to " context))))

;; (see 
;;  (uea-query-agent-raw
;;   "FirstUnreadPage"
;;   "Academician"
;;   (freekbs2-util-data-dumper
;;    (list
;;     (list "Doc" "part2-programming") 
;;     (list "_DoNotLog" 1)))))

(defun academician-open-file (file)
 ""
 (interactive)
 (kmax-open-arbitrarily-large-file file)
 (sit-for 2)
 (doc-view-fit-page-to-window))

;; (defun academician-formalize-current-document ()
;;  ""
;;  (interactive)
;;  (digilib-process-incoming-books-into-digilib-helper
;;   (list
;;    (kmax-get-buffer-file-name-all-modes)))
;;  (let* ((name (eshell/basename (chomp (kmax-file-contents "/tmp/digilib-nlu-mf-filename.txt")))))
;;   (nlu-mf-formalize-text-from-digilib digilib-book-arg)
;;   ()))


