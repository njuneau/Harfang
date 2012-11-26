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

import harfang.exception.Exception;

/**
 * Exceptions of this type are used when the error type is unknown. Harfang
 * looks for an "Exception" instance or a String instance when catching errors.
 * However, an error with a type not covered in the previous cases may be
 * thrown. In the case the type is unknown, the framework wraps the error in a
 * WrappedException. The developer shoulnd't have to directly use this class.
 */
class WrappedException extends Exception {

    private static var MESSAGE : String = "An error of an undertermined type has been thrown.";

    private var error : Dynamic;

    /**
     * Creates a new WrappedException with the given error instance
     * @param The error to wrap
     */
    public function new(error : Dynamic) {
        super(MESSAGE);
        this.error = error;
    }

    /**
     * Returns the underlying error that is wrapped in this exception
     * @return The underlying error that is wrapped in this exception
     */
    public function getError() : Dynamic {
        return this.error;
    }

}