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

package harfang.test.serverconfiguration;

import haxe.unit2.TestCase;

import harfang.server.ServerMain;

import harfang.test.serverconfiguration.mock.MockServerConfiguration;
import harfang.test.serverconfiguration.mock.MockServerConfigurationController;

/**
 * The server configuration test tests the behaviours of the configuration
 * interface, mainly to make sure that the server events are properly
 * dispatched.
 */
class ServerConfigurationTest extends TestCase {

    private var configuration : MockServerConfiguration;

    /**
     * Create configuration
     */
    @Before
    public function setup() {
        this.configuration = new MockServerConfiguration();
        this.configuration.init();
    }

    /**
     * Destroy configuration
     */
    @After
    public function tearDown() {
        this.configuration = null;
    }

    /**
     * The mock adds a module in the constructor - make sure it's there
     */
    @Test
    public function testAddModule() {
        var count : Int = 0;
        for(module in this.configuration.getModules()) {
            count++;
        }
        assertTrue(count > 0);
    }

    /**
     * This tests the normal execution sequence of the configration's events,
     * when no errors are thrown.
     */
    @Test
    public function testNormalSequence() {
        ServerMain.launch(this.configuration, "/");

        // Make sure call sequence is ok
        assertEquals(this.configuration.getCalledOnDispatch(), 1);
        assertEquals(this.configuration.getCalledOnHTTPError(), 0);
        // Normally, if onHTTPError is called, onError should not.
        assertEquals(this.configuration.getCalledOnError(), 0);
        // We should still be able to close the application
        assertEquals(this.configuration.getCalledOnClose(), 2);
    }

    /**
     * Make sure that a 404 is thrown to the user configuration when the URL
     * dispatcher is unable to route a request
     */
    @Test
    public function testCatch404() {
        ServerMain.launch(this.configuration, "/0");

        // Make sure call sequence is ok
        assertEquals(this.configuration.getCalledOnDispatch(), 0);
        assertEquals(this.configuration.getCalledOnHTTPError(), 1);
        // Normally, if onHTTPError is called, onError should not.
        assertEquals(this.configuration.getCalledOnError(), 0);
        // We should still be able to close the application
        assertEquals(this.configuration.getCalledOnClose(), 2);

        // Make sure the correct exception is given
        assertTrue(this.configuration.getLastHTTPException() != null);
        assertTrue(this.configuration.getLastHTTPException().getErrorCode() == 404);
        assertTrue(this.configuration.getLastException() == null);
    }

    /**
     * Make sure that special exceptions are caught by the configuration
     */
    @Test
    public function testCatchError() {
        ServerMain.launch(this.configuration, "/error");

        // Make sure call sequence is ok
        assertEquals(this.configuration.getCalledOnDispatch(), 1);
        // Normally, if onError is called, onError should not.
        assertEquals(this.configuration.getCalledOnHTTPError(), 0);
        assertEquals(this.configuration.getCalledOnError(), 2);
        // We should still be able to close the application
        assertEquals(this.configuration.getCalledOnClose(), 3);

        // Make sure the correct exception is given
        assertTrue(this.configuration.getLastException() != null);
        assertEquals(this.configuration.getLastException().getMessage(), MockServerConfigurationController.SERVER_ERROR_MESSAGE);
        assertTrue(this.configuration.getLastHTTPException() == null);
    }

    /**
     * Make sure HTTP errors are correctly handled when thrown from controllers
     */
    @Test
    public function testCatchHTTPErrorInController() {
        ServerMain.launch(this.configuration, "/303");

        // Make sure call sequence is ok
        assertEquals(this.configuration.getCalledOnDispatch(), 1);
        assertEquals(this.configuration.getCalledOnHTTPError(), 2);
        // Normally, if onHTTPError is called, onError should not.
        assertEquals(this.configuration.getCalledOnError(), 0);
        // We should still be able to close the application
        assertEquals(this.configuration.getCalledOnClose(), 3);

        // Make sure the correct exception is given
        assertTrue(this.configuration.getLastHTTPException() != null);
        assertTrue(this.configuration.getLastHTTPException().getErrorCode() == MockServerConfigurationController.ERROR_CODE_303);
        assertTrue(this.configuration.getLastHTTPException().getMessage() == MockServerConfigurationController.ERROR_MESSAGE_303);
        assertTrue(this.configuration.getLastException() == null);
    }

}