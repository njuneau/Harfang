// Harfang - A Web development framework
// Copyright (C) 2011-2012  Nicolas Juneau <n.juneau@gmail.com>
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
 * The macro configurator is used to automatically configure various parts of
 * the framework at compile time using Haxe macros and metadata.
 */
class MacroConfigurator {

    /**
     * This will map a controller's methods to URLs using the given meta tag
     * name. Use this macro inside an AbstractModule instance.
     *
     * This mehod scans a controller for method metadata. It will use the
     * metadata of a controller's method to map it to a URL. This method depends
     * on AbstractModule's addURLMapping method. Thus, it can only be used with
     * AbstractModule or a Module implementation that supports the same
     * addURLMapping method.
     *
     * @param eThis The module instance (must be a subclass of AbstractModule)
     * @param clExpr The controller's class (must be an implementation of the
     * Controller interface)
     * @param metaTag The metadata tag that will be used to extract the URL
     * regular expression from a controller method.
     * @param prefix Optional parameter that defines a string to prefix all of
     * the controller's URL. In order for this to work, the URL meta tag must
     * have 3 parameters : the URL regular expression, the regular expression's
     * options and the string in your regular expression that will be replaced
     * with the given prefix.
     *
     * @return The addURLMapping expressions that will map the controllers to
     * URLs.
     */
    macro public static function mapController(eThis : Expr, clExpr : Expr, metaTag : String, ? prefix : String) : Expr {
        var pos : Position = Context.currentPos();

        var typeName : String = getTypeName(clExpr);
        var type : Type = Context.getType(typeName);
        var block : Array<Expr> = createAddERegURLMappingBlock(eThis, type, metaTag, pos, prefix);

        return {pos : pos, expr : EBlock(block)};
    }

    /**
     * This will map a controller's methods to URLs using the given meta tag
     * name. Use this macro inside a Module instance.
     *
     * This mehod scans a controller for method metadata. It will use the
     * metadata of a controller's method to map it to a URL. This method
     * shouldn't have any dependency regarding the object it's called from, but
     * it is most often used from a Module instance.
     *
     * @param clExpr The controller's class (must be an implementation of the
     * Controller interface)
     * @param metaTag The metadata tag that will be used to extract the URL
     * regular expression from a controller method.
     * @param prefix Optional parameter that defines a string to prefix all of
     * the controller's URL. In order for this to work, the URL meta tag must
     * have 3 parameters : the URL regular expression, the regular expression's
     * options and the string in your regular expression that will be replaced
     * with the given prefix.
     *
     * @return An array expression containing all the ERegURLMapping instances
     * that maps the controllers to URLs.
     */
    macro public static function createERegUrlMappingArray(clExpr : Expr, metaTag : String, ? prefix : String) : Expr {
        var pos : Position = Context.currentPos();

        var typeName : String = getTypeName(clExpr);
        var type : Type = Context.getType(typeName);
        var block : Array<Expr> = createNewERegURLMappingBlock(type, metaTag, pos, prefix);

        return {pos : pos, expr : EArrayDecl(block)};
    }

    /**
     * Returns the type name of the given class instance expression or
     * null if what has been given to this function is not a class instance
     * expression.
     *
     * @param clExpr A class instance expression
     * @return The class' name or null if clExpr was not a class instance
     * expression
     */
    private static function getTypeName(clExpr : Expr) : Dynamic {
        var typeName : String = null;

        switch(clExpr.expr) {
            case EConst(c):
                switch(c) {
                    case CIdent(s):
                        // A type has been sent. Extract class name
                        typeName = s;
                    default:
                        // Not a type constant
                }
            default:
                // Not a constant
        }

        return typeName;
    }

    /**
     * This method creates a block of calls to the ERegURLMapping's constructor
     * using the information of a class' metadata.
     *
     * @param type The type (class) in which to scan for metadata
     * @param metaTag The metadata tag's name that contains the URL
     * @param pos Current context position
     * @param prefix The URL prefix
     */
    private static function createNewERegURLMappingBlock(type : Type, metaTag : String, pos : Position, prefix : String) : Array<Expr> {
        var block : Array<Expr> = new Array<Expr>();

        switch(type) {
            case TInst(t, params):
                var callParams : Array<Dynamic> = processClassMeta(t.get(), metaTag, pos, prefix);
                for(callParam in callParams) {
                    var call : Expr = createNewExpr(t.get(), callParam.field, callParam.urlEReg, pos, callParam.eregOpts, prefix, callParam.urlPrefixVar);
                    block.push(call);
                }
            default:
                // Not a class instance
        }

        return block;
    }

    /**
     * This method creates a block of calls to the "addURLMapping" method of the
     * given module instance.
     *
     * @param eThis The module instance in ehich the block will be inserted
     * @param type The type (class) in which to scan for metadata
     * @param metaTag The metadata tag's name that contains the URL
     * @param pos Current context position
     * @param prefix The URL prefix
     */
    private static function createAddERegURLMappingBlock(eThis : Expr, type : Type, metaTag : String, pos : Position, prefix : String) : Array<Expr> {
        var block : Array<Expr> = new Array<Expr>();

        switch(type) {
            case TInst(t, params):
                var callParams : Array<Dynamic> = processClassMeta(t.get(), metaTag, pos, prefix);
                for(callParam in callParams) {
                    var call : Expr = createAddExpr(eThis, t.get(), callParam.field, callParam.urlEReg, pos, callParam.eregOpts, prefix, callParam.urlPrefixVar);
                    block.push(call);
                }
            default:
                // Not a class instance
        }

        return block;
    }

    /**
     * Processes a class' macros
     * @param cl The class to process
     * @param metaTag The metadata tag's name that contains the URL
     * @param pos Current context position
     * @param prefix The URL prefix
     * @return A object containing all the parameters necessary to generation of
     * an ERegURLMapping. The object has the following structure :
     * { field, urlEReg, eregOpts, urlPrefixVar }
     *
     */
    private static function processClassMeta(cl : ClassType, metaTag : String, pos : Position, ? prefix : String) : Array<Dynamic> {
        var callParams : Array<Dynamic> = new Array<Dynamic>();

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

                                var urlEReg : String = null;
                                var eregOpts : String = "";
                                var urlPrefixVar : String = null;

                                // Process method URL metadata
                                if(fieldMeta[i].params.length >= 1) {
                                    switch(fieldMeta[i].params[0].expr) {
                                        case EConst(c):
                                            switch(c) {
                                                case CString(s):
                                                    // Got an URL regex, create call
                                                    urlEReg = s;
                                                default:
                                            }
                                        default:
                                    }

                                    // Process ereg optional argument
                                    if(fieldMeta[i].params.length >= 2) {
                                        switch(fieldMeta[i].params[1].expr) {
                                            case EConst(c):
                                                switch(c) {
                                                    case CString(s):
                                                        // Got an URL regex opt
                                                        eregOpts = s;
                                                    default:
                                                }
                                            default:
                                        }

                                        // Process url prefix argument
                                        if(fieldMeta[i].params.length == 3) {
                                            switch(fieldMeta[i].params[2].expr) {
                                                case EConst(c):
                                                    switch(c) {
                                                        case CString(s):
                                                            // Got the URL prefix variable
                                                            urlPrefixVar = s;
                                                        default:
                                                    }
                                                default:
                                            }
                                        }

                                    }
                                }

                                // If we have at least the URL regex, create the
                                // ERegUrlMapping parameters
                                if(urlEReg != null) {
                                    callParams.push({
                                        field : field,
                                        urlEReg : urlEReg,
                                        eregOpts : eregOpts,
                                        urlPrefixVar : urlPrefixVar
                                    });
                                }
                            }
                            i++;
                        }
                    }
                default:
            }
        }

        // Return some useful expression
        return callParams;
    }

    /**
     * Creates the "addURLMapping" method call expression
     * @param cl The controller class on which we map an URL
     * @param controllerMethod The controller method to map
     * @param url The URL regular expression mapping
     * @pos The context position
     * @param eregOptions The regular expression's options
     * @param prefix the URL prefix
     * @param prefixVar The part of the regular expression to replace with the
     * prefix
     * @return A single addURLMapping call expression
     */
    private static function createAddExpr(eThis : Expr, cl : ClassType, controllerMethod : ClassField, url : String, pos : Position, eregOptions : String, ? prefix : String, ? prefixVar : String) : Expr {
        var params : Array<Expr> = new Array<Expr>();

        // Process prefix
        if(prefix != null && prefixVar != null) {
            url = StringTools.replace(url, prefixVar, prefix);
        }

        params.push({pos : pos, expr : EConst(CRegexp(url, eregOptions))});
        params.push({pos : pos, expr : EConst(CIdent(cl.name))});
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

    /**
     * Creates a constructor call for the ERegURLMapping
     * @param cl The controller class on which we map an URL
     * @param controllerMethod The controller method to map
     * @param url The URL regular expression mapping
     * @param pos The context position
     * @param eregOptions The regular expression's options
     * @param prefix the URL prefix
     * @param prefixVar The part of the regular expression to replace with the
     * prefix
     * @return A single call to the ERegURLMapping constructor expression
     */
    private static function createNewExpr(cl : ClassType, controllerMethod : ClassField, url : String, pos : Position, eregOptions : String, ? prefix : String, ? prefixVar : String) : Expr {
        var params : Array<Expr> = new Array<Expr>();

        // Process prefix
        if(prefix != null && prefixVar != null) {
            url = StringTools.replace(url, prefixVar, prefix);
        }

        params.push({pos : pos, expr : EConst(CRegexp(url, eregOptions))});
        params.push({pos : pos, expr : EConst(CIdent(cl.name))});
        params.push({pos : pos, expr : EConst(CString(controllerMethod.name))});

        var constructorCall : Expr = {
            pos : pos,
            expr : ENew({
                    pack : ["harfang", "url"],
                    name : "ERegURLMapping",
                    sub : null,
                    params : []
                }, params
            )
        }

        return constructorCall;
    }

}
