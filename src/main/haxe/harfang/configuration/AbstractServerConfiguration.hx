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

package harfang.configuration;

import harfang.event.ServerEventListener;
import harfang.module.Module;
import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.url.URLMapping;

/**
 * Provides a default implementation for the ServerConfiguration interface,
 * providing helper functions so you don't have to worry about how the data
 * is contained behind the scenes.
 */
class AbstractServerConfiguration implements ServerConfiguration {

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

    public function init() {
        this.modules = new List<Module>();
        this.serverEventListeners = new List<ServerEventListener>();
    }

    public function close() : Void {}

    /**************************************************************************/
    /*                                GETTERS                                 */
    /**************************************************************************/

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
