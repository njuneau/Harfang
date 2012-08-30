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

package harfang.test.urldispatcher;

import haxe.unit2.TestCase;

import harfang.url.URLDispatcher;
import harfang.exception.Exception;
import harfang.exception.NotFoundException;
import harfang.test.urldispatcher.mock.MockURLDispatcherUserConfiguration;
import harfang.test.urldispatcher.mock.MockURLDispatcherController;

/**
 * This tests the URL dispatcher - make sure it's able to dispatch calls to the
 * controllers correctly
 */
class URLDispatcherTest extends TestCase {

    private var dispatcher : URLDispatcher;
    private var configuration : MockURLDispatcherUserConfiguration;

    /**
     * This method is called whem the test case is initialised.
     */
    @BeforeClass
    public function prepare() : Void {
        this.configuration = new MockURLDispatcherUserConfiguration();
        this.configuration.init();
        this.dispatcher = new URLDispatcher(this.configuration);
    }

    /**
     * Resets the test controller before each test
     */
    @Before
    public function before() : Void {
        MockURLDispatcherController.reset();
    }

    /**
     * Dispatch a simple URL, without parameters
     */
    @Test
    public function testDispatchSimple() {
        this.dispatcher.dispatch("/");

        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedSimple());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchSimple");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
    }

    /**
     * Same as disptach a simple URL, makes sure that the slash is appended at
     * the end of the URL.
     */
    @Test
    public function testDispatchSlash() {
        this.dispatcher.dispatch("");
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedSimple());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchSimple");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch an URL, with a single parameter
     */
    @Test
    public function testDispatchParam() {
        this.dispatcher.dispatch("/abc/");
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedParam());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchParam");

        // Make sure correct parameter is sent to the controller
        assertEquals(MockURLDispatcherController.getDispatchParamParam(), "abc");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch a simple URL, with multiple parameters
     */
    @Test
    public function testDispatchMultipleParam() {
        this.dispatcher.dispatch("/cDe/0988/");
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedMultipleParam());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchMultipleParam");

        // Make sure correct parameters are sent to the controller
        assertEquals(MockURLDispatcherController.getDispatchMutlipleParamParamA(), "cDe");

        // Make sure correct parameters are sent to the controller
        assertEquals(MockURLDispatcherController.getDispatchMutlipleParamParamB(), "0988");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch the URL, but do not call controller method (stopped at
     * handleRequest)
     */
    @Test
    public function testDoNotDispatch() {
        this.dispatcher.dispatch("/_doNotDispatch/");
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "doNotDispatch");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch an URL that is not mapped (trigger 404)
     */
    @Test
    public function testDispatchNotFound() {
        try {
            this.dispatcher.dispatch("-+-+qwe");
        } catch(e : Exception) {
            assertEquals(Type.getClass(e), NotFoundException);
        }

        assertFalse(MockURLDispatcherController.getIsInit());

        // No methods should be called
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertFalse(MockURLDispatcherController.getCalledPostRequest());
    }

}