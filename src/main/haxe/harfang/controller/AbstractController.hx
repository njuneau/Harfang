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

package harfang.controller;

import harfang.module.Module;
import harfang.request.RequestInfo;
import harfang.url.URLMapping;

/**
 * Provides a default implementation for the Controller interface. In this
 * implementation, the init method memorises the controller's belonging module,
 * beforeRequest always return true (always providing access to mapped
 * controller methods) and afterRequest does nothing.
 *
 * Refer to the Controller interface for more details.
 */
class AbstractController implements Controller {

    private var module : Module;
    private var requestInfo : RequestInfo;

    public function init(module : Module) : Void {
        this.module = module;
    }

    public function beforeRequest(urlMapping : URLMapping, requestInfo : RequestInfo) : Bool {
        return true;
    }

    public function afterRequest(urlMapping : URLMapping, requestInfo : RequestInfo) : Void {}

    /**
     * Returns the module that owns this controller
     * @return The module that owns this controller
     */
    private function getModule() : Module {
        return this.module;
    }

}
