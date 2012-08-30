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

package harfang.test.serverconfiguration.mock;

import harfang.controller.AbstractController;
import harfang.exception.Exception;
import harfang.exception.HTTPException;

/**
 * Mock controller to use with the server configuration test
 */
class MockServerConfigurationController extends AbstractController {

    public static inline var SERVER_ERROR_MESSAGE : String = "!!!";
    public static inline var ERROR_MESSAGE_303 : String = "Unothorized";
    public static inline var ERROR_CODE_303 : Int = 303;

    /**
     * Normal handle, does nothing.
     */
    public function handleNormal() : Void {}

    /**
     * This one throws a server error, outside of the scope of HTTP errors
     */
    public function handleServerError() : Void {
        throw new Exception(SERVER_ERROR_MESSAGE);
    }

    /**
     * This one throws a server error, inside the scope of HTTP errors
     */
    public function handleHTTPError() : Void {
        throw new HTTPException(ERROR_MESSAGE_303, ERROR_CODE_303);
    }

}