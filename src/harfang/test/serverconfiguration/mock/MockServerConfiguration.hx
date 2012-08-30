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

import harfang.configuration.AbstractServerConfiguration;
import harfang.url.URLMapping;
import harfang.exception.Exception;
import harfang.exception.HTTPException;

/**
 * The mock server condifuration is used to test the different behaviours of
 * the ServerConfiguration interface, mainly the events sent by the server.
 */
class MockServerConfiguration extends AbstractServerConfiguration {

    private var calledOnDispatch : Int;
    private var calledOnHTTPError : Int;
    private var calledOnClose : Int;
    private var calledOnError : Int;
    private var lastHTTPException : HTTPException;
    private var lastException : Exception;

    private var sequence : Int;

    /**
     * Creates the new server configuration
     */
    public function new() {
        super();
    }

    /**
     * Initialise the configuration
     */
    public override function init() {
        super.init();
        this.addModule(new MockServerConfigrationModule());
        this.sequence = 0;
        this.calledOnDispatch = 0;
        this.calledOnHTTPError = 0;
        this.calledOnError = 0;
        this.calledOnClose = 0;

    }

    public override function onDispatch(urlMapping : URLMapping) : Void {
        this.sequence++;
        this.calledOnDispatch = this.sequence;
    }

    public override function onHTTPError(error : HTTPException) : Void {
        this.sequence++;
        this.calledOnHTTPError = this.sequence;
        this.lastHTTPException = error;
    }

    public override function onError(error : Exception) : Void {
        this.sequence++;
        this.calledOnError = this.sequence;
        this.lastException = error;
    }

    public override function onClose() : Void {
        this.sequence++;
        this.calledOnClose = this.sequence;
    }

    /**
     * Indicates if "onDispatch" was called
     * @return An integer indicating when the call was done.
     */
    public function getCalledOnDispatch() : Int {
        return this.calledOnDispatch;
    }

    /**
     * Indicates if "onHTTPError" was called
     * @return An integer indicating when the call was done.
     */
    public function getCalledOnHTTPError() : Int {
        return this.calledOnHTTPError;
    }

    /**
     * Indicates if "onError" was called
     * @return An integer indicating when the call was done.
     */
    public function getCalledOnError() : Int {
        return this.calledOnError;
    }

    /**
     * Indicates if "onDispatch" was called
     * @return An integer indicating when the call was done.
     */
    public function getCalledOnClose() : Int {
        return this.calledOnClose;
    }

    /**
     * Returns the last received HTTP exception
     * @return The las received HTTP exception
     */
    public function getLastHTTPException() : HTTPException {
        return this.lastHTTPException;
    }

    /**
     * Returns the last received server exception
     * @return The las received server exception
     */
    public function getLastException() : Exception {
        return this.lastException;
    }

}