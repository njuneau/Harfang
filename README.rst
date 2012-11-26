Harfang Web framework
===============

Description
-----------------

Harfang is a lightweight Web development framework written in Haxe
(http://haxe.org), currently working for the PHP and Neko targets.

Documentation
-----------------

The framework's documentation can be found there :
http://haxe.org/com/libs/harfang. A tutorial to build your first application
with the framework is also available there :
http://haxe.org/com/libs/harfang/tutorials/quickstart/0.3

Running the unit tests
-----------------

Harfang cannot be "compiled" as a standalone application as it needs user
configuration to run. However, there are a couple of unit tests that tests
various components of the framework. These don't need user configuration.

You will need Unit2_ in order to run the tests. Copy Unit2's ``haxe.unit2``
package into Harfang's ``src`` folder prior to running the tests. Once Unit2 has
been included, run ``haxe test-neko.hxml`` or ``haxe test-php.hxml``
depending on your target platform.

Once the tests are compiled, you can run ``neko test.n`` inside the ``out``
folder to test the Neko target or copy the contents of ``out/phptest`` on a Web
server to test the PHP target. Test results should be printed out as simple text
in the terminal window or the browser, depending on the chosen platform.

Enjoy!


.. _Unit2: https://github.com/njuneau/Unit2