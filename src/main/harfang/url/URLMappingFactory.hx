// Harfang - A Web development framework
// Copyright (C) 2011-2013  Nicolas Juneau <n.juneau@gmail.com>
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

package harfang.url;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * This class contains various macros to generate URL mappings using a class'
 * metadata.
 */
class URLMappingFactory {

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
     *
     * @param clExpr The controller's class (must be an implementation of the
     * Controller interface)
     *
     * @param urlMetaTag The metadata tag that will be used to extract the URL
     * regular expression from a controller method.
     *
     * @param prefix Optional parameter that defines a string to prefix all of
     * the controller's URL. In order for this to work, the URL meta tag must
     * have 3 parameters : the URL regular expression, the regular expression's
     * options and the string in your regular expression that will be replaced
     * with the given prefix.
     *
     * @param httpMethodMetaTag Optional, the metadata tag that will be used to
     * specify the HTTP method on which the URL mapping will be valid
     *
     * @return The addURLMapping expressions that will map the controllers to
     * URLs.
     */
    macro public static function mapController(eThis : Expr, clExpr : Expr, urlMetaTag : String, ? prefix : String, ? httpMethodMetaTag : String) : Expr {
        var pos : Position = Context.currentPos();

        var typeName : String = getTypeName(clExpr);
        var type : Type = Context.getType(typeName);
        var block : Array<Expr> = createAddERegURLMappingBlock(eThis, type, urlMetaTag, httpMethodMetaTag, pos, prefix);

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
     *
     * @param urlMetaTag The metadata tag that will be used to extract the URL
     * regular expression from a controller method.
     *
     * @param prefix Optional, defines a string to prefix all of the
     * controller's URL. In order for this to work, the URL meta tag must have
     * 3 parameters : the URL regular expression, the regular expression's
     * options and the string in your regular expression that will be replaced
     * with the given prefix.
     *
     * @param httpMethodMetaTag Optional, the metadata tag that will be used to
     * specify the HTTP method on which the URL mapping will be valid
     *
     * @return An array of expressions containing all the ERegURLMapping
     * instances that maps the controllers to URLs.
     */
    macro public static function createERegUrlMappingArray(clExpr : Expr, urlMetaTag : String, ? prefix : String, ? httpMethodMetaTag : String) : Expr {
        var pos : Position = Context.currentPos();

        var typeName : String = getTypeName(clExpr);
        var type : Type = Context.getType(typeName);
        var block : Array<Expr> = createNewERegURLMappingBlock(type, urlMetaTag, httpMethodMetaTag, pos, prefix);

        return {pos : pos, expr : EArrayDecl(block)};
    }

    /**
     * This will map a controller's methods to URLs using the given meta tag
     * name.
     *
     * This mehod scans a controller for method metadata. It will use the
     * metadata of a controller's method to map it to a URL. This method
     * shouldn't have any dependency regarding the object it's called from, but
     * it is most often used from a Module instance.
     *
     * To use this macro, annotate a controller's method like this:
     * @URL("my.custom.CustomURLMapping", "/")
     *
     * The macro will generate calls to CustomURLMapping's constructor.
     * The first parameter will be the controller class to map. The second
     * parameter will be the method (as a string) on which the metadata is
     * applied and in the case of the example above, the last parameter will be
     * the string "/".
     *
     * @param clExpr The controller's class (must be an implementation of the
     * Controller interface)
     * @param metaTag The metadata tag that will be used to extract the URL
     * regular expression from a controller method.
     *
     * @return An array of expressions containing custom URL mapping instances
     */
    macro public static function createUrlMappingArray(clExpr : Expr, metaTag : String) : Expr {
        var pos : Position = Context.currentPos();

        var typeName : String = getTypeName(clExpr);
        var type : Type = Context.getType(typeName);
        var block : Array<Expr> = createNewURLMappingBlock(type, metaTag, pos);

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
     * This method creates a block of call to an object's  constructor using
     * the information of a class' metadata
     *
     * @param type The type (class) in which to scan for metadata
     * @param metaTag The metadata tag's name that contains the information
     * @param pos Current context position
     * @return A block of calls to URLMapping implementations constructors
     */
    private static function createNewURLMappingBlock(type : Type, metaTag : String, pos : Position) : Array<Expr> {
        var block : Array<Expr> = new Array<Expr>();

        switch(type) {
            case TInst(t, params):
                var fieldsMeta : Map<ClassField, Array<ExprDef>> = extractMetaInformation(t.get(), metaTag, pos);
                for(field in fieldsMeta.keys()) {
                    var callParams = fieldsMeta.get(field);
                    var call : Expr = createNewExpr(t.get(), field, callParams, pos);
                    if(call != null) {
                        block.push(call);
                    }
                }
            default:
                // Not a class instance
        }

        return block;
    }

    /**
     * This method creates a block of calls to the ERegURLMapping's constructor
     * using the information of a class' metadata.
     *
     * @param type The type (class) in which to scan for metadata
     * @param urlMetaTag The metadata tag's name that contains the URL
     * @param httpMethodMetaTag The metadata tag's name that contains the HTTP
     * method. May be left null.
     * @param pos Current context position
     * @param prefix The URL prefix, may be left null
     * @return A block of calls to ERegURLMapping constructors
     */
    private static function createNewERegURLMappingBlock(type : Type, urlMetaTag : String, httpMethodMetaTag : String, pos : Position, prefix : String) : Array<Expr> {
        var block : Array<Expr> = new Array<Expr>();

        switch(type) {
            case TInst(t, params):
                var clType : ClassType = t.get();
                var urlMetaInfo : Map<ClassField, Array<ExprDef>> = extractMetaInformation(clType, urlMetaTag, pos);
                var httpMethodMetaInfo : Map<ClassField, Array<ExprDef>> = null;

                if(httpMethodMetaTag != null) {
                    httpMethodMetaInfo = extractMetaInformation(clType, httpMethodMetaTag, pos);
                }

                // Loop through all the fields which have a URL tag defined
                for(field in urlMetaInfo.keys()) {
                    var urlParams : Array<ExprDef> = urlMetaInfo.get(field);
                    var httpMethodParams : Array<ExprDef> = null;

                    // See if we also have an HTTP method defined
                    if(httpMethodMetaInfo != null && httpMethodMetaInfo.exists(field)) {
                        httpMethodParams = httpMethodMetaInfo.get(field);
                    }

                    var call : Expr = createNewEregExpr(t.get(), field, urlParams, httpMethodParams, pos, prefix);
                    if(call != null) {
                        block.push(call);
                    }
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
     * @param urlMetaTag The metadata tag's name that contains the URL
     * @param httpMethodMetaTag The metadata tag's name that contains the HTTP
     * method. May be left null.
     * @param pos Current context position
     * @param prefix The URL prefix, may be left null
     * @return A block of calls to the "addERegURLMapping" method
     */
    private static function createAddERegURLMappingBlock(eThis : Expr, type : Type, urlMetaTag : String, httpMethodMetaTag : String, pos : Position, prefix : String) : Array<Expr> {
        var block : Array<Expr> = new Array<Expr>();

        switch(type) {
            case TInst(t, params):
                var urlMetaInfo : Map<ClassField, Array<ExprDef>> = extractMetaInformation(t.get(), urlMetaTag, pos);
                var httpMethodMetaInfo : Map<ClassField, Array<ExprDef>> = null;

                if(httpMethodMetaTag != null) {
                    httpMethodMetaInfo = extractMetaInformation(t.get(), httpMethodMetaTag, pos);
                }

                for(field in urlMetaInfo.keys()) {
                    var urlParams : Array<ExprDef> = urlMetaInfo.get(field);
                    var httpMethodParams : Array<ExprDef> = null;

                    if(httpMethodMetaInfo != null && httpMethodMetaInfo.exists(field)) {
                        httpMethodParams = httpMethodMetaInfo.get(field);
                    }

                    var call : Expr = createAddExpr(eThis, t.get(), field, urlParams, httpMethodParams, pos, prefix);
                    if(call != null) {
                        block.push(call);
                    }
                }
            default:
                // Not a class instance
        }

        return block;
    }

    /**
     * Extract a class' metadata information
     * @param cl The class to process
     * @param metaTag The metadata tag's name that contains the information
     * @param pos Current context position
     *
     * @return An array containing all the parameters contained in the field's
     * given metadata tag
     */
    private static function extractMetaInformation(cl : ClassType, metaTag : String, pos : Position) : Map<ClassField, Array<ExprDef>> {
        var callParams : Map<ClassField, Array<ExprDef>> = new Map<ClassField, Array<ExprDef>>();

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

                                var className : String = null;
                                var extractedParams : Array<ExprDef> = new Array<ExprDef>();

                                // Process method metadata
                                if(fieldMeta[i].params.length >= 1) {
                                    for(param in fieldMeta[i].params) {
                                        extractedParams.push(param.expr);
                                    }
                                    callParams.set(field, extractedParams);
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
     * Creates a constructor call for the URLMapping
     *
     * @param cl The controller class on which we map an URL
     *
     * @param controllerMethod The controller method to map
     *
     * @param callParams The list of parameters to pass to the constructor. The
     * first parameter must be the class name of the URLMapping implementation
     * to construct.
     *
     * @param pos The context position
     *
     * @return A single call to an URLMapping constructor expression or null if
     * the given call parameters are not satisfactory
     */
    private static function createNewExpr(cl : ClassType, controllerMethod : ClassField, callParams : Array<ExprDef>, pos : Position) : Expr {
        var constructorParams : Array<Expr> = new Array<Expr>();
        var constructorCall : Expr = null;

        var mappingClassPack : Array<String> = new Array<String>();
        var mappingClassName : String = null;

        // First parameter must be the class name
        switch(callParams[0]) {
            case EConst(c):
                switch(c) {
                    case CString(s):
                        var mappingClassPath : Array<String> = s.split(".");
                        var classPathLength = mappingClassPath.length;
                        var i : Int = 0;

                        // Separate class name and package from class path
                        while(i < classPathLength) {
                            if(i != classPathLength - 1) {
                                mappingClassPack.push(mappingClassPath[i]);
                            } else {
                                mappingClassName = mappingClassPath[i];
                            }
                            i++;
                        }
                    default:
                }
            default:
        }

        // Create the call only if we have the necessary information
        if(mappingClassPack.length > 0 && mappingClassName != null) {
            constructorParams.push({pos : pos, expr : EConst(CIdent(cl.name))});
            constructorParams.push({pos : pos, expr : EConst(CString(controllerMethod.name))});

            var i : Int = 1;
            var callParamsLength : Int = callParams.length;

            while(i < callParamsLength) {
                constructorParams.push({pos : pos, expr : callParams[i]});
                i++;
            }

            // Create the constructor call
            constructorCall = {
                pos : pos,
                expr : ENew({
                        pack : mappingClassPack,
                        name : mappingClassName,
                        sub : null,
                        params : []
                    }, constructorParams
                )
            }
        }

        return constructorCall;
    }

    /**
     * Creates a constructor call for the ERegURLMapping
     *
     * @param cl The controller class on which we map an URL
     *
     * @param controllerMethod The controller method to map
     *
     * @param urlParams The list of parameters that concerns the URL to pass to
     * the constructor. The first parameter must be the URL regular expression
     * pattern. The second argument may be regular expression options. The third
     * argument may be an URL prefix variable.
     *
     * @param httpMethodParams The list of parameters that concerns the targeted
     * HTTP method to pass to the constructor. May be one of "GET", "POST"...
     * this parameter may be left null.
     *
     * @param pos The context position
     *
     * @param prefix A prefix that replaces the URL prefix variable given in the
     * urlParams. May be left null.
     *
     * @return A single call to the ERegURLMapping constructor expression or
     * null if the given callParams aren't satisfactory
     */
    private static function createNewEregExpr(cl : ClassType, controllerMethod : ClassField, urlParams : Array<ExprDef>, httpMethodParams : Array<ExprDef>,  pos : Position, prefix : String) : Expr {
        var constructorCall : Expr = null;
        var url : String = null;
        var eregOptions : String = "";
        var prefixVar : String = null;
        var extractedParameters : Array<String> = extractERegURLMappingParameters(urlParams);
        var httpMethod : String = extractERegURLMappingMethodParameter(httpMethodParams);

        // Process method URL metadata
        if(extractedParameters != null) {
            if(extractedParameters.length >= 1) {
                url = extractedParameters[0];

                // Process ereg optional argument
                if(extractedParameters.length >= 2) {
                    eregOptions = extractedParameters[1];

                    // Process url prefix argument
                    if(extractedParameters.length == 3) {
                        prefixVar = extractedParameters[2];
                    }
                }
            }
        }

        // Process information only if we have at least a regular expression url
        if(url != null) {
            var params : Array<Expr> = new Array<Expr>();

            // Process prefix
            if(prefix != null && prefixVar != null) {
                url = StringTools.replace(url, prefixVar, prefix);
            }

            params.push({pos : pos, expr : EConst(CRegexp(url, eregOptions))});
            params.push({pos : pos, expr : EConst(CIdent(cl.name))});
            params.push({pos : pos, expr : EConst(CString(controllerMethod.name))});

            if(httpMethod != null) {
                params.push({pos : pos, expr : EConst(CString(httpMethod))});
            }

            constructorCall = {
                pos : pos,
                expr : ENew({
                        pack : ["harfang", "url"],
                        name : "ERegURLMapping",
                        sub : null,
                        params : []
                    }, params
                )
            }
        }

        return constructorCall;
    }

    /**
     * Creates the "addURLMapping" method call expression
     *
     * @param eThis The module instance having the "addURLMapping" method
     *
     * @param cl The controller class on which we map an URL
     *
     * @param controllerMethod The controller method to map
     *
     * @param urlParams The list of parameters that concerns the URL to pass to
     * the constructor. The first parameter must be the URL regular expression
     * pattern. The second argument may be regular expression options. The third
     * argument may be an URL prefix variable.
     *
     * @param httpMethodParams The list of parameters that concerns the targeted
     * HTTP method to pass to the constructor. May be one of "GET", "POST"...
     * this parameter may be left null.
     *
     * @param pos The context position
     *
     * @param prefix A prefix that replaces the URL prefix variable given in the
     * urlParams. May be left null.
     *
     * @return A single call to the ERegURLMapping constructor expression or
     * null if the given callParams aren't satisfactory
     *
     * @return A single addURLMapping call expression
     */
    private static function createAddExpr(eThis : Expr, cl : ClassType, controllerMethod : ClassField, urlParams : Array<ExprDef>, httpMethodParams : Array<ExprDef>, pos : Position, prefix : String) : Expr {
        var url : String = null;
        var eregOptions : String = "";
        var prefixVar : String = null;
        var extractedParameters : Array<String> = extractERegURLMappingParameters(urlParams);
        var httpMethod : String = extractERegURLMappingMethodParameter(httpMethodParams);
        var addCall : Expr = null;

        // Process method URL metadata
        if(extractedParameters != null) {
            if(extractedParameters.length >= 1) {
                url = extractedParameters[0];

                // Process ereg optional argument
                if(extractedParameters.length >= 2) {
                    eregOptions = extractedParameters[1];

                    // Process url prefix argument
                    if(extractedParameters.length == 3) {
                        prefixVar = extractedParameters[2];
                    }
                }
            }
        }

        if(url != null) {
            var params : Array<Expr> = new Array<Expr>();

            // Process prefix
            if(prefix != null && prefixVar != null) {
                url = StringTools.replace(url, prefixVar, prefix);
            }

            params.push({pos : pos, expr : EConst(CRegexp(url, eregOptions))});
            params.push({pos : pos, expr : EConst(CIdent(cl.name))});
            params.push({pos : pos, expr : EConst(CString(controllerMethod.name))});

            if(httpMethod != null) {
                params.push({pos : pos, expr : EConst(CString(httpMethod))});
            }

            addCall = {
                pos : pos,
                expr : ECall({
                    pos : pos,
                    expr : EField(eThis, "addURLMapping")
                }, params)
            }
        }

        return addCall;
    }

    /**
     * Extracts the URL-related parameters to give to ERegURLMapping's
     * constructor
     *
     * @param urlParams The list of parameters concerning the URL. The
     * first parameter must be the URL regular expression pattern. The second
     * argument may be regular expression options. The third argument may be
     * an URL prefix variable.
     *
     * @return An array containing, in order, the URL pattern and optionnaly,
     * in order, a string containing regex parameters and the prefix variable
     * to replace in the URL pattern. If callParams is malformed, this method
     * may return null.
     */
    private static function extractERegURLMappingParameters(urlParams : Array<ExprDef>) : Array<String> {
        var params : Array<String> = null;

        // First parameter must contain the URL
        if(urlParams.length >= 1) {

            switch(urlParams[0]) {
                case EConst(CString(s)):
                    // Got an URL regex, create parameters
                    params = new Array<String>();
                    params.push(s);
                default:
            }

            // Process ereg optional argument
            if(urlParams.length >= 2 && params != null) {
                switch(urlParams[1]) {
                    case EConst(CString(s)):
                        // Got an URL regex opt
                        params.push(s);
                    default:
                }

                // Process url prefix argument
                if(urlParams.length == 3 && params.length == 2) {
                    switch(urlParams[2]) {
                        case EConst(CString(s)):
                            // Got the URL prefix variable
                            params.push(s);
                        default:
                    }
                }
            }
        }

        return params;
    }

    /**
     * Extracts the HTTP method-related parameters to give to ERegURLMapping's
     * constructor
     *
     * @param methodParams The list of parameters concerning the HTTP method. It
     * must have only one element : The name of the HTTP method.
     *
     * @return The name of the HTTP method or null if none found
     */
    private static function extractERegURLMappingMethodParameter(methodParams : Array<ExprDef>) : String {
        var httpMethod : String = null;

        if(methodParams != null && methodParams.length == 1) {
            switch(methodParams[0]) {
                case EConst(CString(s)):
                    httpMethod = s;
                default:
            }
        }

        return httpMethod;
    }

}
