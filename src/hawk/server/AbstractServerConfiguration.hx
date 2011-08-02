package hawk.server;

import hawk.url.URLMapping;
import hawk.exceptions.Exception;

/**
 * Provides a default implementation for the ServerConfiguration interface,
 * providing helper functions so you don't have to worry about how the data
 * is contained behind the scenes.
 */
class AbstractServerConfiguration implements ServerConfiguration {

    /*************************************/
    /*           PRIVATE FIELDS          */
    /*************************************/

    //The list of modules of the server side of your application
    private var modules:List<Module>;

    /**
     * Constructs a default implementation of the server configuration
     */
    public function new() {
        this.modules = new List<Module>();
    }

    /*************************************/
    /*            PUBLIC METHODS         */
    /*************************************/

    /**
     * Dispatch event - called when the queried URL corresponds to a controller
     * (the URL has been dispatched). Call done before the controller is called
     *
     * @param urlMapping The URL mapping that was matched
     */
    public function onDispatch(urlMapping : URLMapping) : Void {}

    /**
     * Error event - called when the server encounters an error during URL
     * dispatching or controller operations
     *
     * @param exception The exception that was thrown
     */
    public function onError(exception : Exception) : Void {}

    /**
     * Close event - called when the server closes
     */
    public function onClose() : Void {}

    /*************************************/
    /*              GETTERS              */
    /*************************************/

    /**
     * Returns the modules contained in the application
     * @return The modules contained in the application
     */
    public function getModules():Iterable<Module> {
        return this.modules;
    }

    /*************************************/
    /*            PRIVATE METHODS        */
    /*************************************/

    /**
     * Adds a server module in the configuration's list of modules
     * @param module The module to add in the list
     */
    private function addModule(module : Module) {
        this.modules.add(module);
    }
}