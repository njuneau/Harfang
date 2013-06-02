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

import harfang.module.Module;
import harfang.controller.Controller;
import harfang.configuration.ServerConfiguration;
import harfang.exception.NotFoundException;
import harfang.exception.ServerErrorException;
import harfang.server.event.ServerEventListener;

/**
 * This class handles the request made to your application. The dispatcher
 * scans for a method that may be matched to the URL it has been told to
 * dispatch. It does do by asking each of the URL mappings it has if they can
 * resolve the given URL.
 *
 * Once a mapping reports that it matches an URL, the dispatcher constructs the
 * Controller associated to the URL in the mapping and asks it to handle the
 * request.
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
     */
    public function new(serverConfiguration : ServerConfiguration) {
        this.serverConfiguration = serverConfiguration;
    }

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Dipatches the URL to the correct controller
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
        var serverEventListeners : Iterable<ServerEventListener> = this.serverConfiguration.getServerEventListeners();

        // Try matching a pattern
        while(!foundURL && mappingIterator.hasNext()) {
            currentMapping = mappingIterator.next();
            // Try matching the URL
            foundURL = currentMapping.resolve(this.currentURL);
        }

        // Call the controller
        if(foundURL) {
            // Create the controller instance and find its function
            controller = Type.createEmptyInstance(currentMapping.getControllerClass());
            controllerMethod = Reflect.field(controller, currentMapping.getControllerMethodName());

            // Make the call with the correct parameters
            if(Reflect.isFunction(controllerMethod)) {
                // Init module
                controller.init(module);

                // Handle request
                if(controller.handleRequest(currentMapping.getControllerMethodName())) {
                    // Call the dispatch event on all listeners
                    for(listener in serverEventListeners) {
                        listener.onDispatch(currentMapping);
                    }

                    Reflect.callMethod(
                            controller,
                            controllerMethod,
                            currentMapping.extractParameters(this.currentURL)
                    );

                    // Post request
                    controller.handlePostRequest(currentMapping.getControllerMethodName());
                } else {
                    for(listener in serverEventListeners) {
                        listener.onDispatchInterrupted(currentMapping);
                    }
                }
            } else {
                // Controller function was not found - this should not be
                // happening. Throw an error!
                throw new ServerErrorException();
            }
        }

        // Return the status of the search
        return foundURL;
    }


    /**
     * Appends a slash to the URL if it doesn't have one at the end.
     * It won't appear in browsers, but it will unify the regular expressions.
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