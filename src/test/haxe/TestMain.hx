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

package ;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#else
#error "Unsupported platform"
#end

import unit2.TestRunner;
import unit2.TestCase;
import unit2.output.OutputWriter;
import unit2.output.TextOutputWriter;
import unit2.output.XHTMLOutputWriter;

import urlmappingfactory.URLMappingFactoryTest;
import urldispatcher.RequestInfoTest;
import urldispatcher.URLDispatcherTest;
import serverconfiguration.ServerConfigurationTest;
import servereventlistener.ServerEventListenerTest;

/**
 * This is Harfang's main test launcher. It will launch the unit tests.
 */
class TestMain {

    /**
     * Launch the tests
     */
    public static function main() : Void {
        var testRunner : TestRunner = new TestRunner();

        testRunner.add(URLMappingFactoryTest);
        testRunner.add(RequestInfoTest);
        testRunner.add(URLDispatcherTest);
        testRunner.add(ServerConfigurationTest);
        testRunner.add(ServerEventListenerTest);
        testRunner.run();

        var testOutput : OutputWriter = new TextOutputWriter();
        Lib.print(testOutput.writeResults(testRunner));

    }

}