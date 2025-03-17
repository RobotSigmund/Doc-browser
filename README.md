# Doc-browser

Tool for generating an offline, web based and searchable documentation index. Works well with .pdf files and allows previewing.

Example:
![image](https://github.com/user-attachments/assets/c4057240-3348-4e28-a6ab-7b0ff920575f)

# Setup

1. Download or clone the repository.

2. Navigate to the folder ``_htmlresources`` and run the script ``Download_dependencies.bat``. This will auto download the necessary external javascript files.

3. Copy the folder ``_htmlresources`` into the same folder your documentation files are located. *Everything you need is now in this folder.* **You ONLY need this folder!** The folderstructure should look like this:
```
----ProjectNr Customer Project-name Documentation package
    |---_htmlresources
    +---Docs
        |---01_Administration
        |   +---Files.pdf
        |---02_Specifications
        |   +---Files.pdf
        |---03_Design_Documents
        |   +---Files.pdf
        |---04_Safety
        |   +---Files.pdf
        |---05_Installation
        |   +---Files.pdf
        |---06_Operation
        |   +---Files.pdf
        |---07_Maintenance
        |   +---Files.pdf
        +---08_Quality_Assurance
            +---Files.pdf
```

You should also make sure to have Perl installed. [https://strawberryperl.com/](https://strawberryperl.com/)

# How-to

Generate new documentation package index file by running the script ``_htmlresources/generate.pl``. This will create an ``index.html`` file in the documentation package folder. Some logfiles and the splash-index file will also be generated inside ``_htmlresources``.

# Additional info

If there are files missing, you will get a listing of these on the splash index page. If you want to ignore these warnings, just delete the ``_htmlresources\warning_if_missing.cfg`` file.

# Acknowledgments

This project uses code from the following external repositories:

- **[jQuery](https://github.com/jquery)**  
  - Description: jQuery is a fast, small, and feature-rich JavaScript library. It makes things like HTML document traversal and manipulation, event handling, animation, and Ajax much simpler with an easy-to-use API that works across a multitude of browsers.  
  - License: [MIT License](https://github.com/jquery/jquery/blob/main/LICENSE.txt)

- **[jstree](https://github.com/vakata/jstree)**  
  - Description: jsTree is jquery plugin, that provides interactive file/folder trees.  
  - License: [MIT License](https://github.com/vakata/jstree/blob/master/LICENSE-MIT)

- **[Fuse.js](https://github.com/krisk/fuse)**  
  - Description: Fuse.js is a lightweight fuzzy-search, in JavaScript, with zero dependencies.  
  - License: [Apache License 2.0](https://github.com/krisk/Fuse/blob/main/LICENSE)


