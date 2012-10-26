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

package harfang.server.event;

import harfang.controller.Controller;
import harfang.url.URLMapping;
import harfang.exception.HTTPException;
import harfang.exception.Exception;

/**
 * A server event listener will receive signals from the framework regarding
 * server status. Namely, request status.
 */
interface ServerEventListener {

    /**
     * Dispatch event - called when the queried URL corresponds to a controller
     * (the URL has been dispatched). The event is only triggered when the
     * controller's "handleRequest" returns true.
     *
     * @param urlMapping The URL mapping that was matched
     */
    public function onDispatch(urlMapping : URLMapping) : Void;

    /**
     * Interrupted dispatch event - called when the URL dispatcher manages to
     * find the controller and method to call but that the controller's
     * handleRequest method returns false.
     *
     * @param urlMapping The URL mapping that was matched
     */
    public function onDispatchInterrupted(urlMapping : URLMapping) : Void;

    /**
     * HTTP Error event - called when the server encounters a HTTP error
     * during URL dispatching or controller operations. Usually, these are
     * 404 or 500 errors.
     *
     * @param exception The exception that was thrown
     */
    public function onHTTPError(exception : HTTPException) : Void;

    /**
     * Error event - called when the server encounters errors that are not
     * covered by HTTP status codes.
     *
     * @param exception The exception that was thrown
     */
    public function onError(exception : Exception) : Void;


}