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
     * @param eThis The module instance
     * @param controller The controller's class
     * @param metaTag The metadata tag that will be used to extract the URL
     * regular expression.
     * @return The addURLMapping expressions that will map the controllers to
     * URLs.
     */
    @:macro public static function mapController(eThis : Expr, clExpr : Expr, metaTag : String) : Expr {
        var pos : Position = Context.currentPos();
        var block : Array<Expr> = new Array<Expr>();

        switch(clExpr.expr) {
            case EConst(c):
                switch(c) {
                    case CType(s):
                        // A type has been sent. Extract Class.
                        var type = Context.getType(s);
                        switch(type) {
                            case TInst(t, params):
                                var calls : Array<Expr> = processClassMeta(eThis, t.get(), metaTag, pos);
                                for(call in calls) {
                                    block.push(call);
                                }
                            default:
                                // Not a class instance
                        }
                    default:
                        // Not a type constant
                }
            default:
                // Not a constant
        }

        return {pos : pos, expr : EBlock(block)};
    }

    /**
     * Processes a class' macros
     * @param eThis The module instance
     * @param cl The class to process
     * @param metaTag The metadata tag's name that contains the URL
     * @param pos Current context position
     */
    private static function processClassMeta(eThis : Expr, cl : ClassType, metaTag : String, pos : Position) : Array<Expr> {
        var calls : Array<Expr> = new Array<Expr>();

        // Scan for all the class' methods
        for(field in cl.fields.get()) {
            switch(field.kind) {
                case FMethod(k):
                    // If we have a method with the correct meta tag
                    if(field.meta.has(metaTag)) {
                        var found : Bool = false;
                        var i : Int = 0;
                        var fieldMeta : Array<{pos : Position, params : Array<Expr>, name : String}> = field.meta.get();
                        var urlEReg : String;
                        while(!found && i < fieldMeta.length) {

                            if(fieldMeta[i].name == metaTag) {
                                found = true;

                                // Process method URL metadata
                                if(fieldMeta[i].params.length == 1) {
                                    switch(fieldMeta[i].params[0].expr) {
                                        case EConst(c):
                                            switch(c) {
                                                case CString(s):
                                                    // Got an URL regex, create call
                                                    var call : Expr = createAddExpr(eThis, cl, field, s, pos);
                                                    calls.push(call);
                                                default:
                                            }
                                        default:
                                    }
                                }
                            }
                            i++;
                        }
                    }
                default:
            }
        }

        // Return some useful expression
        return calls;
    }

    /**
     * Creates the "addURLMapping" method call
     * @param cl The class on which we map an URL
     * @param controllerMethod The controller method to map
     * @param url The URL mapping
     * @pos The context position
     */
    private static function createAddExpr(eThis : Expr, cl : ClassType, controllerMethod : ClassField, url : String, pos : Position) : Expr {
        var params : Array<Expr> = new Array<Expr>();
        params.push({pos : pos, expr : EConst(CRegexp(url, ""))});
        params.push({pos : pos, expr : EConst(CType(cl.name))});
        params.push({pos : pos, expr : EConst(CString(controllerMethod.name))});

        var addMethod : Expr = {
            pos : pos,
            expr : ECall({
                pos : pos,
                expr : EField(eThis, "addURLMapping")
            }, params)
        }

        return addMethod;
    }

}