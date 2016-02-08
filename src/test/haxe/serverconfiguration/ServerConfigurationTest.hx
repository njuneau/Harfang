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

package serverconfiguration;

import unit2.TestCase;

import harfang.server.ServerMain;
import harfang.server.request.RequestInfo;

import serverconfiguration.mock.MockServerConfiguration;
import serverconfiguration.mock.MockServerConfigurationController;

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
        this.configuration.init();
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
        var rqInfo : RequestInfo = new RequestInfo("/", "GET");

        ServerMain.launch(this.configuration, rqInfo);

        // Make sure call sequence is ok
        assertEquals(this.configuration.getCalledInit(), 1);
        assertEquals(this.configuration.getCalledClose(), 2);
    }

    /**
     * Make sure close is called even when a 404 is thrown
     */
    @Test
    public function test404() {
        var rqInfo : RequestInfo = new RequestInfo("/0", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        assertEquals(this.configuration.getCalledInit(), 1);
        assertEquals(this.configuration.getCalledClose(), 2);
    }

    /**
     * Make sure close is called even when an error occurs
     */
    @Test
    public function testError() {
        var rqInfo : RequestInfo = new RequestInfo("/error", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        assertEquals(this.configuration.getCalledInit(), 1);
        assertEquals(this.configuration.getCalledClose(), 2);
    }

    /**
     * Make sure close is called even when a HTTP error is thrown
     */
    @Test
    public function testHTTPErrorInController() {
        var rqInfo : RequestInfo = new RequestInfo("/303", "GET");

        ServerMain.launch(this.configuration, rqInfo);
        assertEquals(this.configuration.getCalledInit(), 1);
        assertEquals(this.configuration.getCalledClose(), 2);
    }

}