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

package harfang.server.request;

import StringTools;

/**
 * This class contains information about the HTTP request that has been made to
 * the server.
 */
class RequestInfo {

    private static var SLASH_CHAR : String = "/";

    private var uri : String;
    private var method : String;

    /**
     * Default constructor
     *
     * @param uri The request URI. A slash will automatically be appended to it.
     * @param method The request HTTP method. It will be automatically uppercased.
     */
    public function new(uri : String, method : String) {
        this.uri = this.appendSlash(uri);
        this.method = method.toUpperCase();
    }

    /**
     * Returns the request's URI
     * @return The request's URI
     */
    public function getURI() : String {
        return this.uri;
    }

    /**
     * Returns the request's method
     * @return The request's method
     */
    public function getMethod() : String {
        return this.method;
    }

    /**
     * Appends a slash to the given URI
     *
     * @param uri The URI on which we append the slash
     * @return The URI with the appended slash
     */
    private function appendSlash(uri : String) : String {
        if(!StringTools.endsWith(uri, SLASH_CHAR)) {
            uri += SLASH_CHAR;
        }

        return uri;
    }

}