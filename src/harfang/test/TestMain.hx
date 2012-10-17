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

package harfang.test;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#else
#error "Unsupported platform"
#end

import haxe.unit2.TestRunner;
import haxe.unit2.TestCase;
import haxe.unit2.output.OutputWriter;
import haxe.unit2.output.TextOutputWriter;
import haxe.unit2.output.XHTMLOutputWriter;

import harfang.test.macroconfigurator.MacroConfiguratorTest;
import harfang.test.urldispatcher.URLDispatcherTest;
import harfang.test.serverconfiguration.ServerConfigurationTest;
import harfang.test.servereventlistener.ServerEventListenerTest;

/**
 * This is Harfang's main test launcher. It will launch the unit tests.
 */
class TestMain {

    /**
     * Launch the tests
     */
    public static function main() : Void {
        var testRunner : TestRunner = new TestRunner();

        testRunner.add(MacroConfiguratorTest);
        testRunner.add(URLDispatcherTest);
        testRunner.add(ServerConfigurationTest);
        testRunner.add(ServerEventListenerTest);
        testRunner.run();

        #if php
        var testOutput : OutputWriter = new XHTMLOutputWriter();
        #else
        var testOutput : OutputWriter = new TextOutputWriter();
        #end

        Lib.print(testOutput.writeResults(testRunner));

    }

}