#!/bin/sh
haxe doc-neko.hxml
haxelib run dox --toplevel-package harfang --title 'Harfang Web framework API documentation'  -i out/haxedoc.xml -o out/doc
