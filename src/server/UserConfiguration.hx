package server;

import framework.server.ServerConfiguration;
import framework.server.Module;
import framework.url.URLMapping;
import framework.exceptions.Exception;

import server.blog.Blog;

/**
 * This contains the user's configuration - do it the way you want,
 * as long as you implement de needed methods, described in the interface.
 */
class UserConfiguration implements ServerConfiguration {

    /*************************************/
    /*           PRIVATE FIELDS          */
    /*************************************/

    //The list of modules of the server side of your application
    private var myModules:List<Module>;

    /**
     * Constructor (initialize your parameters here)
     */
    public function new() {
        this.myModules = new List<Module>();
        this.myModules.add(new Blog());
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
    public function getModules():List<Module> {
        return this.myModules;
    }

}