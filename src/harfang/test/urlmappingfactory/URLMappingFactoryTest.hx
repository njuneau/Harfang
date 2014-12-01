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

package harfang.test.urlmappingfactory;

import unit2.TestCase;

import harfang.url.URLMappingFactory;
import harfang.server.request.RequestInfo;
import harfang.url.ERegURLMapping;

import harfang.test.urlmappingfactory.mock.MockMacroModule;
import harfang.test.urlmappingfactory.mock.MockMacroController;
import harfang.test.urlmappingfactory.mock.MockMacroControllerCustom;
import harfang.test.urlmappingfactory.mock.MockMacroURLMapping;

/**
 * This is the URLMappingFactory test case
 */
class URLMappingFactoryTest extends TestCase {

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
        var httpMethod : String = "GET";

        var testRequestInfo : RequestInfo = null;

        for(urlMapping in module.getURLMappings()) {
            assertEquals(urlMapping.getControllerClass(), MockMacroController);
            // On each mapping, make sure the URL can be correctly resolved
            switch(urlMapping.getControllerMethodName()) {
                case "handleRequestA":
                    foundHandleRequestA = true;
                    testRequestInfo = new RequestInfo("/a/", httpMethod);
                    assertTrue(urlMapping.resolve(testRequestInfo.getURI()));
                case "handleRequestEregOptions":
                    handleRequestEregOptions = true;
                    testRequestInfo = new RequestInfo("/b/aoisuasinoi/", httpMethod);
                    assertTrue(urlMapping.resolve(testRequestInfo.getURI()));
                case "handleRequestPrefix":
                    handleRequestPrefix = true;
                    testRequestInfo = new RequestInfo("/MYPREFIX/b/asodhuiahiuh/", httpMethod);
                    assertTrue(urlMapping.resolve(testRequestInfo.getURI()));

                    testRequestInfo = new RequestInfo("/$prefix/b/asodhuiahiuh/", httpMethod);
                    assertFalse(urlMapping.resolve(testRequestInfo.getURI()));
                case "handleRequestNoPrefix":
                    handleRequestNoPrefix = true;
                    testRequestInfo = new RequestInfo("/b/jkandahjsbh/", httpMethod);
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
    private function testCreateERegURLMappingArray() {
        var mappings : Array<ERegURLMapping> =
                URLMappingFactory.createERegUrlMappingArray(MockMacroController, "URL", "MYPREFIX");

        assertEquals(mappings.length, MockMacroController.MAPPED_METHOD_COUNT);

        var methodsToFind : Array<String> = ["handleRequestA",
                                             "handleRequestEregOptions",
                                             "handleRequestPrefix",
                                             "handleRequestNoPrefix"];
        var httpMethod : String = "GET";
        var testRequestInfo : RequestInfo = null;

        // Make sure all mappings are all right
        for(mapping in mappings) {
            assertEquals(mapping.getControllerClass(), MockMacroController);
            assertTrue(methodsToFind.remove(mapping.getControllerMethodName()));

            switch(mapping.getControllerMethodName()) {
                case "handleRequestA":
                    testRequestInfo = new RequestInfo("/a/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));
                case "handleRequestEregOptions":
                    testRequestInfo = new RequestInfo("/b/aoisuasinoi/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));
                case "handleRequestPrefix":
                    testRequestInfo = new RequestInfo("/MYPREFIX/b/asodhuiahiuh/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));

                    testRequestInfo = new RequestInfo("/$prefix/b/asodhuiahiuh/", httpMethod);
                    assertFalse(mapping.resolve(testRequestInfo.getURI()));
                case "handleRequestNoPrefix":
                    testRequestInfo = new RequestInfo("/b/jkandahjsbh/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo.getURI()));
                default:
            }
        }

        assertEquals(methodsToFind.length, 0);

        var unprefixedMappings : Array<ERegURLMapping> =
                URLMappingFactory.createERegUrlMappingArray(MockMacroController, "URL");

        var httpMethod : String = "GET";
        var testRequestInfo : RequestInfo = null;

        for(mapping in unprefixedMappings) {
            switch(mapping.getControllerMethodName()) {
                case "handleRequestPrefix":
                    testRequestInfo = new RequestInfo("/MYPREFIX/b/asodhuiahiuh/", httpMethod);
                    assertFalse(mapping.resolve(testRequestInfo.getURI()));

                    testRequestInfo = new RequestInfo("/$prefix/b/asodhuiahiuh/", httpMethod);
                    assertFalse(mapping.resolve(testRequestInfo.getURI()));
                default:
            }
        }
    }

    /**
     * Tests the MacroConfigurator's createERegUrlMappingArray method
     */
    @Test
    private function testCreateURLMappingArray() {
        var mappings : Array<MockMacroURLMapping> = URLMappingFactory.createUrlMappingArray(MockMacroControllerCustom, "Custom");
        var mappingCount : Int = 0;

        for(mapping in mappings) {
            this.assertEquals(Type.getClass(mapping), MockMacroURLMapping);
            if(mapping.getControllerClass() == MockMacroControllerCustom) {
                switch(mapping.getControllerMethodName()) {
                    case "handleRequestA":
                        if(mapping.getParam() == null) {
                            mappingCount++;
                        }
                    case "handleRequestB":
                        if(mapping.getParam() == "abc") {
                            mappingCount++;
                        }
                }
            }
        }

        this.assertEquals(mappingCount, MockMacroControllerCustom.MAPPING_COUNT);
    }

}