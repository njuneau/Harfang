#!/bin/sh
find -type f -name '*.hx' | sed -e '/^\.\/src\/\(haxe\|server\)/d;s/\.\/src\///;' | xargs haxe -php out -cp src -xml haxedoc.xml
