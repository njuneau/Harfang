package hawk.url;

import hawk.server.Controller;

/**
 * A URL mapping consists of a binding between a controller and a URL. Whenever
 * the user enters a URL, the dispatcher must know where to forward the request.
 * This is the job of the URL mapping: binding an URL pattern with a controller.
 */
class URLMapping {

    /**************************************************************************/
    /*                             PRIVATE FIELDS                             */
    /**************************************************************************/

    //The regular expression that corresponds to the URL
    private var urlReg : EReg;
    //The controller class to instanciate if the URL is matched
    private var controllerClass : Class<Controller>;
    //The controller's function to call
    private var controllerFunctionName : String;

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Construct a new URL Mapping
     * @param urlReg The expression that matches the sent URL
     * @param controller The controller to call
     * @param controllerFunctionName The controller's function to call
     */
    public function new(urlReg : EReg, controllerClass : Class<Controller>, controllerFunctionName : String) {
        this.urlReg = urlReg;
        this.controllerClass = controllerClass;
        this.controllerFunctionName = controllerFunctionName;
    }

    /**************************************************************************/
    /*                                GETTERS                                 */
    /**************************************************************************/

    /**
     * Returns the URL regex contained in the mapping
     * @return The URL regex contained in the mapping
     */
    public function getURLReg() : EReg {
        return this.urlReg;
    }

    /**
     * Returns the controller contained in the mapping
     * @return The controller contained in the mapping
     */
    public function getControllerClass() : Class<Controller> {
        return this.controllerClass;
    }

    /**
     * Returns the controller's function to call's name
     * @return The controller's function to call's name
     */
    public function getControllerFunctionName() : String {
        return this.controllerFunctionName;
    }
}