// Harfang - A Web development framework
// Copyright (C) 2011  Nicolas Juneau <n.juneau@gmail.com>
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

import harfang.configuration.ServerConfiguration;

/**
 * A controller handles requests from the client. 2 methods are mandatory :
 * the init method, which is called by the URL dispatcher to give the server
 * configuration, should you need it and handleRequest, which is called before
 * any subsequent call to a mapped controller method.
 *
 * You can use the handleRequest method to do any pre-request processing, but
 * in the end, you must always indicate if the URL dispatcher must call the
 * controller method specified in the URL Mapping by returning true or false.
 * This can be used, for example, to deny access to certain parts of a
 * controller depending on a user's permissions.
 */
interface Controller {

    /**
     * Called by the URL dispatcher, just after constructing the controller.
     * @param configuration The server configuration
     */
    public function init(configuration : ServerConfiguration) : Void;

    /**
     * Handles the HTTP request - called when the URL dispatcher calls the
     * controller, just before dispatching the call to the controller function
     *
     * @return True if you want the dispatcher to call the controller function
     * associated with it in the URL mapping. False if you want to prevent it
     * from calling the controller function.
     */
    public function handleRequest() : Bool;

}