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

package urlmappingfactory.mock;

import harfang.controller.Controller;
import harfang.request.RequestInfo;
import harfang.url.ResolutionResult;
import harfang.url.URLMapping;

/**
 * URL mapping for use with the MacroConfiguratorTest's custom URL mapping test
 */
class MockMacroURLMapping implements URLMapping {

    private var controller : Class<Controller>;
    private var methodName : String;
    private var paramA : String;
    private var paramB : String;

    /**
     * Creates the URL mapping
     * @param controller The controller that must be mapped
     * @param methodName The controller's function to map
     * @param paramA An optionnal parameter
     * @param paramB A second optional parameter
     */
    public function new(controller : Class<Controller>, methodName : String, ? paramA : String, ? paramB : String) {
        this.controller = controller;
        this.methodName = methodName;
        this.paramA = paramA;
        this.paramB = paramB;
    }

    public function resolve(requestInfo : RequestInfo) : ResolutionResult {
        return new ResolutionResult(true, new Array<String>());
    }

    public function getControllerClass() : Class<Controller> {
        return this.controller;
    }

    public function getControllerMethodName() : String {
        return this.methodName;
    }

    /**
     * Returns the first parameter that was sent to the constructor (may be null)
     */
    public function getParamA() : String {
        return this.paramA;
    }

    /**
     * Returns the second parameter that was sent to the constructor (may be null)
     */
    public function getParamB() : String {
        return this.paramB;
    }
}