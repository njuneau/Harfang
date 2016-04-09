// Harfang - A Web development framework
// Copyright (C) Nicolas Juneau <n.juneau@gmail.com>
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

package servereventlistener;

import unit2.TestCase;

import harfang.configuration.ServerConfiguration;

import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.exception.WrappedException;

import harfang.ServerMain;
import harfang.RequestDispatcher;
import harfang.request.RequestInfo;


import servereventlistener.mock.MockServerEventListenerUserConfiguration;
import servereventlistener.mock.MockServerEventListenerModule;
import servereventlistener.mock.MockServerEventListenerController;

/**
 * This tests the server event listners. It makes sure that they are triggered
 * correctly.
 */
class ServerEventListenerTest extends TestCase {

    private var dispatcher : RequestDispatcher;
    private var configuration : MockServerEventListenerUserConfiguration;

    /**
     * Resets the test controller before each test
     */
    @Before
    public function before() : Void {
        this.configuration = new MockServerEventListenerUserConfiguration();
        this.dispatcher = new RequestDispatcher(this.configuration);
    }

    /**
     * Test the "onDispatch" event
     */
    @Test
    public function testOnDispatch() {
        var rqInfo : RequestInfo = new RequestInfo("/", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(this.configuration.onStartCalled);
        this.assertTrue(this.configuration == this.configuration.onStartConfiguration);

        this.assertTrue(configuration.onDispatchCalled);
        this.assertEquals(configuration.onDispatchMapping.getControllerMethodName(), MockServerEventListenerModule.DISPATCH_SIMPLE_NAME);
        this.assertEquals(configuration.onDispatchRequestInfo, rqInfo);

        this.assertTrue(this.configuration.onCloseCalled);
        this.assertTrue(this.configuration == this.configuration.onCloseConfiguration);
    }

    /**
     * Test the "onDispatchInterrupted" event
     */
    @Test
    public function testOnDoNotDispatch() {
        var rqInfo : RequestInfo = new RequestInfo("/doNotDispatch/", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(this.configuration.onStartCalled);
        this.assertTrue(this.configuration == this.configuration.onStartConfiguration);

        this.assertTrue(configuration.onDispatchInterruptedCalled);
        this.assertFalse(configuration.onDispatchCalled);
        this.assertEquals(configuration.onDispatchInterruptedMapping.getControllerMethodName(), MockServerEventListenerModule.DO_NOT_DISPATCH_SIMPLE_NAME);
        this.assertEquals(configuration.onDispatchInterruptedRequestInfo, rqInfo);

        this.assertTrue(this.configuration.onCloseCalled);
        this.assertTrue(this.configuration == this.configuration.onCloseConfiguration);
    }

    /**
     * Test the "onError" event
     */
    @Test
    public function testOnError() {
        var rqInfo : RequestInfo = new RequestInfo("/errorThrow/", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(this.configuration.onStartCalled);
        this.assertTrue(this.configuration == this.configuration.onStartConfiguration);

        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(configuration.onErrorException.getMessage(), MockServerEventListenerController.ERROR_MESSAGE);
        this.assertEquals(Type.getClass(configuration.onErrorException), Exception);
        this.assertFalse(Type.getClass(configuration.onErrorException) == WrappedException);

        this.assertTrue(this.configuration.onCloseCalled);
        this.assertTrue(this.configuration == this.configuration.onCloseConfiguration);
    }

    /**
     * Test the "onError" event, with a string exception type
     */
    @Test
    public function testOnStringErrorThrow() {
        var rqInfo : RequestInfo = new RequestInfo("/stringErrorThrow/", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(this.configuration.onStartCalled);
        this.assertTrue(this.configuration == this.configuration.onStartConfiguration);

        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(Type.getClass(configuration.onErrorException), Exception);
        this.assertFalse(Type.getClass(configuration.onErrorException) == WrappedException);

        this.assertTrue(this.configuration.onCloseCalled);
        this.assertTrue(this.configuration == this.configuration.onCloseConfiguration);
    }

    /**
     * Test the "onError" event, with an unknown exception type
     */
    @Test
    public function testOnUnknownErrorThrow() {
        var rqInfo : RequestInfo = new RequestInfo("/unknownErrorThrow/", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(this.configuration.onStartCalled);
        this.assertTrue(this.configuration == this.configuration.onStartConfiguration);

        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(Type.getClass(configuration.onErrorException), WrappedException);

        this.assertTrue(this.configuration.onCloseCalled);
        this.assertTrue(this.configuration == this.configuration.onCloseConfiguration);
    }

    /**
     * Test the "onError" event, with a pre-wrapped exception type. The server
     * shouldn't try to wrap an already wrapped exception.
     */
    @Test
    public function testOnUnknownWrappedErrorThrow() {
        var rqInfo : RequestInfo = new RequestInfo("/unknownWrappedErrorThrow/", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(this.configuration.onStartCalled);
        this.assertTrue(this.configuration == this.configuration.onStartConfiguration);

        // Check base error type
        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(Type.getClass(configuration.onErrorException), WrappedException);

        // Check inner error type
        var innerError : Dynamic = cast(configuration.onErrorException, WrappedException).getError();
        this.assertFalse(Type.getClass(innerError) == WrappedException);
        this.assertEquals(Type.getClass(innerError), null);

        // Make sure inner object was there
        this.assertEquals(innerError.message, "Unknown error type");

        this.assertTrue(this.configuration.onCloseCalled);
        this.assertTrue(this.configuration == this.configuration.onCloseConfiguration);
    }

    /**
     * Test the "onHTTPError" event
     */
    @Test
    public function testOnHTTPError() {
        var rqInfo : RequestInfo = new RequestInfo("/httpErrorThrow/", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        this.assertTrue(this.configuration.onStartCalled);
        this.assertTrue(this.configuration == this.configuration.onStartConfiguration);

        this.assertTrue(configuration.onHTTPErrorCalled);
        this.assertEquals(configuration.onHTTPErrorException.getMessage(), MockServerEventListenerController.HTTP_ERROR_MESSAGE);
        this.assertEquals(Type.getClass(configuration.onHTTPErrorException), HTTPException);

        this.assertTrue(this.configuration.onCloseCalled);
        this.assertTrue(this.configuration == this.configuration.onCloseConfiguration);
    }
}