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

package harfang.module;

import harfang.controller.Controller;
import harfang.url.URLMapping;
import harfang.url.ERegURLMapping;

/**
 * Provides a default implementation for the Module interface - it provides
 * helper functions to manage the URL mappings without having you to worry
 * about how it's stored.
 */
class AbstractModule implements Module {

    private var urlMappings : List<URLMapping>;

    /**
     * Constructs a default implementation of a server module
     */
    public function new() {
        this.urlMappings = new List<URLMapping>();
    }

    /**
     * Returns all the URLs mapping that belongs to this module
     * @return A list of all the URL mappings contained in the module
     */
    public function getURLMappings() : Iterable<URLMapping> {
        return this.urlMappings;
    }

    /**
     * Adds a mapping into the module's list of URL mappings
     * @param urlReg The expression that matches the sent URL
     * @param controller The controller to call
     * @param controllerFunctionName The controller's function to call
     */
    private function addURLMapping(urlReg : EReg, controllerClass : Class<Controller>, controllerFunctionName : String) : Void {
        this.urlMappings.add(new ERegURLMapping(urlReg, controllerClass, controllerFunctionName));
    }

}