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

package harfang.url;

import harfang.controller.Controller;

/**
 * A URL mapping consists of a binding between a controller and a URL. Whenever
 * the user enters a URL, the dispatcher must know where to forward the request.
 * This is the job of the URL mapping: binding an URL pattern with a handler.
 *
 * This is the framework's default URL mapping implementation. It resolves a URL
 * using a regular expression and extracts the parameters from the URL using
 * the pattern's groups.
 */
class ERegURLMapping implements URLMapping {

    /**************************************************************************/
    /*                             PRIVATE FIELDS                             */
    /**************************************************************************/

    // The regular expression that corresponds to the URL
    private var urlReg : EReg;
    // The controller class to instanciate if the URL is matched
    private var controllerClass : Class<Controller>;
    // The controller's function to call
    private var controllerFunctionName : String;

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Construct a new URL Mapping
     * @param urlReg The expression that matches the sent URL
     * @param controller The controller to call
     * @param controllerFunctionName The controller's function to call
     */
    public function new(urlReg : EReg, controllerClass : Class<Controller>, controllerFunctionName : String) {
        this.urlReg = urlReg;
        this.controllerClass = controllerClass;
        this.controllerFunctionName = controllerFunctionName;
    }

    /**************************************************************************/
    /*                                GETTERS                                 */
    /**************************************************************************/

    /**
     * Indicates if the URL can be resolved using this mapping
     * @param url The URL to resolve
     * @return True if the URL can be resolved with this mapping, false otherwize
     */
    public function resolve(url : String) : Bool {
        return this.urlReg.match(url);
    }

    /**
     * Extracts the parameters that would be sent to this mapping's
     * controller function from the given URL
     * PRECONDITION : It's better to extract the parameters when you know
     *                if that this mapping can resolve the given URL.
     *                Use the "resolve" method on the same URL to know.
     * @param url The URL on which we extract the parameters
     * @return An array containing all the extracted parameters
     */
    public function extractParameters(url : String) : Array<String> {
        var parameters : Array<String> = new Array();
        var counter : Int = 1;
        var parameter : String = null;

        // Get trough all the groups and fill the needed parameters
        do {
            // On neko, an exception is thrown when a group is not found
            try {
                parameter = this.urlReg.matched(counter);
                parameters.push(parameter);
            } catch (error : Dynamic) {
                parameter = null;
            }
            counter++;
        } while(parameter != null);

        return parameters;
    }

    /**
     * Returns the controller contained in the mapping
     * @return The controller contained in the mapping
     */
    public function getControllerClass() : Class<Controller> {
        return this.controllerClass;
    }

    /**
     * Returns the controller's method to call name
     * @return The controller's method to call name
     */
    public function getControllerMethodName() : String {
        return this.controllerFunctionName;
    }

}