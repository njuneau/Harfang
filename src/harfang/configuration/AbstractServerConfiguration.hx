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

package harfang.configuration;

import harfang.url.URLMapping;
import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.module.Module;
import harfang.server.event.ServerEventListener;

/**
 * Provides a default implementation for the ServerConfiguration interface,
 * providing helper functions so you don't have to worry about how the data
 * is contained behind the scenes.
 *
 * By default, this implementation of the ServerConfiguration is a
 * ServerEventListener, for convenience.
 */
class AbstractServerConfiguration implements ServerConfiguration implements ServerEventListener {

    /**************************************************************************/
    /*                             PRIVATE FIELDS                             */
    /**************************************************************************/

    // The list of modules of the server side of your application
    private var modules : List<Module>;

    // The list of server event listeners
    private var serverEventListeners : List<ServerEventListener>;

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Constructs a default implementation of the server configuration
     */
    public function new() {}

    /**
     * Init event - called when the server starts
     */
    public function init() {
        this.modules = new List<Module>();
        this.serverEventListeners = new List<ServerEventListener>();
        this.serverEventListeners.add(this);
    }

    /**
     * Dispatch event - called when the queried URL corresponds to a controller
     * (the URL has been dispatched). The event is only triggered when the
     * controller's "handleRequest" returns true.
     *
     * @param urlMapping The URL mapping that was matched
     */
    public function onDispatch(urlMapping : URLMapping) : Void {}

    /**
     * Interrupted dispatch event - called when the URL dispatcher manages to
     * find the controller and method to call but that the controller's
     * handleRequest method returns false.
     *
     * @param urlMapping The URL mapping that was matched
     */
    public function onDispatchInterrupted(urlMapping : URLMapping) : Void {}

    /**
     * HTTP Error event - called when the server encounters a HTTP error
     * during URL dispatching or controller operations. Usually, these are
     * 404 or 500 errors.
     *
     * @param exception The exception that was thrown
     */
    public function onHTTPError(error : HTTPException) : Void {}

    /**
     * Error event - called when the server encounters errors that are not
     * covered by HTTP status codes. (Although the 500 error is pretty broad,
     * the developer could throw other types of exceptions that would lead
     * to this event)
     *
     * @param exception The exception that was thrown
     */
    public function onError(exception : Exception) : Void {}

    /**
     * Close event - called when the server closes
     */
    public function onClose() : Void {}

    /**************************************************************************/
    /*                                GETTERS                                 */
    /**************************************************************************/

    /**
     * Returns the modules contained in the application
     * @return The modules contained in the application
     */
    public function getModules():Iterable<Module> {
        return this.modules;
    }

    public function getServerEventListeners() : Iterable<ServerEventListener> {
        return this.serverEventListeners;
    }

    /**************************************************************************/
    /*                            PRIVATE METHODS                             */
    /**************************************************************************/

    /**
     * Adds a server module in the configuration's list of modules
     * @param module The module to add in the list
     */
    private function addModule(module : Module) : Void {
        this.modules.add(module);
    }

    /**
     * Adds a server event listener in the configuration's list of event
     * listeners
     * @param The listener to add to the list
     */
    private function addServerEventListener(listener : ServerEventListener) : Void {
        this.serverEventListeners.add(listener);
    }
}