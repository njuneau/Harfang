package server.test;

import hawk.server.AbstractModule;
import server.test.controllers.IndexController;
import server.test.controllers.ParameterController;

/**
 * Test demo application
 */
class Test extends AbstractModule {

    public function new() {
        super();

        this.addURLMapping(~/^\/hawk\/$/, IndexController, "handleARequest");
        this.addURLMapping(~/^\/hawk\/([a-zA-Z]+)\/$/, ParameterController, "handleARequest");
        this.addURLMapping(~/^\/hawk\/([a-zA-Z]+)\/([0-9]+)\/$/, ParameterController, "handleAnotherRequest");
    }
}