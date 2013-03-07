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

package harfang.test.urldispatcher.mock;

import harfang.module.AbstractModule;

/**
 * Module that is used to test the dispatcher's resolving and filtering.
 */
class MockURLDispatcherFilterModule extends AbstractModule {

    /**
     * Maps the module's controllers to URLs
     * @param resolve Result of the module's single mapping "resolve" method
     * @param filter Result of the module's single mapping "filter" method
     */
    public function new(resolve : Bool, filter : Bool) {
        super();
        this.urlMappings.add(new MockURLMapping(MockURLDispatcherController, "dispatchSimple", resolve, filter));
    }

}