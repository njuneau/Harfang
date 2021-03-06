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
import harfang.url.URLMapping;
import harfang.exception.Exception;
import harfang.exception.HTTPException;

/**
 * The configuration is responsible for providing the basic application
 * components such as modules and event listeners. It can be seen as the
 * developer's entry point into the framework.
 */
interface ServerConfiguration {

    /**
     * Init event - called when the server starts
     */
    public function init() : Void;

    /**
     * @return The modules contained in the application
     */
    public function getModules() : Iterable<Module>;

    /**
     * @return The components that listens to server events
     */
    public function getServerEventListeners() : Iterable<ServerEventListener>;

    /**
     * Close event - called when the server closes
     */
    public function close() : Void;

}
