// Harfang - A Web development framework
// Copyright (C) Nicolas Juneau <n.juneau@gmail.com>
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
 * This class contains various macros to generate URL mappings using a class' metadata.
 */
class URLMappingFactory {

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
     * @URL("/")
     *
     * The macro will generate calls to the given URL mapping implementation's
     * constructor. The first parameter given to the constructor will be the
     * controller class to map. The second parameter will be the method
     * (as a string) on which the metadata is applied. Finally, in the case of
     * the example above, the last parameter will be the string "/".
     *
     * @param mappingClExpr The class of the URLMapping implementation to use
     * @param clExpr The controller's class (must be an implementation of the
     *               Controller interface)
     * @param metaTag The metadata tag that will be used to extract the URL
     * information from a controller method.
     *
     * @return An array of expressions containing custom URL mapping instances
     */
    macro public static function createMappingArray(mappingClExpr : Expr, clExpr : Expr, metaTag : String) : Expr {
        var pos : Position = Context.currentPos();

        var mappingTypeName : String = getTypeName(mappingClExpr);
        var mappingType : Type = Context.getType(mappingTypeName);

        var controllerTypeName : String = getTypeName(clExpr);
        var controllerType : Type = Context.getType(controllerTypeName);
        var block : Array<Expr> = createNewURLMappingBlock(mappingType, controllerType, metaTag, pos);

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
     * @param mappingType The type (class) of the URLMapping implementation
     * @param targetType The type (class) in which to scan for metadata
     * @param metaTag The metadata tag's name that contains the information
     * @param pos Current context position
     * @return A block of calls to URLMapping implementations constructors
     */
    private static function createNewURLMappingBlock(mappingType : Type, targetType : Type, metaTag : String, pos : Position) : Array<Expr> {
        var block : Array<Expr> = new Array<Expr>();
        var targetTypeClass : ClassType;
        var mappingTypeClass : ClassType;

        switch(mappingType) {
            case TInst(t, params):
                mappingTypeClass = t.get();
            default:
                mappingTypeClass = null;
        }

        switch(targetType) {
            case TInst(t, params):
                targetTypeClass = t.get();
            default:
                targetTypeClass = null;
        }

        if(mappingTypeClass != null && targetTypeClass != null) {
            var fieldsMeta : Map<ClassField, Array<ExprDef>> = extractMetaInformation(targetTypeClass, metaTag, pos);
            for(field in fieldsMeta.keys()) {
                var constructorParams = fieldsMeta.get(field);
                var call : Expr = createNewExpr(mappingTypeClass, targetTypeClass, field, constructorParams, pos);
                if(call != null) {
                    block.push(call);
                }
            }
        }

        return block;
    }

    /**
     * Extract a class' metadata information
     *
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
                        var fieldMeta : Array<MetadataEntry> = field.meta.get();
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
     * @param mappingClass The URL mapping implementation class
     * @param targetClass The controller class on which we map an URL
     * @param controllerMethod The controller method to map
     * @param callParams The list of parameters to pass to the URL mapping
              constructor
     * @param pos The context position
     * @return A single call to the given URL mapping implementation constructor
     */
    private static function createNewExpr(mappingClass : ClassType, targetClass : ClassType, controllerMethod : ClassField, callParams : Array<ExprDef>, pos : Position) : Expr {
        var constructorParams : Array<Expr> = new Array<Expr>();
        var constructorCall : Expr = null;

        // Send the target class' name and its method to the constructor
        constructorParams.push({pos : pos, expr : EConst(CIdent(targetClass.name))});
        constructorParams.push({pos : pos, expr : EConst(CString(controllerMethod.name))});

        // Send any supplementary metadata arguments to the constructor
        for(callParam in callParams) {
            constructorParams.push({pos : pos, expr : callParam});
        }

        // Create the constructor call
        constructorCall = {
            pos : pos,
            expr : ENew({
                    pack : mappingClass.pack,
                    name : mappingClass.name,
                    sub : null,
                    params : []
                }, constructorParams
            )
        }

        return constructorCall;
    }
}
