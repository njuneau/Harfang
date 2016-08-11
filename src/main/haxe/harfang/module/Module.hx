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

import harfang.url.URLMapping;

/**
 * A module consists of a list of URL mappings. Modules are the core of the
 * application. Typically, this is where models, views and controllers are
 * contained.
 *
 * Note that the framework does not perform collision checks on mappings. When
 * adding mappings, you have to be careful not to specify URL patterns that
 * collide to each other.
 */
interface Module {

    /**
     * Returns all the request mappings that belong to this module
     *
     * @return The request mappings that belong to this module
     */
    public function getMappings() : Iterable<URLMapping>;
}
