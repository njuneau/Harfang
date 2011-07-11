package framework.server;

import php.db.Connection;
import framework.server.Module;
import framework.url.URLMapping;
import framework.exceptions.Exception;

/**
 * The configuration specifies pretty much everything that the framework needs
 * to work. It is a singleton class.
 */
interface ServerConfiguration {

    /**
     * Returns the modules contained in the application
     * @return The modules contained in the application
     */
    public function getModules() : List<Module>;

    /**
     * Dispatch event - called when the queried URL corresponds to a controller
     * (the URL has been dispatched). Call done before the controller is called
     *
     * @param urlMapping The URL mapping that was matched
     */
    public function onDispatch(urlMapping : URLMapping) : Void;

    /**
     * Error event - called when the server encounters an error during URL
     * dispatching or controller operations
     *
     * @param exception The exception that was thrown
     */
    public function onError(exception : Exception) : Void;

    /**
     * Close event - called when the server closes
     */
    public function onClose() : Void;

}