// Harfang - A Web development framework
// Copyright (C) 2011-2013  Nicolas Juneau <n.juneau@gmail.com>
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

package servereventlistener.mock;

import harfang.configuration.AbstractServerConfiguration;
import harfang.configuration.ServerConfiguration;

import harfang.exception.Exception;
import harfang.exception.HTTPException;

import harfang.server.event.ServerEventListener;

import harfang.url.URLMapping;

/**
 * This is a mock server configuration to test the various functionnalities of
 * the framework. It is used in the URL dispatcher test.
 */
class MockServerEventListenerUserConfiguration extends AbstractServerConfiguration implements ServerEventListener {

    public var onStartCalled(default, null) : Bool;
    public var onStartConfiguration(default, null) : ServerConfiguration;
    public var onCloseCalled(default, null) : Bool;
    public var onCloseConfiguration(default, null) : ServerConfiguration;

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
        this.addServerEventListener(this);

        this.onStartCalled = false;
        this.onStartConfiguration = null;
        this.onErrorCalled = false;
        this.onDispatchCalled = false;
        this.onDispatchInterruptedMapping = null;
        this.onDispatchInterruptedCalled = false;
        this.onDispatchInterruptedMapping = null;
        this.onHTTPErrorCalled = true;
        this.onHTTPErrorException = null;
        this.onErrorCalled = false;
        this.onErrorException = null;
        this.onCloseCalled = false;
        this.onCloseConfiguration = null;
    }

    public function onStart(configuration : ServerConfiguration) : Void {
        this.onStartCalled = true;
        this.onStartConfiguration = configuration;
    }

    public function onDispatch(urlMapping : URLMapping) : Void {
        this.onDispatchCalled = true;
        this.onDispatchMapping = urlMapping;
    }

    public function onDispatchInterrupted(urlMapping : URLMapping) : Void {
        this.onDispatchInterruptedCalled = true;
        this.onDispatchInterruptedMapping = urlMapping;
    }

    public function onHTTPError(exception : HTTPException) : Void {
        this.onHTTPErrorCalled = true;
        this.onHTTPErrorException = exception;
    }

    public function onError(exception : Exception) : Void {
        this.onErrorCalled = true;
        this.onErrorException = exception;
    }

    public function onClose(configuration : ServerConfiguration) : Void {
        this.onCloseCalled = true;
        this.onCloseConfiguration = configuration;
    }


}