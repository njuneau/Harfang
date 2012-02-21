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

import harfang.url.ERegURLMapping;
import harfang.tests.mocks.MockMacroModule;
import harfang.tests.mocks.MockMacroController;

/**
 * This is the MacroConfigurator test case
 */
class MacroConfiguratorTest extends TestCase {

    /**
     * Default constructor
     */
    public function new() {
        super();
    }

    /**
     * Test the MacroConfigurator's map method
     */
    @Test
    public function testMapController() : Void {
        var module : MockMacroModule = new MockMacroModule();

        var foundHandleRequestA : Bool = false;
        var handleRequestEregOptions : Bool = false;
        var handleRequestPrefix : Bool = false;
        var handleRequestNoPrefix : Bool = false;
        var doNotHandle : Bool = false;

        for(urlMapping in module.getURLMappings()) {
            assertEquals(urlMapping.getControllerClass(), MockMacroController);
            var eregMapping : ERegURLMapping = cast(urlMapping, ERegURLMapping);
            switch(eregMapping.getControllerMethodName()) {
                case "handleRequestA":
                    foundHandleRequestA = true;
                case "handleRequestEregOptions":
                    handleRequestEregOptions = true;
                case "handleRequestPrefix":
                    handleRequestPrefix = true;
                    // TODO Find a way to detect if pattern was correctly
                    // prefixed
                case "handleRequestNoPrefix":
                    handleRequestNoPrefix = true;
                case "doNotHandleA":
                    doNotHandle = true;
                case "doNotHandleB":
                    doNotHandle = true;
                default:
            }
        }

        // Make sure all the controllers were mapped
        assertTrue(foundHandleRequestA);
        assertTrue(handleRequestEregOptions);
        assertTrue(handleRequestPrefix);
        assertTrue(handleRequestNoPrefix);
        assertFalse(doNotHandle);

        module.getURLMappings();
    }

}