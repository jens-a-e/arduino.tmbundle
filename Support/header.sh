#!/bin/bash

# =======================
# = Insert Highlight.js =
# =======================
echo "<script>"
cat  "$TM_BUNDLE_SUPPORT/highlight/highlight.pack.js"
echo "</script>"

# =====================
# = Init Highlight.js =
# =====================
echo "<script>"
echo "  hljs.tabReplace = '    ';"
echo "  hljs.initHighlightingOnLoad();"
echo "</script>"

# ====================
# = Insert the style =
# ====================
echo "<style>"
cat  "$TM_BUNDLE_SUPPORT/highlight/styles/github.css"
cat  "$TM_BUNDLE_SUPPORT/css/style.css"
echo "</style>"
