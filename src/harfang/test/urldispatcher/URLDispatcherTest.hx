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
import harfang.server.request.RequestInfo;
import harfang.server.request.Method;

import harfang.test.urldispatcher.mock.MockURLDispatcherUserConfiguration;
import harfang.test.urldispatcher.mock.MockURLDispatcherFilterConfiguration;
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
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/";
        rqInfo.method = Method.GET;

        this.dispatcher.dispatch(rqInfo);

        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedSimple());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchSimple");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
        assertEquals(MockURLDispatcherController.getLastPostMethodName(), "dispatchSimple");
    }

    /**
     * Same as disptach a simple URL, makes sure that the slash is appended at
     * the end of the URL.
     */
    @Test
    public function testDispatchSlash() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "";
        rqInfo.method = Method.GET;

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedSimple());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchSimple");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
        assertEquals(MockURLDispatcherController.getLastPostMethodName(), "dispatchSimple");
    }

    /**
     * Dispatch an URL, with a single parameter
     */
    @Test
    public function testDispatchParam() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/abc/";
        rqInfo.method = Method.GET;

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedParam());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchParam");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
        assertEquals(MockURLDispatcherController.getLastPostMethodName(), "dispatchParam");

        // Make sure correct parameter is sent to the controller
        assertEquals(MockURLDispatcherController.getDispatchParamParam(), "abc");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch a simple URL, with multiple parameters
     */
    @Test
    public function testDispatchMultipleParam() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/cDe/0988/";
        rqInfo.method = Method.GET;

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getDispatchedMultipleParam());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "dispatchMultipleParam");
        assertTrue(MockURLDispatcherController.getCalledPostRequest());
        assertEquals(MockURLDispatcherController.getLastPostMethodName(), "dispatchMultipleParam");

        // Make sure correct parameters are sent to the controller
        assertEquals(MockURLDispatcherController.getDispatchMutlipleParamParamA(), "cDe");

        // Make sure correct parameters are sent to the controller
        assertEquals(MockURLDispatcherController.getDispatchMutlipleParamParamB(), "0988");
    }

    /**
     * Dispatch the URL, but do not call controller method (stopped at
     * handleRequest)
     */
    @Test
    public function testDoNotDispatch() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/_doNotDispatch/";
        rqInfo.method = Method.GET;

        this.dispatcher.dispatch(rqInfo);
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "doNotDispatch");

        // The post handle request shouldn't be called when handleRequest
        // returns false.
        assertTrue(MockURLDispatcherController.getLastPostMethodName() == null);
        assertFalse(MockURLDispatcherController.getCalledPostRequest());
    }

    /**
     * Dispatch an URL that is not mapped (trigger 404)
     */
    @Test
    public function testDispatchNotFound() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "-+-+qwe";
        rqInfo.method = Method.GET;

        try {
            this.dispatcher.dispatch(rqInfo);
        } catch(e : Exception) {
            assertEquals(Type.getClass(e), NotFoundException);
        }

        assertFalse(MockURLDispatcherController.getIsInit());

        // No methods should be called
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertTrue(MockURLDispatcherController.getLastMethodName() == null);
        assertFalse(MockURLDispatcherController.getCalledPostRequest());
        assertTrue(MockURLDispatcherController.getLastPostMethodName() == null);
    }

    /**
     * Tests the dispatcher "filter" and "resolve" functionnality
     */
    @Test
    public function testResolveFilter() {
        var rqInfo : RequestInfo = new RequestInfo();
        rqInfo.uri = "/";
        rqInfo.method = Method.GET;

        var filterAndResolve : MockURLDispatcherFilterConfiguration =
                new MockURLDispatcherFilterConfiguration(true, true);
        filterAndResolve.init();

        var filter : MockURLDispatcherFilterConfiguration =
                new MockURLDispatcherFilterConfiguration(false, true);
        filter.init();

        var resolve : MockURLDispatcherFilterConfiguration =
                new MockURLDispatcherFilterConfiguration(true, false);
        resolve.init();

        // Resolving and filtering returns true
        var filterDispatcher : URLDispatcher = new URLDispatcher(filterAndResolve);
        var dispatched : Bool = true;
        try {
            filterDispatcher.dispatch(rqInfo);
        } catch(e : NotFoundException) {
            dispatched = false;
        }
        assertTrue(dispatched);

        // Resolving returns false
        filterDispatcher = new URLDispatcher(filter);
        dispatched  = true;
        try {
            filterDispatcher.dispatch(rqInfo);
        } catch(e : NotFoundException) {
            dispatched = false;
        }
        assertFalse(dispatched);

        // Filtering returns false
        filterDispatcher = new URLDispatcher(resolve);
        dispatched = true;
        try {
            filterDispatcher.dispatch(rqInfo);
        } catch(e : NotFoundException) {
            dispatched = false;
        }
        assertFalse(dispatched);
    }

}