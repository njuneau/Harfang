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

package harfang.controller;

import harfang.module.Module;

/**
 * Provides a default implementation for the Controller interface. In this
 * implementation, the init method memorises the controller's belonging module,
 * handleRequest always return true (always providing access to mapped
 * controller methods) and handlePostRequest does nothing.
 *
 * Refer to the Controller interface for more details.
 */
class AbstractController implements Controller {

    private var module : Module;

    /**
     * Called by the URL dispatcher, just after constructing the controller.
     * Use this method to permorm initialisation mechanics.
     *
     * @param module The module that owns that controller
     */
    public function init(module : Module) : Void {
        this.module = module;
    }

    /**
     * Handles the HTTP request - called just before the URL dipstacher
     * calls the mapped controller function.
     *
     * @param controllerMethodName The name of the method that will be called
     * in the controller
     * @return This implementation of handleRequest will always return true,
     * thus allowing access to all the mapped controller methods.
     */
    public function handleRequest(controllerMethodName : String) : Bool {
        return true;
    }

    /**
     * This is called after the mapped controller method has been called.
     *
     * This particular implementation does nothing.
     *
     * @param controllerMethodName The name of the method that was was called
     * in the controller
     */
    public function handlePostRequest(controllerMethodName : String) : Void {}

    /**
     * Returns the module that owns this controller
     * @return The module that owns this controller
     */
    private function getModule() : Module {
        return this.module;
    }

}