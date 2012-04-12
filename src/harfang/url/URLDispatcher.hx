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

import harfang.module.Module;
import harfang.controller.Controller;
import harfang.configuration.ServerConfiguration;
import harfang.exceptions.NotFoundException;
import harfang.exceptions.ServerErrorException;

/**
 * This class handles the request made to your application
 */
class URLDispatcher {

    /**************************************************************************/
    /*                             PRIVATE FIELDS                             */
    /**************************************************************************/

    // The server's configuration
    private var serverConfiguration : ServerConfiguration;
    // The modules that this dispatcher handles
    private var modules : Iterable<Module>;
    // The URL that is currently being processed
    private var currentURL : String;

    /**
     * Constructor
     * @param serverConfiguration The server's configuration
     * @param modules The modules you want this dispatcher to handle
     */
    public function new(serverConfiguration : ServerConfiguration) {
        this.serverConfiguration = serverConfiguration;
    }

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Dipatches the URL to the correct view
     * @param url The URL to process
     */
    public function dispatch(url : String) : Void {
        this.currentURL = this.appendSlash(url);
        var dispatched : Bool = false;
        var moduleIterator : Iterator<Module> = this.serverConfiguration.getModules().iterator();

        // Scan all the URLS
        while(!dispatched && moduleIterator.hasNext()) {
            dispatched = this.scanURLs(moduleIterator.next());
        }

        // If the URL could not have been dispatched, throw a 404 error
        if(!dispatched) {
            throw new NotFoundException();
        }
    }

    /**************************************************************************/
    /*                            PRIVATE METHODS                             */
    /**************************************************************************/

    /**
     * Try matching the URLS with one of the module's regexes.
     * @return Scan status (true if URL has been found, false otherwize)
     */
    private function scanURLs(module : Module) : Bool {
        var foundURL = false;
        var mappingIterator : Iterator<URLMapping> = module.getURLMappings().iterator();
        var currentMapping : URLMapping = null;
        var controller : Controller = null;
        var controllerMethod : Dynamic = null;
        var controllerMethodParams : Array<String> = null;

        // Try matching a pattern
        while(!foundURL && mappingIterator.hasNext()) {
            currentMapping = mappingIterator.next();
            // Try matching the URL
            foundURL = currentMapping.resolve(this.currentURL);
        }

        // Call the controller
        if(foundURL) {
            // Call the dispatch event
            this.serverConfiguration.onDispatch(currentMapping);

            // Create the controller instance and find its function
            controller = Type.createEmptyInstance(currentMapping.getControllerClass());
            controllerMethod = Reflect.field(controller, currentMapping.getControllerMethodName());

            // Make the call with the correct parameters
            if(Reflect.isFunction(controllerMethod)) {
                // Init module
                controller.init(module);

                // Handle request
                if(controller.handleRequest(currentMapping.getControllerMethodName())) {
                    Reflect.callMethod(
                            controller,
                            controllerMethod,
                            currentMapping.extractParameters(this.currentURL)
                    );
                }
            } else {
                // Controller function was not found - error!
                throw new ServerErrorException();
            }
        }

        // Return the status of the search
        return foundURL;
    }


    /**
     * Appends a slash to the URL if it doesn't have one at the end.
     * It won't appear in browsers, but it will simplify the regular expressions
     * a lot.
     *
     * @param url The url in which to append the slash
     * @return The url, with the trailing slash
     */
    private function appendSlash(url : String) : String {

        if(url.charAt(url.length - 1) != "/") {
            url += "/";
        }

        return url;
    }
}