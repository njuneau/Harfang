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
import harfang.exception.NotFoundException;
import harfang.server.ServerMain;
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
        ServerMain.launch(this.configuration, "/");
        this.assertTrue(configuration.onDispatchCalled);
        this.assertEquals(configuration.onDispatchMapping.getControllerMethodName(), MockServerEventListenerModule.DISPATCH_SIMPLE_NAME);
    }

    /**
     * Test the "onDispatchInterrupted" event
     */
    @Test
    public function testOnDoNotDispatch() {
        ServerMain.launch(this.configuration, "/doNotDispatch/");
        this.assertTrue(configuration.onDispatchInterruptedCalled);
        this.assertFalse(configuration.onDispatchCalled);
        this.assertEquals(configuration.onDispatchInterruptedMapping.getControllerMethodName(), MockServerEventListenerModule.DO_NOT_DISPATCH_SIMPLE_NAME);
    }

    /**
     * Test the "onError" event
     */
    @Test
    public function testOnError() {
        ServerMain.launch(this.configuration, "/errorThrow/");
        this.assertTrue(configuration.onErrorCalled);
        this.assertEquals(configuration.onErrorException.getMessage(), MockServerEventListenerController.ERROR_MESSAGE);
    }

    /**
     * Test the "onHTTPError" event
     */
    @Test
    public function testOnHTTPError() {
        ServerMain.launch(this.configuration, "/httpErrorThrow/");
        this.assertTrue(configuration.onHTTPErrorCalled);
        this.assertEquals(configuration.onHTTPErrorException.getMessage(), MockServerEventListenerController.HTTP_ERROR_MESSAGE);
    }
}