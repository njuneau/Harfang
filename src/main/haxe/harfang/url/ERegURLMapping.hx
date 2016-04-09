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

import harfang.controller.Controller;
import harfang.request.RequestInfo;

/**
 * This is the framework's default request mapping implementation. It resolves a
 * request using a regular expression to match agains the request's URI and
 * extracts the controller arguments from the URL using the pattern's groups.
 *
 * With the exception of the data provided in this mapping type's constructor,
 * the class is stateless. Meaning that you can repeatedly call any of its
 * method without affecting its initial state.
 */
class ERegURLMapping implements URLMapping {

    /**************************************************************************/
    /*                             PRIVATE FIELDS                             */
    /**************************************************************************/

    private var pattern : String;
    private var patternOptions : String;
    private var httpMethod : String;
    private var controllerClass : Class<Controller>;
    private var controllerFunctionName : String;

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Construct a new URL Mapping
     *
     * @param pattern The regular expression that matches the sent URL
     * @param patternOptions The given regular expression's options
     * @param controllerClass The controller to call
     * @param controllerFunctionName The controller's function to call
     * @param httpMethod Optional, the name of the HTTP method to target. HTTP
     *        method will automatically be uppercased.
     */
    public function new(pattern : String, patternOptions : String, controllerClass : Class<Controller>, controllerFunctionName : String, ? httpMethod : String) {
        this.pattern = pattern;
        this.patternOptions = patternOptions;

        this.httpMethod = null;
        if(httpMethod != null) {
            this.httpMethod = httpMethod.toUpperCase();
        }

        this.controllerClass = controllerClass;
        this.controllerFunctionName = controllerFunctionName;
    }

    /**
     * Indicates if the request can be resolved using this mapping
     *
     * @param requestInfo The HTTP request information
     *
     * @return The resolution results
     */
    public function resolve(requestInfo : RequestInfo) : ResolutionResult {
        var urlReg : EReg = new EReg(this.pattern, this.patternOptions);
        var resolved : Bool = false;
        var arguments : Array<String> = new Array<String>();

        // Resolve agains the URL and HTTP method
        resolved = (
            urlReg.match(requestInfo.getURI()) &&
            (this.httpMethod == null || this.httpMethod == requestInfo.getMethod())
        );

        // Extract method parameters only if the request is resolved
        if(resolved) {
            var i : Int = 1;
            var argument : String = null;

            do {
                // On neko, an exception is thrown when a group is not found
                try {
                    argument = urlReg.matched(i);
                    arguments.push(argument);
                } catch (e : Dynamic) {
                    argument = null;
                }
                i++;
            } while(argument != null);
        }

        return new ResolutionResult(resolved, arguments);
    }

    /**
     * @return The controller to call if the request is resolved against this mapping
     */
    public function getControllerClass() : Class<Controller> {
        return this.controllerClass;
    }

    /**
     * @return The name of the controller method to call
     */
    public function getControllerMethodName() : String {
        return this.controllerFunctionName;
    }

}