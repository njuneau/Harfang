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

package harfang.test.macroconfigurator.mock;

import harfang.controller.AbstractController;

/**
 * This is a mock controller to test the behavior of the macro configurator
 */
class MockMacroController extends AbstractController {

    /**
     * Just initialise some diagnostic variables
     */
    public function new() {}

    /**
     * Macro configurator shoul map this method
     */
    @URL("^/a/$")
    public function handleRequestA() : Void {}

    /**
     * Macro configurator shoul also map this method and map the correct regex
     * option "g"
     */
    @URL("^/b/([a-zA-Z]+)/$", "g")
    public function handleRequestEregOptions(param : String) : Void {}

    /**
     * Macro configurator shoul also map this method, also mapping regex option
     * "g" and prefixing the URL in the correct place.
     */
    @URL("^/$prefix/b/([a-zA-Z]+)/$", "g", "$prefix")
    public function handleRequestPrefix(param : String) : Void {}

    /**
     * Macro configurator shoul also map this method, also mapping regex option
     * "g" and try to map the prefix without failing.
     */
    @URL("^/b/([a-zA-Z]+)/$", "", "$prefix")
    public function handleRequestNoPrefix(param : String) : Void {}

    /**
     * Macro configurator shouldn't map this method
     */
    public function doNotHandleA() : Void {}

    /**
     * Macro configurator shouldn't map this method either - make sure case
     * sensitivity is respected
     */
    @url("asdasoid")
    public function doNotHandleB() : Void {}
}