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

package harfang.url;

/**
 * Contains the information about the HTTP request resolution against a URL
 * mapping
 */
class ResolutionResult {

    private var resolved : Bool;
    private var arguments : Array<String>;

    /**
     * Creates the request resolution results
     *
     * @param resolved True if the request has been resolved on the URL mapping
     *
     * @param arguments The arguments that will be sent to the URL mapping's
     *                  mapped controller method. Send an empty array if the
     *                  request was not resolved or if no arguments are to be
     *                  sent to the controller.
     */
    public function new(resolved : Bool, arguments : Array<String>) {
        this.resolved = resolved;
        this.arguments = arguments;
    }

    /**
     * @return True if the request has been resolved on the URL mapping, false otherwize
     */
    public function isResolved() : Bool {
        return this.resolved;
    }

    /**
     * @return The arguments that will be sent to the URL mapping's mapped
     *         controller method. Returns an empty array if the request was not
     *         resolved or if no arguments are to be sent to the controller.
     */
    public function getArguments() : Array<String> {
        return this.arguments;
    }

}