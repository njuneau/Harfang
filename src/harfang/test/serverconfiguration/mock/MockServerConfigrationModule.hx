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

package harfang.test.serverconfiguration.mock;

import harfang.module.AbstractModule;

/**
 * Mock module that goes with the server configuration mock
 */
class MockServerConfigrationModule extends AbstractModule {

    /**
     * Creates the mock module
     */
    public function new() {
        super();
        this.addURLMapping(~/^\/$/, MockServerConfigurationController, "handleNormal");
        this.addURLMapping(~/^\/error\/$/, MockServerConfigurationController, "handleServerError");
        this.addURLMapping(~/^\/303\/$/, MockServerConfigurationController, "handleHTTPError");
    }

}