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

package harfang.test.macroconfigurator;

import haxe.unit2.TestCase;

import harfang.configuration.MacroConfigurator;
import harfang.server.request.RequestInfo;
import harfang.server.request.Method;
import harfang.url.ERegURLMapping;

import harfang.test.macroconfigurator.mock.MockMacroModule;
import harfang.test.macroconfigurator.mock.MockMacroController;

/**
 * This is the MacroConfigurator test case
 */
class MacroConfiguratorTest extends TestCase {

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

        var testRequestInfo : RequestInfo = new RequestInfo();
        testRequestInfo.setMethod(Method.GET);

        for(urlMapping in module.getURLMappings()) {
            assertEquals(urlMapping.getControllerClass(), MockMacroController);
            // On each mapping, make sure the URL can be correctly resolved
            switch(urlMapping.getControllerMethodName()) {
                case "handleRequestA":
                    foundHandleRequestA = true;
                    testRequestInfo.setURI("/a/");
                    assertTrue(urlMapping.resolve(testRequestInfo.getURI()));
                case "handleRequestEregOptions":
                    handleRequestEregOptions = true;
                    testRequestInfo.setURI("/b/aoisuasinoi/");
                    assertTrue(urlMapping.resolve(testRequestInfo.getURI()));
                case "handleRequestPrefix":
                    handleRequestPrefix = true;
                    testRequestInfo.setURI("/MYPREFIX/b/asodhuiahiuh/");
                    assertTrue(urlMapping.resolve(testRequestInfo.getURI()));
                    testRequestInfo.setURI("/$prefix/b/asodhuiahiuh/");
                    assertFalse(urlMapping.resolve(testRequestInfo.getURI()));
                case "handleRequestNoPrefix":
                    handleRequestNoPrefix = true;
                    testRequestInfo.setURI("/b/jkandahjsbh/");
                    assertTrue(urlMapping.resolve(testRequestInfo.getURI()));
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

    /**
     * Tests the MacroConfigurator's createERegUrlMappingArray method
     */
    @Test
    private function testCreateURLMappingArray() {
        var mappings : Array<ERegURLMapping> =
                MacroConfigurator.createERegUrlMappingArray(MockMacroController, "URL", "MYPREFIX");

        assertEquals(mappings.length, MockMacroController.MAPPED_METHOD_COUNT);

        var methodsToFind : Array<String> = ["handleRequestA",
                                             "handleRequestEregOptions",
                                             "handleRequestPrefix",
                                             "handleRequestNoPrefix"];

        var testRequestInfo : RequestInfo = new RequestInfo();
        testRequestInfo.setMethod(Method.GET);

        // Make sure all mappings are all right
        for(mapping in mappings) {
            assertEquals(mapping.getControllerClass(), MockMacroController);
            assertTrue(methodsToFind.remove(mapping.getControllerMethodName()));

            switch(mapping.getControllerMethodName()) {
                case "handleRequestA":
                    testRequestInfo.setURI("/a/");
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));
                case "handleRequestEregOptions":
                    testRequestInfo.setURI("/b/aoisuasinoi/");
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));
                case "handleRequestPrefix":
                    testRequestInfo.setURI("/MYPREFIX/b/asodhuiahiuh/");
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));
                    testRequestInfo.setURI("/$prefix/b/asodhuiahiuh/");
                    assertFalse(mapping.resolve(testRequestInfo.getURI()));
                case "handleRequestNoPrefix":
                    testRequestInfo.setURI("/b/jkandahjsbh/");
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));
                default:
            }
        }

        assertEquals(methodsToFind.length, 0);

        var unprefixedMappings : Array<ERegURLMapping> =
                MacroConfigurator.createERegUrlMappingArray(MockMacroController, "URL");

        var testRequestInfo : RequestInfo = new RequestInfo();
        testRequestInfo.setMethod(Method.GET);

        for(mapping in unprefixedMappings) {
            switch(mapping.getControllerMethodName()) {
                case "handleRequestPrefix":
                    testRequestInfo.setURI("/MYPREFIX/b/asodhuiahiuh/");
                    assertFalse(mapping.resolve(testRequestInfo.getURI()));
                    testRequestInfo.setURI("/$prefix/b/asodhuiahiuh/");
                    assertFalse(mapping.resolve(testRequestInfo.getURI()));
                default:
            }
        }
    }

}