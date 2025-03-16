
:: Download Fuse
mkdir "fuse.js"
curl -o "fuse.js\fuse.min.js" https://raw.githubusercontent.com/krisk/Fuse/refs/heads/main/dist/fuse.min.js
curl -o "fuse.js\LICENSE" https://raw.githubusercontent.com/krisk/Fuse/refs/heads/main/LICENSE

:: Download JsTree
mkdir "jstree"
mkdir "jstree\themes"
mkdir "jstree\themes\default"
curl -o "jstree\jstree.min.js" https://raw.githubusercontent.com/vakata/jstree/refs/heads/master/dist/jstree.min.js
curl -o "jstree\themes\default\32px.png" https://raw.githubusercontent.com/vakata/jstree/refs/heads/master/dist/themes/default/32px.png
curl -o "jstree\themes\default\40px.png" https://raw.githubusercontent.com/vakata/jstree/refs/heads/master/dist/themes/default/40px.png
curl -o "jstree\themes\default\style.min.css" https://raw.githubusercontent.com/vakata/jstree/refs/heads/master/dist/themes/default/style.min.css
curl -o "jstree\themes\default\throbber.gif" https://raw.githubusercontent.com/vakata/jstree/refs/heads/master/dist/themes/default/throbber.gif
curl -o "jstree\LICENSE-MIT" https://raw.githubusercontent.com/vakata/jstree/refs/heads/master/LICENSE-MIT

:: Download jQuery
mkdir "jquery"
curl -o "jquery\jquery-latest.min.js" https://code.jquery.com/jquery-latest.min.js
curl -o "jquery\LICENSE.txt" https://raw.githubusercontent.com/jquery/jquery/refs/heads/main/LICENSE.txt

:: Wait before closing window
timeout /t 5 /nobreak >nul
