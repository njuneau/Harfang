Harfang Web framework
=====================

Description
-----------

Harfang is a lightweight Web development framework written in Haxe
(http://haxe.org), currently working for the PHP and Neko targets.

Documentation
-------------

* Framework documentation_
* Building your first application tutorial_

Running the unit tests
----------------------

You will need Unit2_ in order to run the tests.

Compile and run the unit tests using the following instructions.

For the Neko target:

.. code:: sh

    haxe test-neko.hxml
    cd out
    neko test.n

For the PHP target:

.. code:: sh

    haxe test-php.hxml
    cd out/phptest
    php index.php

Enjoy!

.. _Unit2: https://github.com/njuneau/Unit2
.. _documentation: http://haxe.org/com/libs/harfang
.. _tutorial: http://haxe.org/com/libs/harfang/tutorials/quickstart/0.3
