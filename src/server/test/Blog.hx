package server.blog;

import hawk.server.AbstractModule;
import server.blog.controllers.IndexController;
import server.blog.controllers.ParameterController;

class Blog extends AbstractModule {

    public function new() {
        super();

        this.addURLMapping(~/^\/hawk\/$/, IndexController, "handleARequest");
        this.addURLMapping(~/^\/hawk\/([a-zA-Z]+)\/$/, ParameterController, "handleARequest");
        this.addURLMapping(~/^\/hawk\/([a-zA-Z]+)\/([0-9]+)\/$/, ParameterController, "handleAnotherRequest");
    }
}