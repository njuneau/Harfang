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

package harfang.event;

import harfang.configuration.ServerConfiguration;
import harfang.controller.Controller;
import harfang.exception.HTTPException;
import harfang.exception.Exception;
import harfang.request.RequestInfo;
import harfang.url.URLMapping;

/**
 * A server event listener receive signals from the framework at various moments
 * in the application lifecycle.
 */
interface ServerEventListener {

    /**
     * Application start event. Called after the ServerConfiguration is
     * initialized.
     *
     * @param configuration The configuration that is used to start the application
     */
    public function onStart(configuration : ServerConfiguration) : Void;

    /**
     * Application close event. Called before the ServerConfiguration object is
     * closed.
     *
     * @param configuration The configuration that has been used throughout the application
     */
    public function onClose(configuration : ServerConfiguration): Void;

    /**
     * Dispatch event. Called when the queried URL corresponds to a controller
     * (the URL has been dispatched). The event is only triggered when the
     * controller's "handleRequest" returns true.
     *
     * @param urlMapping The mapping that was matched
     * @param requestInfo The request information
     */
    public function onDispatch(urlMapping : URLMapping, requestInfo : RequestInfo) : Void;

    /**
     * Interrupted dispatch event. Called when the URL dispatcher manages to
     * find the controller to call, but the controller's handleRequest method
     * returns false.
     *
     * @param urlMapping The mapping that was matched
     * @param requestInfo The request information
     */
    public function onDispatchInterrupted(urlMapping : URLMapping, requestInfo : RequestInfo) : Void;

    /**
     * HTTP Error event. Called when the server encounters a HTTP error
     * during dispatching or controller operations. Usually, these are 404 or
     * 500 errors.
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
