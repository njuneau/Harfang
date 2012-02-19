// Harfang - A Web development framework
// Copyright (C) 2011  Nicolas Juneau <n.juneau@gmail.com>
// Full copyright notice can be found in the project root's "COPYRIGHT" file
//
// This file is part of Harfang.
//
// Harfang is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Harfang is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Harfang.  If not, see <http://www.gnu.org/licenses/>.

package harfang.configuration;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * The macro configurator is used to automatically configure modules at
 * compile time using haXe macros and metadata.
 */
class MacroConfigurator {

    /**
     * This will map a controller's methods to URLs using the given meta tag
     * name. Use this macro inside an AbstractModule instance.
     *
     * @param controllerName The name of the controller
     * @param metaTag The metadata tag that will be used to extract the URL
     * regular expression.
     * @return The addURLMapping expressions that will map the controllers to
     * URLs.
     */
    @:macro public static function mapController(controllerName : String, metaTag : String) : Expr {
        var pos : Position = Context.currentPos();
        var type : haxe.macro.Type = Context.getType(controllerName);

        switch(type) {
            case TInst(t, params):
                processClassMeta(t.get(), metaTag);
            default:
        }

        return {pos : pos, expr : EConst(CString("Not implemented yet"))};
    }

    /**
     * Processes a class' macros
     */
    private static function processClassMeta(cl : ClassType, metaTag : String) {
        // Scan for all the class' methods
        for(field in cl.fields.get()) {
            switch(field.kind) {
                case FMethod(k):
                    // If we have a method with the correct meta tag
                    if(field.meta.has(metaTag)) {
                        var found : Bool = false;
                        var i : Int = 0;
                        var fieldMeta : Array<{pos : Position, params : Array<Expr>, name : String}> = field.meta.get();
                        while(!found && i < fieldMeta.length) {
                            if(fieldMeta[i].name == metaTag) {
                                found = true;

                                // Process method URL metadata
                            }
                            i++;
                        }
                    }
                default:
            }
        }

        // Return some useful expression
    }

}