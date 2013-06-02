#!/bin/sh
find -type f -name '*.hx' | sed -e '/^\.\/src\/\(unit2\|server\|harfang\/test\)/d;s/\.\/src\///;' | xargs haxe -php out/doc -cp src -xml haxedoc.xml
