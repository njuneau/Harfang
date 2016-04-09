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

package urlmappingfactory;

import unit2.TestCase;

import harfang.request.RequestInfo;
import harfang.url.ERegURLMappingFactory;
import harfang.url.URLMappingFactory;
import harfang.url.ERegURLMapping;

import urlmappingfactory.mock.MockMacroModule;
import urlmappingfactory.mock.MockMacroController;
import urlmappingfactory.mock.MockMacroControllerCustom;
import urlmappingfactory.mock.MockMacroURLMapping;

/**
 * This is the URL mapping factory test case
 */
class URLMappingFactoryTest extends TestCase {

    /**
     * Test the URL mapping facotry's map method
     */
    @Test
    public function testMapController() : Void {
        var module : MockMacroModule = new MockMacroModule();

        var foundHandleRequestA : Bool = false;
        var handleRequestEregOptions : Bool = false;
        var handleRequestPrefix : Bool = false;
        var handleRequestNoPrefix : Bool = false;
        var handleRequestPostOnly : Bool = false;
        var doNotHandle : Bool = false;
        var httpMethod : String = "GET";

        var testRequestInfo : RequestInfo = null;

        for(urlMapping in module.getMappings()) {
            assertEquals(urlMapping.getControllerClass(), MockMacroController);
            // On each mapping, make sure the URL can be correctly resolved
            switch(urlMapping.getControllerMethodName()) {
                case "handleRequestA":
                    foundHandleRequestA = true;
                    testRequestInfo = new RequestInfo("/a/", httpMethod);
                    assertTrue(urlMapping.resolve(testRequestInfo).isResolved());
                case "handleRequestEregOptions":
                    handleRequestEregOptions = true;
                    testRequestInfo = new RequestInfo("/b/aoisuasinoi/", httpMethod);
                    assertTrue(urlMapping.resolve(testRequestInfo).isResolved());
                case "handleRequestPrefix":
                    handleRequestPrefix = true;
                    testRequestInfo = new RequestInfo("/MYPREFIX/b/asodhuiahiuh/", httpMethod);
                    assertTrue(urlMapping.resolve(testRequestInfo).isResolved());

                    testRequestInfo = new RequestInfo("/$prefix/b/asodhuiahiuh/", httpMethod);
                    assertFalse(urlMapping.resolve(testRequestInfo).isResolved());
                case "handleRequestNoPrefix":
                    handleRequestNoPrefix = true;
                    testRequestInfo = new RequestInfo("/b/jkandahjsbh/", httpMethod);
                    assertTrue(urlMapping.resolve(testRequestInfo).isResolved());
                case "handleRequestPostOnly":
                    handleRequestPostOnly = true;
                    testRequestInfo = new RequestInfo("/c/MYPREFIX/", httpMethod);
                    assertFalse(urlMapping.resolve(testRequestInfo).isResolved());

                    testRequestInfo = new RequestInfo("/c/MYPREFIX/", "post");
                    assertTrue(urlMapping.resolve(testRequestInfo).isResolved());
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
        assertTrue(handleRequestPostOnly);
        assertFalse(doNotHandle);

        module.getMappings();
    }

    /**
     * Tests the URL mapping factory's createERegUrlMappingArray method
     */
    @Test
    private function testCreateERegURLMappingArray() {
        var mappings : Array<ERegURLMapping> =
                ERegURLMappingFactory.createHttpMappingArray(MockMacroController, "URL", "Method", "MYPREFIX");

        assertEquals(mappings.length, MockMacroController.MAPPED_METHOD_COUNT);

        var methodsToFind : Array<String> = ["handleRequestA",
                                             "handleRequestEregOptions",
                                             "handleRequestPrefix",
                                             "handleRequestNoPrefix",
                                             "handleRequestPostOnly"];
        var httpMethod : String = "GET";
        var testRequestInfo : RequestInfo = null;

        // Make sure all mappings are all right
        for(mapping in mappings) {
            assertEquals(mapping.getControllerClass(), MockMacroController);
            assertTrue(methodsToFind.remove(mapping.getControllerMethodName()));

            switch(mapping.getControllerMethodName()) {
                case "handleRequestA":
                    testRequestInfo = new RequestInfo("/a/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo).isResolved());
                case "handleRequestEregOptions":
                    testRequestInfo = new RequestInfo("/b/aoisuasinoi/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo).isResolved());
                case "handleRequestPrefix":
                    testRequestInfo = new RequestInfo("/MYPREFIX/b/asodhuiahiuh/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo).isResolved());

                    testRequestInfo = new RequestInfo("/$prefix/b/asodhuiahiuh/", httpMethod);
                    assertFalse(mapping.resolve(testRequestInfo).isResolved());
                case "handleRequestNoPrefix":
                    testRequestInfo = new RequestInfo("/b/jkandahjsbh/", httpMethod);
                    assertTrue(mapping.resolve(testRequestInfo).isResolved());
                case "handleRequestPostOnly":
                    testRequestInfo = new RequestInfo("/c/MYPREFIX/", httpMethod);
                    assertFalse(mapping.resolve(testRequestInfo).isResolved());

                    testRequestInfo = new RequestInfo("/c/MYPREFIX/", "POST");
                    assertTrue(mapping.resolve(testRequestInfo).isResolved());
                default:
            }
        }

        assertEquals(methodsToFind.length, 0);

        var unprefixedMappings : Array<ERegURLMapping> =
                ERegURLMappingFactory.createHttpMappingArray(MockMacroController, "URL");

        var httpMethod : String = "GET";
        var testRequestInfo : RequestInfo = null;

        for(mapping in unprefixedMappings) {
            switch(mapping.getControllerMethodName()) {
                case "handleRequestPrefix":
                    testRequestInfo = new RequestInfo("/MYPREFIX/b/asodhuiahiuh/", httpMethod);
                    assertFalse(mapping.resolve(testRequestInfo).isResolved());

                    testRequestInfo = new RequestInfo("/$prefix/b/asodhuiahiuh/", httpMethod);
                    assertFalse(mapping.resolve(testRequestInfo).isResolved());
                default:
            }
        }
    }

    /**
     * Tests the URL mapping factory's createURLMappingArray method
     */
    @Test
    private function testCreateURLMappingArray() {
        var mappings : Array<MockMacroURLMapping> = URLMappingFactory.createMappingArray(
            MockMacroURLMapping,
            MockMacroControllerCustom,
            "Custom"
        );
        var mappingCount : Int = 0;

        for(mapping in mappings) {
            this.assertEquals(Type.getClass(mapping), MockMacroURLMapping);
            this.assertEquals(mapping.getControllerClass(), MockMacroControllerCustom);

            switch(mapping.getControllerMethodName()) {
                case "handleRequestA":
                    if(mapping.getParamA() == null && mapping.getParamB() == null) {
                        mappingCount++;
                    }
                case "handleRequestB":
                    if(mapping.getParamA() == "abc" && mapping.getParamB() == null) {
                        mappingCount++;
                    }
                case "handleRequestC":
                    if(mapping.getParamA() == "abc" && mapping.getParamB() == "def") {
                        mappingCount++;
                    }
                default:
                    throw "Unknown method";
            }
        }

        this.assertEquals(mappingCount, MockMacroControllerCustom.MAPPING_COUNT);
    }

}