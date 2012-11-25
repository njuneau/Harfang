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

package harfang.test.servereventlistener.mock;

import harfang.controller.AbstractController;
import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.exception.WrappedException;
import harfang.module.Module;

/**
 * This is the mock controller that is used for the server event listener test
 * case
 */
class MockServerEventListenerController extends AbstractController {

    public static inline var ERROR_MESSAGE : String = "MockServerEventListenerController_ERROR";
    public static inline var HTTP_ERROR_MESSAGE : String = "MockServerEventListenerController_HTTP_ERROR";
    public static inline var HTTP_ERROR_CODE : Int = 404;

    /**
     * Handle a request (pre-method call)
     * @param controllerMethodName The controller method what will be called
     */
    public override function handleRequest(controllerMethodName : String) : Bool {
        var dispatch : Bool = true;

        if(controllerMethodName == "doNotDispatch") {
            dispatch = false;
        }

        return dispatch;
    }

    /**
     * Dispatch a simple request
     */
    public function dispatchSimple() : Void {}

    /**
     * Although this method is mapped in the configuration, it should not be
     * called because we prevent so in the handleRequest method.
     */
    public function doNotDispatch() : Void {}

    /**
     * This method will throw a server error
     */
    public function errorThrow() : Void {
        throw new Exception(ERROR_MESSAGE);
    }

    /**
     * This will throw an HTTP exception
     */
    public function httpErrorThrow() : Void {
        throw new HTTPException(HTTP_ERROR_MESSAGE, HTTP_ERROR_CODE);
    }

    /**
     * Throws an error with a string
     */
    public function stringErrorThrow() : Void {
        throw "Error message";
    }

    /**
     * Throws a generic error
     */
    public function unknownErrorThrow() : Void {
        throw {message : "Unknown error type"};
    }

    /**
     * Throws an already wrapped generic error
     */
    public function unknownWrappedErrorThrow() : Void {
        throw new WrappedException({message : "Unknown error type"});
    }

}