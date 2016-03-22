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

package urldispatcher.mock;

import harfang.controller.Controller;
import harfang.server.request.RequestInfo;
import harfang.url.ResolutionResult;
import harfang.url.URLMapping;

/**
 * This URL mapping is used to test if the dispatcher handles resolving and
 * filtering correctly
 */
class MockURLMapping implements URLMapping {

    private var controllerClass : Class<Controller>;

    private var methodName : String;

    private var resolveValue : Bool;

    private var filterValue : Bool;

    /**
     * Creates the mock URL mapping
     * @param controllerClass The controller class to map
     * @param methodName The name of the method to call on the controller
     * @param resolve The return value of the "resolve" method
     * @param filter The return value of the "filter" method
     */
    public function new(controllerClass : Class<Controller>, methodName : String, resolve : Bool, filter : Bool) {
        this.controllerClass = controllerClass;
        this.methodName = methodName;
        this.resolveValue = resolve;
        this.filterValue = filter;
    }

    public function resolve(requestInfo : RequestInfo) : ResolutionResult {
        return new ResolutionResult(this.resolveValue && this.filterValue, new Array<String>());
    }

    public function getControllerClass() : Class<Controller> {
        return this.controllerClass;
    }

    public function getControllerMethodName() : String {
        return this.methodName;
    }

}