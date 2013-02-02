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

package harfang.test.servereventlistener;

import haxe.unit2.TestCase;

import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.exception.WrappedException;
import harfang.server.ServerMain;
import harfang.server.request.RequestInfo;
import harfang.server.request.Method;
import harfang.test.servereventlistener.mock.MockServerEventListenerUserConfiguration;
import harfang.test.servereventlistener.mock.MockServerEventListenerModule;
import harfang.test.servereventlistener.mock.MockServerEventListenerController;
import harfang.url.URLDispatcher;

/**
 * This tests the server event listners. It makes sure that they are triggered
 * correctly.
 */
class ServerEventListenerTest extends TestCase {

    private var dispatcher : URLDispatcher;
    private var configuration : MockServerEventListenerUserConfiguration;

    /**
     * This method is called when the test case is initialised.
     */
    @BeforeClass
    public function prepare() : Void {}

    /**
     * Resets the test controller before each test
     */
    @Before
    public function before() : Void {
        this.configuration = new MockServerEventListenerUserConfiguration();
        this.configuration.init();
        this.dispatcher = new URLDispatcher(this.configuration);
    }

    /**
     * Test the "onDispatch" event
     */
    @Test
    public function testOnDispatch() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/";
        rqInfo.method = Method.GET;

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(configuration.onDispatchCalled);
        this.assertEquals(configuration.onDispatchMapping.getControllerMethodName(), MockServerEventListenerModule.DISPATCH_SIMPLE_NAME);
    }

    /**
     * Test the "onDispatchInterrupted" event
     */
    @Test
    public function testOnDoNotDispatch() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/doNotDispatch/";
        rqInfo.method = Method.GET;

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(configuration.onDispatchInterruptedCalled);
        this.assertFalse(configuration.onDispatchCalled);
        this.assertEquals(configuration.onDispatchInterruptedMapping.getControllerMethodName(), MockServerEventListenerModule.DO_NOT_DISPATCH_SIMPLE_NAME);
    }

    /**
     * Test the "onError" event
     */
    @Test
    public function testOnError() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/errorThrow/";
        rqInfo.method = Method.GET;

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(configuration.onErrorException.getMessage(), MockServerEventListenerController.ERROR_MESSAGE);
        this.assertEquals(Type.getClass(configuration.onErrorException), Exception);
        this.assertFalse(Type.getClass(configuration.onErrorException) == WrappedException);
    }

    /**
     * Test the "onError" event, with a string exception type
     */
    @Test
    public function testOnStringErrorThrow() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/stringErrorThrow/";
        rqInfo.method = Method.GET;

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(Type.getClass(configuration.onErrorException), Exception);
        this.assertFalse(Type.getClass(configuration.onErrorException) == WrappedException);
    }

    /**
     * Test the "onError" event, with an unknown exception type
     */
    @Test
    public function testOnUnknownErrorThrow() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/unknownErrorThrow/";
        rqInfo.method = Method.GET;

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(Type.getClass(configuration.onErrorException), WrappedException);
    }

    /**
     * Test the "onError" event, with a pre-wrapped exception type. The server
     * shouldn't try to wrap an already wrapped exception.
     */
    @Test
    public function testOnUnknownWrappedErrorThrow() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/unknownWrappedErrorThrow/";
        rqInfo.method = Method.GET;

        ServerMain.launch(this.configuration, rqInfo);

        // Check base error type
        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(Type.getClass(configuration.onErrorException), WrappedException);

        // Check inner error type
        var innerError : Dynamic = cast(configuration.onErrorException, WrappedException).getError();
        this.assertFalse(Type.getClass(innerError) == WrappedException);
        this.assertEquals(Type.getClass(innerError), null);

        // Make sure inner object was there
        this.assertEquals(innerError.message, "Unknown error type");
    }

    /**
     * Test the "onHTTPError" event
     */
    @Test
    public function testOnHTTPError() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/httpErrorThrow/";
        rqInfo.method = Method.GET;

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(configuration.onHTTPErrorCalled);
        this.assertEquals(configuration.onHTTPErrorException.getMessage(), MockServerEventListenerController.HTTP_ERROR_MESSAGE);
        this.assertEquals(Type.getClass(configuration.onHTTPErrorException), HTTPException);
    }
}