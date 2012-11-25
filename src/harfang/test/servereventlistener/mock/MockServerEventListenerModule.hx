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

import harfang.module.AbstractModule;
import harfang.test.servereventlistener.mock.MockServerEventListenerController;

/**
 * Module that is used for the URL dispatcher test
 */
class MockServerEventListenerModule extends AbstractModule {

    public static inline var DISPATCH_SIMPLE_NAME : String = "dispatchSimple";
    public static inline var DO_NOT_DISPATCH_SIMPLE_NAME : String = "doNotDispatch";
    public static inline var ERROR_THROW_NAME : String = "errorThrow";
    public static inline var HTTP_ERROR_THROW_NAME : String = "httpErrorThrow";
    public static inline var STRING_ERROR_THROW_NAME : String = "stringErrorThrow";
    public static inline var UNKNOWN_ERROR_THROW_NAME : String = "unknownErrorThrow";
    public static inline var UNKNOWN_WRAPPED_ERROR_THROW_NAME : String = "unknownWrappedErrorThrow";

    /**
     * Maps the module's controllers to URLs
     */
    public function new() {
        super();
        this.addURLMapping(~/^\/$/, MockServerEventListenerController, DISPATCH_SIMPLE_NAME);
        this.addURLMapping(~/^\/doNotDispatch\/$/, MockServerEventListenerController, DO_NOT_DISPATCH_SIMPLE_NAME);
        this.addURLMapping(~/^\/errorThrow\/$/, MockServerEventListenerController, ERROR_THROW_NAME);
        this.addURLMapping(~/^\/httpErrorThrow\/$/, MockServerEventListenerController, HTTP_ERROR_THROW_NAME);
        this.addURLMapping(~/^\/stringErrorThrow\/$/, MockServerEventListenerController, STRING_ERROR_THROW_NAME);
        this.addURLMapping(~/^\/unknownErrorThrow\/$/, MockServerEventListenerController, UNKNOWN_ERROR_THROW_NAME);
        this.addURLMapping(~/^\/unknownWrappedErrorThrow\/$/, MockServerEventListenerController, UNKNOWN_WRAPPED_ERROR_THROW_NAME);
    }

}