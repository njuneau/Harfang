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

package harfang.test.macroconfigurator.mock;

import harfang.controller.AbstractController;

/**
 * Mock macro controller to test custom URL mappings
 */
class MockMacroControllerCustom extends AbstractController {

    /**
     * Number of mappings that must be extracted from this class
     */
    public static var MAPPING_COUNT :Int = 2;

    /**
     * Just initialise some diagnostic variables
     */
    public function new() {}

    /**
     * Macro configurator should map this method with the given URLMapping implementation
     */
    @Custom("harfang.test.macroconfigurator.mock.MockMacroURLMapping")
    public function handleRequestA() : Void {}

    /**
     * Macro configurator should map this method with the given URLMapping implementation
     */
    @Custom("harfang.test.macroconfigurator.mock.MockMacroURLMapping", "abc")
    public function handleRequestB() : Void {}

}