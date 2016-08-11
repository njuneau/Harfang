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

package harfang.module;

import harfang.controller.Controller;
import harfang.url.URLMapping;
import harfang.url.ERegURLMapping;

/**
 * Provides a default implementation for the Module interface. It provides
 * helper functions to manage the URL mappings without having you to worry
 * about how they are stored.
 */
class AbstractModule implements Module {

    private var mappings : List<URLMapping>;

    /**
     * Constructs a default implementation of a server module
     */
    public function new() {
        this.mappings = new List<URLMapping>();
    }

    public function getMappings() : Iterable<URLMapping> {
        return this.mappings;
    }

    /**
     * Adds a URLMapping instance into the module's list of URL mappings
     *
     * @param urlMapping The URLMapping to add
     */
    private function addURLMapping(urlMapping : URLMapping) : Void {
        this.mappings.add(urlMapping);
    }

    /**
     * Adds a ERegURLMapping into the module's list of URL mappings
     *
     * @param pattern The regular expression to match against an URL
     * @param patternOptions The regular expression's options
     * @param controllerClass The controller to call
     * @param controllerFunctionName The name of the controller method to call
     * @param httpMethod Optional, the HTTP method that the request must have for
                         the mapping resolve the request
     */
    private function addERegURLMapping(pattern : String, patternOptions : String, controllerClass : Class<Controller>, controllerFunctionName : String, ? httpMethod : String) : Void {
        this.mappings.add(new ERegURLMapping(pattern, patternOptions, controllerClass, controllerFunctionName, httpMethod));
    }

}
