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

package harfang.exceptions;

/**
 * An HTTP exception represents an error that must be communicated down to the
 * browser (400 error, 500 error etc.)
 */
class HTTPException extends Exception {

    private var errorCode : Int;

    /**
     * Construcs a new HTTP exception
     * @param message The error message
     * @param errorCode The HTTP error code
     * @param template The HTML template to render the error
     */
    public function new(message : String, errorCode : Int) {
        super(message);
        this.errorCode = errorCode;
    }

    public function getErrorCode() : Int {
        return this.errorCode;
    }
}