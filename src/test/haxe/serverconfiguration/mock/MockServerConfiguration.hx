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

package serverconfiguration.mock;

import harfang.configuration.AbstractServerConfiguration;
import harfang.url.URLMapping;
import harfang.exception.Exception;
import harfang.exception.HTTPException;

/**
 * The mock server condifuration is used to test the different behaviours of
 * the ServerConfiguration interface, mainly the events sent by the server.
 */
class MockServerConfiguration extends AbstractServerConfiguration {

    private var calledInit : Int;
    private var calledClose : Int;
    private var sequence : Int;

    /**
     * Creates the new server configuration
     */
    public function new() {
        super();
        this.sequence = 0;
    }

    /**
     * Initialise the configuration
     */
    public override function init() {
        super.init();
        this.addModule(new MockServerConfigrationModule());
        this.calledInit = ++this.sequence;
    }

    public override function close() : Void {
        this.calledClose = ++this.sequence;
    }

    /**
     * Indicates if "init" was called
     * @return An integer indicating when the call was done
     */
    public function getCalledInit() : Int {
        return this.calledInit;
    }

    /**
     * Indicates if "close" was called
     * @return An integer indicating when the call was done
     */
    public function getCalledClose() : Int {
        return this.calledClose;
    }

}