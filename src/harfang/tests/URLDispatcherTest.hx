// Harfang - A Web development framework
// Copyright (C) 2011  Nicolas Juneau <n.juneau@gmail.com>
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

package harfang.tests;

import haxe.unit2.TestCase;

import harfang.url.URLDispatcher;
import harfang.tests.mocks.MockURLDispatcherUserConfiguration;
import harfang.tests.mocks.MockURLDispatcherController;

/**
 * This tests the URL dispatcher - make sure it's able to dispatch calls to the
 * controllers correctly
 */
class URLDispatcherTest extends TestCase {

    private var dispatcher : URLDispatcher;
    private var configuration : MockURLDispatcherUserConfiguration;

    /**
     * This method is called before each test is ran
     */
    public override function prepare() : Void {
        this.configuration = new MockURLDispatcherUserConfiguration();
        this.dispatcher = new URLDispatcher(this.configuration);
    }

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
    }

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
    }

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
    }

    public function testDoNotDispatch() {
        this.dispatcher.dispatch("/doNotDispatch/");
        assertTrue(MockURLDispatcherController.getIsInit());

        // Make sure correct method is dispatched
        assertFalse(MockURLDispatcherController.getDispatchedSimple());
        assertFalse(MockURLDispatcherController.getDispatchedParam());
        assertFalse(MockURLDispatcherController.getDispatchedMultipleParam());
        assertFalse(MockURLDispatcherController.getDispatchedDoNotDispatch());
        assertEquals(MockURLDispatcherController.getLastMethodName(), "doNotDispatch");
    }

}