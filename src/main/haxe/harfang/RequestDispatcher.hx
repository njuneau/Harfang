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

package harfang;

import harfang.configuration.ServerConfiguration;
import harfang.controller.Controller;
import harfang.event.ServerEventListener;
import harfang.exception.HTTPException;
import harfang.exception.NotFoundException;
import harfang.module.Module;
import harfang.request.RequestInfo;
import harfang.response.HTTPStatus;
import harfang.url.ResolutionResult;
import harfang.url.URLMapping;

/**
 * This class handles the request made to your application. The dispatcher
 * scans for a controller method that may be matched to the request it has been
 * told to dispatch. It does so by asking each of the mappings it has if they
 * can resolve the given request.
 *
 * Once a mapping reports that it resolves a request, the dispatcher constructs
 * the Controller associated to the request in the mapping and asks it to handle
 * the request.
 */
class RequestDispatcher {

    /**************************************************************************/
    /*                             PRIVATE FIELDS                             */
    /**************************************************************************/

    // The server's configuration
    private var serverConfiguration : ServerConfiguration;
    // The modules that this dispatcher handles
    private var modules : Iterable<Module>;

    /**
     * @param serverConfiguration The server's configuration
     */
    public function new(serverConfiguration : ServerConfiguration) {
        this.serverConfiguration = serverConfiguration;
    }

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Dipatches the request to the correct controller
     *
     * @param requestInfo The request that has been made to the server
     */
    public function dispatch(requestInfo : RequestInfo) : Void {
        var dispatched : Bool = false;
        var moduleIterator : Iterator<Module> = this.serverConfiguration.getModules().iterator();

        // Scan all the mappings
        while(!dispatched && moduleIterator.hasNext()) {
            dispatched = this.resolve(moduleIterator.next(), requestInfo).isResolved();
        }

        // If the URL could not have been dispatched, throw a not found error
        if(!dispatched) {
            throw new NotFoundException();
        }
    }

    /**************************************************************************/
    /*                            PRIVATE METHODS                             */
    /**************************************************************************/

    /**
     * Try matching the given request with one of the module's mappings.
     *
     * @param module The module that has the mappings
     * @param requestInfo The request that has been made to the server
     *
     * @return Request resolution status
     */
    private function resolve(module : Module, requestInfo : RequestInfo) : ResolutionResult {
        var serverEventListeners : Iterable<ServerEventListener> = this.serverConfiguration.getServerEventListeners();
        var mappingIterator : Iterator<URLMapping> = module.getMappings().iterator();

        // Default resolution to false
        var foundMapping = false;
        var resolutionResult : ResolutionResult = new ResolutionResult(foundMapping, new Array());

        // Try matching a mapping
        var currentMapping : URLMapping = null;
        while(!resolutionResult.isResolved() && mappingIterator.hasNext()) {
            currentMapping = mappingIterator.next();
            // Try matching the URL
            resolutionResult = currentMapping.resolve(requestInfo);
        }

        // Call the controller
        if(resolutionResult.isResolved()) {

            // Create the controller instance and find its function
            var controller : Controller = Type.createEmptyInstance(currentMapping.getControllerClass());
            var controllerMethod : Dynamic = Reflect.field(controller, currentMapping.getControllerMethodName());

            // Make the call with the correct parameters
            if(Reflect.isFunction(controllerMethod)) {
                controller.init(module);
                if(controller.beforeRequest(currentMapping, requestInfo)) {
                    // Call the dispatch event on all listeners
                    for(listener in serverEventListeners) {
                        listener.onDispatch(currentMapping, requestInfo);
                    }
                    Reflect.callMethod(controller, controllerMethod, resolutionResult.getArguments());
                    controller.afterRequest(currentMapping, requestInfo);
                } else {
                    // Dispatching interrupted, notify listeners
                    for(listener in serverEventListeners) {
                        listener.onDispatchInterrupted(currentMapping, requestInfo);
                    }
                }
            } else {
                // Controller function was not found - this should not be happening. Throw an error!
                throw new HTTPException("Controller method not found", HTTPStatus.SERVER_ERROR_INTERNAL_SERVER_ERROR);
            }
        }

        return resolutionResult;
    }
}