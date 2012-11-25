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

import harfang.configuration.AbstractServerConfiguration;
import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.url.URLMapping;

/**
 * This is a mock server configuration to test the various functionnalities of
 * the framework. It is used in the URL dispatcher test.
 */
class MockServerEventListenerUserConfiguration extends AbstractServerConfiguration {

    public var onDispatchCalled(default, null) : Bool;
    public var onDispatchMapping(default, null) : URLMapping;

    public var onDispatchInterruptedCalled(default, null) : Bool;
    public var onDispatchInterruptedMapping(default, null) : URLMapping;

    public var onHTTPErrorCalled(default, null) : Bool;
    public var onHTTPErrorException(default, null) : HTTPException;

    public var onErrorCalled(default, null) : Bool;
    public var onErrorException(default, null) : Exception;

    /**
     * Create the new mock
     */
    public function new() {
        super();
    }

    /**
     * Add the modules in init
     */
    public override function init() : Void {
        super.init();
        this.addModule(new MockServerEventListenerModule());

        this.onDispatchCalled = false;
        this.onDispatchInterruptedMapping = null;
        this.onDispatchInterruptedCalled = false;
        this.onDispatchInterruptedMapping = null;
        this.onHTTPErrorCalled = true;
        this.onHTTPErrorException = null;
        this.onErrorCalled = false;
        this.onErrorException = null;
    }

    /**
     * Dispatch event - called when the queried URL corresponds to a controller
     * (the URL has been dispatched). The event is only triggered when the
     * controller's "handleRequest" returns true.
     *
     * @param urlMapping The URL mapping that was matched
     */
    public override function onDispatch(urlMapping : URLMapping) : Void {
        this.onDispatchCalled = true;
        this.onDispatchMapping = urlMapping;
    }

    /**
     * Interrupted dispatch event - called when the URL dispatcher manages to
     * find the controller and method to call but that the controller's
     * handleRequest method returns false.
     *
     * @param urlMapping The URL mapping that was matched
     */
    public override function onDispatchInterrupted(urlMapping : URLMapping) : Void {
        this.onDispatchInterruptedCalled = true;
        this.onDispatchInterruptedMapping = urlMapping;
    }

    /**
     * HTTP Error event - called when the server encounters a HTTP error
     * during URL dispatching or controller operations. Usually, these are
     * 404 or 500 errors.
     *
     * @param exception The exception that was thrown
     */
    public override function onHTTPError(exception : HTTPException) : Void {
        this.onHTTPErrorCalled = true;
        this.onHTTPErrorException = exception;
    }

    /**
     * Error event - called when the server encounters an error during URL
     * dispatching or controller operations that are not covered by the 404
     * and 500 errors. (Although the 500 error is pretty broad, the user could
     * throw other types of exceptions that would lead to this event)
     *
     * @param exception The exception that was thrown
     */
    public override function onError(exception : Exception) : Void {
        this.onErrorCalled = true;
        this.onErrorException = exception;
    }


}