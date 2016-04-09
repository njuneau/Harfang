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

package requestdispatcher;

import unit2.TestCase;

import harfang.exception.Exception;
import harfang.exception.NotFoundException;

import harfang.RequestDispatcher;
import harfang.request.RequestInfo;

import requestdispatcher.mock.MockRequestDispatcherUserConfiguration;
import requestdispatcher.mock.MockRequestDispatcherFilterConfiguration;
import requestdispatcher.mock.MockRequestDispatcherController;

/**
 * This tests the request dispatcher - make sure it's able to dispatch calls to the
 * controllers correctly
 */
class RequestDispatcherTest extends TestCase {

    private var dispatcher : RequestDispatcher;
    private var configuration : MockRequestDispatcherUserConfiguration;

    /**
     * This method is called whem the test case is initialised.
     */
    @BeforeClass
    public function prepare() : Void {
        this.configuration = new MockRequestDispatcherUserConfiguration();
        this.configuration.init();
        this.dispatcher = new RequestDispatcher(this.configuration);
    }

    /**
     * Resets the test controller before each test
     */
    @Before
    public function before() : Void {
        MockRequestDispatcherController.reset();
    }

    /**
     * Dispatch a simple URL, without parameters
     */
    @Test
    public function testDispatchSimple() {
        var rqInfo : RequestInfo = new RequestInfo("/", "GET");

        this.dispatcher.dispatch(rqInfo);

        assertTrue(MockRequestDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockRequestDispatcherController.getDispatchedParam());
        assertFalse(MockRequestDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockRequestDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockRequestDispatcherController.getDispatchedSimple());
        assertEquals(MockRequestDispatcherController.getLastMethodName(), "dispatchSimple");
        assertTrue(MockRequestDispatcherController.getCalledPostRequest());
        assertEquals(MockRequestDispatcherController.getLastPostMethodName(), "dispatchSimple");
    }

    /**
     * Same as disptach a simple URL, makes sure that the slash is appended at
     * the end of the URL.
     */
    @Test
    public function testDispatchSlash() {
        var rqInfo : RequestInfo = new RequestInfo("", "GET");

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockRequestDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockRequestDispatcherController.getDispatchedParam());
        assertFalse(MockRequestDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockRequestDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockRequestDispatcherController.getDispatchedSimple());
        assertEquals(MockRequestDispatcherController.getLastMethodName(), "dispatchSimple");
        assertTrue(MockRequestDispatcherController.getCalledPostRequest());
        assertEquals(MockRequestDispatcherController.getLastPostMethodName(), "dispatchSimple");
    }

    /**
     * Dispatch an URL, with a single parameter
     */
    @Test
    public function testDispatchParam() {
        var rqInfo : RequestInfo = new RequestInfo("/abc/", "GET");

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockRequestDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockRequestDispatcherController.getDispatchedSimple());
        assertFalse(MockRequestDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockRequestDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockRequestDispatcherController.getDispatchedParam());
        assertEquals(MockRequestDispatcherController.getLastMethodName(), "dispatchParam");
        assertTrue(MockRequestDispatcherController.getCalledPostRequest());
        assertEquals(MockRequestDispatcherController.getLastPostMethodName(), "dispatchParam");

        // Make sure correct parameter is sent to the controller
        assertEquals(MockRequestDispatcherController.getDispatchParamParam(), "abc");
        assertTrue(MockRequestDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch a simple URL, with multiple parameters
     */
    @Test
    public function testDispatchMultipleParam() {
        var rqInfo : RequestInfo = new RequestInfo("/cDe/0988/", "GET");

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockRequestDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockRequestDispatcherController.getDispatchedSimple());
        assertFalse(MockRequestDispatcherController.getDispatchedParam());
        assertFalse(MockRequestDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockRequestDispatcherController.getDispatchedMultipleParam());
        assertEquals(MockRequestDispatcherController.getLastMethodName(), "dispatchMultipleParam");
        assertTrue(MockRequestDispatcherController.getCalledPostRequest());
        assertEquals(MockRequestDispatcherController.getLastPostMethodName(), "dispatchMultipleParam");

        // Make sure correct parameters are sent to the controller
        assertEquals(MockRequestDispatcherController.getDispatchMutlipleParamParamA(), "cDe");

        // Make sure correct parameters are sent to the controller
        assertEquals(MockRequestDispatcherController.getDispatchMutlipleParamParamB(), "0988");
    }

    /**
     * Dispatch the URL, but do not call controller method (stopped at
     * handleRequest)
     */
    @Test
    public function testDoNotDispatch() {
        var rqInfo : RequestInfo = new RequestInfo("/_doNotDispatch/", "GET");

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockRequestDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockRequestDispatcherController.getDispatchedSimple());
        assertFalse(MockRequestDispatcherController.getDispatchedParam());
        assertFalse(MockRequestDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockRequestDispatcherController.getDispatchedDoNotDispatch());
        assertEquals(MockRequestDispatcherController.getLastMethodName(), "doNotDispatch");

        // The post handle request shouldn't be called when handleRequest
        // returns false.
        assertTrue(MockRequestDispatcherController.getLastPostMethodName() == null);
        assertFalse(MockRequestDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch an URL that is not mapped (trigger 404)
     */
    @Test
    public function testDispatchNotFound() {
        var rqInfo : RequestInfo = new RequestInfo("-+-+qwe", "GET");

        try {
            this.dispatcher.dispatch(rqInfo);
        } catch(e : Exception) {
            assertEquals(Type.getClass(e), NotFoundException);
        }

        assertFalse(MockRequestDispatcherController.getIsInit());

        // No methods should be called
        assertFalse(MockRequestDispatcherController.getDispatchedSimple());
        assertFalse(MockRequestDispatcherController.getDispatchedParam());
        assertFalse(MockRequestDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockRequestDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockRequestDispatcherController.getLastMethodName() == null);
        assertFalse(MockRequestDispatcherController.getCalledPostRequest());
        assertTrue(MockRequestDispatcherController.getLastPostMethodName() == null);
    }

    /**
     * Tests the dispatcher "filter" and "resolve" functionnality
     */
    @Test
    public function testResolveFilter() {
        var rqInfo : RequestInfo = new RequestInfo("/", "GET");

        var filterAndResolve : MockRequestDispatcherFilterConfiguration =
                new MockRequestDispatcherFilterConfiguration(true, true);
        filterAndResolve.init();

        var filter : MockRequestDispatcherFilterConfiguration =
                new MockRequestDispatcherFilterConfiguration(false, true);
        filter.init();

        var resolve : MockRequestDispatcherFilterConfiguration =
                new MockRequestDispatcherFilterConfiguration(true, false);
        resolve.init();

        // Resolving and filtering returns true
        var filterDispatcher : RequestDispatcher = new RequestDispatcher(filterAndResolve);
        var dispatched : Bool = true;
        try {
            filterDispatcher.dispatch(rqInfo);
        } catch(e : NotFoundException) {
            dispatched = false;
        }
        assertTrue(dispatched);

        // Resolving returns false
        filterDispatcher = new RequestDispatcher(filter);
        dispatched  = true;
        try {
            filterDispatcher.dispatch(rqInfo);
        } catch(e : NotFoundException) {
            dispatched = false;
        }
        assertFalse(dispatched);

        // Filtering returns false
        filterDispatcher = new RequestDispatcher(resolve);
        dispatched = true;
        try {
            filterDispatcher.dispatch(rqInfo);
        } catch(e : NotFoundException) {
            dispatched = false;
        }
        assertFalse(dispatched);
    }

}