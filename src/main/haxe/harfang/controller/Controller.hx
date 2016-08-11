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
import harfang.request.RequestInfo;
import harfang.url.URLMapping;

/**
 * Instances of controllers are created by the URL dispatcher to handle requests
 * from the client.
 *
 * Methods from a controller may be mapped to an URL in a module either by
 * adding the maps manually into the module or by annotating controller methods
 * and using URLMapping factory macros.
 *
 * When a URL mapping matches a request, the dispatcher will call the following
 * on the mapped controller, in order : init, beforeRequest, the mapped method
 * and afterRequest.
 *
 * Throughout the documentation of this interface, the "mapped method" refers
 * to a controller method that has been mapped and succesfully matched to a
 * request by the dispatcher.
 */
interface Controller {

    /**
     * Called by the URL dispatcher after instanciating the controller.
     * Use this method to permorm initialisation mechanics.
     *
     * @param module The module that owns that controller
     */
    public function init(module : Module) : Void;

    /**
     * Called before the request dipstacher calls the mapped controller method.
     *
     * You can use this method to do any pre-request processing. You must
     * indicate if the dispatcher must call the controller method specified in
     * the mapping by returning true or false.
     *
     * @param mapping The mapping that lead to this controller
     * @param requestInfo The HTTP request information
     *
     * @return True if the dispatcher must call the controller according to the
     *         given request information. False to prevent the dispatcher from
    *          calling the controller
     */
    public function beforeRequest(mapping : URLMapping, requestInfo : RequestInfo) : Bool;

    /**
     * This is called after the mapped controller method has been called.
     * Use this method to perform any post-request operations.
     *
     * This method is only called when beforeRequest returns true and the
     * mapped controller method execution isn't interrupted.
     *
     * @param mapping The mapping that lead to this contoller
     * @param requestInfo The HTTP request information
     */
    public function afterRequest(mapping : URLMapping, requestInfo : RequestInfo) : Void;

}
