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

package harfang.server.request;

/**
 * This class contains information about the HTTP request that has been made to
 * the server.
 */
class RequestInfo {

    private var uri : String;
    private var method : Method;

    /**
     * Default constructor
     */
    public function new() {
        this.uri = null;
        this.method = null;
    }

    /**
     * Returns the request's URI
     * @return The request's URI
     */
    public function getURI() : String {
        return this.uri;
    }

    /**
     * Sets the request's URI
     * @param uri The URI that has been requested
     */
    public function setURI(uri : String) : Void {
        this.uri = uri;
    }

    /**
     * Returns the request's method
     * @return The request's method
     */
    public function getMethod() : Method {
        return this.method;
    }

    /**
     * Sets the request's method
     * @param method The request's method
     */
    public function setMethod(method : Method) : Void {
        this.method = method;
    }

}