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
import harfang.exceptions.Exception;
import harfang.exceptions.HTTPException;


/**
 * The configuration specifies pretty much everything that the framework needs
 * to work. It is a singleton class.
 */
interface ServerConfiguration {

    /**
     * Returns the modules contained in the application
     * @return The modules contained in the application
     */
    public function getModules() : Iterable<Module>;

    /**
     * Dispatch event - called when the queried URL corresponds to a controller
     * (the URL has been dispatched). Call done before the controller is called
     *
     * @param urlMapping The URL mapping that was matched
     */
    public function onDispatch(urlMapping : URLMapping) : Void;

    /**
     * HTTP Error event - called when the server encounters a HTTP error
     * during URL dispatching or controller operations. Usually, these are
     * 404 or 500 errors.
     *
     * @param exception The exception that was thrown
     */
    public function onHTTPError(exception : HTTPException) : Void;

    /**
     * Error event - called when the server encounters an error during URL
     * dispatching or controller operations that are not covered by the 404
     * and 500 errors. (Although the 500 error is pretty broad, the user could
     * throw other types of exceptions that would lead to this event)
     *
     * @param exception The exception that was thrown
     */
    public function onError(exception : Exception) : Void;

    /**
     * Close event - called when the server closes
     */
    public function onClose() : Void;

}