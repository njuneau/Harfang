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
import harfang.server.request.RequestInfo;

/**
 * A URL mapping consists of a binding between a controller and a request.
 * Whenever the user sends a request, the dispatcher must know where to forward
 * it. This is the job of the request mapping: binding a request with a handler.
 */
interface URLMapping {

    /**
     * Indicates if the request can be resolved using this mapping
     *
     * @param requestInfo The request to resolve
     * @return The request resolving results
     */
    public function resolve(requestInfo : RequestInfo) : ResolutionResult;

    /**
     * @return The controller to call if the request is resolved against this mapping
     */
    public function getControllerClass() : Class<Controller>;

    /**
     * @return The name of the controller method to call
     */
    public function getControllerMethodName() : String;
}