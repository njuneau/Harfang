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

import harfang.exceptions.HTTPException;

/**
 * The 404 exception is thrown whenever something is not found, server-side.
 */
class NotFoundException extends HTTPException {

    /**
     * Creates a new 404 not found HTTP error
     * @param message The message you want to show to the user (optional)
     */
    public function new(? message : String) {
        super("The requested resource could not be found", 404);

        // If no default message is sent, put a default one
        if(message != null) {
            this.setMessage(message);
        }
    }
}