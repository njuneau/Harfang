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

package harfang.exception;

/**
 * An exception is thrown when an error occurs somewhere in the application and
 * the message is displayed.
 */
class Exception {

    private var message : String;

    /**
     * Creates a new exception
     * @param message The error message
     */
    public function new(message : String) {
        this.message = message;
    }

    /**
     * Sets the error message
     * @param message The error message
     */
    private function setMessage(message : String) : Void {
        this.message = message;
    }

    /**
     * Returns the Exception's message
     * @return the Exception's message
     */
    public function getMessage() : String {
        return this.message;
    }
}