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
import harfang.server.request.RequestInfo;

/**
 * A URL mapping consists of a binding between a controller and a URL. Whenever
 * the user enters a URL, the dispatcher must know where to forward the request.
 * This is the job of the URL mapping: binding an URL pattern with a handler.
 */
interface URLMapping {


    /**************************************************************************/
    /*                                GETTERS                                 */
    /**************************************************************************/

    /**
     * Indicates if the URL can be resolved using this mapping
     * @param url The URL to resolve
     * @return True if the request can be resolved with this mapping, false
     * otherwize.
     */
    public function resolve(url : String) : Bool;

    /**
     * Indicates if the URL dispatcher should proceed to dispatch the request
     * given the provided request information.
     *
     * @param requestInfo Object containg the request's information.
     * @return True if the dispatcher may disptach the request, false otherwize.
     */
    public function filter(requestInfo : RequestInfo) : Bool;

    /**
     * Extracts the parameters that would be sent to this mapping's
     * controller function from the given request information.
     * PRECONDITION : It's better to extract the parameters when you know
     *                if that this mapping can resolve the given URL.
     *                Use the "resolve" method on the same URL to know.
     * @param requestInfo The erquest from which the parameters are extracted.
     * It is the same object that is sent to the "resolve" method
     * that is sent to the "resolve" method.
     * @return An array containing all the extracted parameters
     */
    public function extractParameters(requestInfo : RequestInfo) : Array<String>;

    /**
     * Returns the controller contained in the mapping
     * @return The controller contained in the mapping
     */
    public function getControllerClass() : Class<Controller>;

    /**
     * Returns the controller's method to call name
     * @return The controller's method to call name
     */
    public function getControllerMethodName() : String;
}