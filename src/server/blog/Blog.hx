package server.blog;

import framework.Module;
import framework.url.URLMapping;
import server.blog.controllers.IndexController;
import server.blog.controllers.ParameterController;

class Blog implements Module {

    /*************************************/
    /*           PRIVATE FIELDS          */
    /*************************************/

    private var urlMappings:List<URLMapping>;

    public function new() {
        this.urlMappings = new List<URLMapping>();

        this.urlMappings.add(
            new URLMapping(~/^\/hawk\/$/, IndexController, "handleARequest")
        );

        this.urlMappings.add(
            new URLMapping(~/^\/hawk\/([a-zA-Z]+)\/$/, ParameterController, "handleARequest")
        );

        this.urlMappings.add(
            new URLMapping(~/^\/hawk\/([a-zA-Z]+)\/([0-9]+)\/$/, ParameterController, "handleAnotherRequest")
        );
    }

    /*************************************/
    /*              BEHAVIOR             */
    /*************************************/

    public function getURLMappings():List<URLMapping> {
        return this.urlMappings;
    }
}