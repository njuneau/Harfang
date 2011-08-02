package hawk.server;

import hawk.url.URLMapping;

/**
 * Provides a default implementation for the Module interface - it provides
 * helper functions to manage the URL mappings without having you to worry
 * about how it's stored.
 */
class AbstractModule implements Module {

    private var urlMappings : List<URLMapping>;

    /**
     * Constructs a default implementation of a server module
     */
    public function new() {
        this.urlMappings = new List<URLMapping>();
    }

    /**
     * Returns all the URLs mapping that belongs to this module
     * @return A list of all the URL mappings contained in the module
     */
    public function getURLMappings() : Iterable<URLMapping> {
        return this.urlMappings;
    }

    /**
     * Adds a mapping into the module's list of URL mappings
     * @param urlReg The expression that matches the sent URL
     * @param controller The controller to call
     * @param controllerFunctionName The controller's function to call
     */
    private function addURLMapping(urlReg : EReg, controllerClass : Class<Controller>, controllerFunctionName : String) : Void {
        this.urlMappings.add(new URLMapping(urlReg, controllerClass, controllerFunctionName));
    }

}