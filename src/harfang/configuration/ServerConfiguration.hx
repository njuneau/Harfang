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

import harfang.module.Module;
import harfang.url.URLMapping;
import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.server.event.ServerEventListener;


/**
 * The configuration specifies pretty much everything that the framework needs
 * to work.
 */
interface ServerConfiguration {

    /**
     * Init event - called when the server starts
     */
    public function init() : Void;

    /**
     * Returns the modules contained in the application
     * @return The modules contained in the application
     */
    public function getModules() : Iterable<Module>;

    /**
     * Returns the components that listens to server events
     * @return The components that listens to server events
     */
    public function getServerEventListeners() : Iterable<ServerEventListener>;

    /**
     * Close event - called when the server closes
     */
    public function onClose() : Void;

}