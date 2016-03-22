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

package harfang.controller;

import harfang.module.Module;
import harfang.server.request.RequestInfo;
import harfang.url.URLMapping;

/**
 * A controller handles requests from the client. Instances of controllers are
 * by the URL dispatcher to handle requests from the client.
 *
 * Methods from a controller may be mapped to an URL by the user in a module
 * either by adding the maps manually into the module or by annotating
 * controller methods (see the MacroConfigurator class in harfang.configuration
 * for more details)
 *
 * When a controller method is found to match a certain URL, the URL dispatcher
 * will call the following, in order : init, handleRequest, the mapped method
 * and handlePostRequest.
 *
 * Throughout the documentation of this interface, the "mapped method" refers
 * to a controller method that has been mapped and succesfully matched to an URL
 * by the URL dispatcher.
 */
interface Controller {

    /**
     * Called by the URL dispatcher, just after constructing the controller.
     * Use this method to permorm initialisation mechanics.
     *
     * @param module The module that owns that controller
     */
    public function init(module : Module) : Void;

    /**
     * Handles the HTTP request - called just before the request dipstacher
     * calls the mapped controller method.
     *
     * You can use this method to do any pre-request processing, but in the end,
     * you must always indicate if the request dispatcher must call the
     * controller method specified in the request mapping by returning true or
     * false.
     *
     * @param mapping The request mapping that lead to this controller
     * @param requestInfo The HTTP request information
     *
     * @return True if the dispatcher must call the controller according to the
     *         given request information. False to prevent the dispatcher from
    *          calling the controller
     */
    public function handleRequest(mapping : URLMapping, requestInfo : RequestInfo) : Bool;

    /**
     * This is called after the mapped controller method has been called.
     * Use this method to perform any post-request operations.
     *
     * @param mapping Therequest mapping that lead to this contoller
     * @param requestInfo The HTTP request information
     */
    public function handlePostRequest(mapping : URLMapping, requestInfo : RequestInfo) : Void;


}