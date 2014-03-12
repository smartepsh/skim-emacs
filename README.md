Very early days project to work with PDF files in Skim, from EMacs.

Provides skim-minor-mode, where M-next/M-prior scrolls Skim page up/down (like scroll-other-buffer in Emacs), M-l inserts a custom org-mode link to the currently open PDF, and M-i inserts the highlighted text on the current page, plus a link. The org-mode link comes with a custom handler, which opens the file in Skim and gives focus back to Emacs (since you can page up and down from Emacs).

Currently very focused around my own workflow, happy to hear suggestions about more general functions, etc.
