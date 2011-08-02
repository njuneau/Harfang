package hawk.url;

import hawk.server.Module;
import hawk.server.Controller;
import hawk.server.ServerConfiguration;
import hawk.exceptions.NotFoundException;
import hawk.exceptions.ServerErrorException;

/**
 * This class handles the request made to your application
 */
class URLDispatcher {

    /**************************************************************************/
    /*                             PRIVATE FIELDS                             */
    /**************************************************************************/

    // The server's configuration
    private var serverConfiguration : ServerConfiguration;
    //The modules that this dispatcher handles
    private var modules : Iterable<Module>;
    //The URL that is currently being processed
    private var currentURL : String;

    /**
     * Constructor
     * @param serverConfiguration The server's configuration
     * @param modules The modules you want this dispatcher to handle
     */
    public function new(serverConfiguration : ServerConfiguration) {
        this.serverConfiguration = serverConfiguration;
    }

    /**************************************************************************/
    /*                            PUBLIC METHODS                              */
    /**************************************************************************/

    /**
     * Dipatches the URL to the correct view
     * @param url The URL to process
     */
    public function dispatch(url:String) : Void {
        this.currentURL = url;
        var dispatched:Bool = false;
        var moduleIterator:Iterator<Module> = this.serverConfiguration.getModules().iterator();

        // Scan all the URLS
        while(!dispatched && moduleIterator.hasNext()) {
            dispatched = this.scanURLs(moduleIterator.next());
        }

        // If the URL could not have been dispatched, throw a 404 error
        if(!dispatched) {
            throw new NotFoundException();
        }
    }

    /**************************************************************************/
    /*                            PRIVATE METHODS                             */
    /**************************************************************************/

    /**
     * Try matching the URLS with one of the module's regexes.
     * @return Scan status (true if URL has been found, false otherwize)
     */
    private function scanURLs(module : Module) : Bool {
        var foundURL = false;
        var mappingIterator : Iterator<URLMapping> = module.getURLMappings().iterator();
        var currentMapping : URLMapping = null;
        var controller : Controller = null;
        var controllerFunction : Dynamic = null;
        var controllerFunctionParams : Array<String> = null;

        // Try matching a pattern
        while(!foundURL && mappingIterator.hasNext()) {
            currentMapping = mappingIterator.next();
            // Try matching the URL
            foundURL = currentMapping.getURLReg().match(this.currentURL);
        }

        // Call the controller
        if(foundURL) {
            // Call the dispatch event
            this.serverConfiguration.onDispatch(currentMapping);

            // Create the controller instance and find its function
            controller = Type.createInstance(currentMapping.getControllerClass(), [this.serverConfiguration]);
            controllerFunction = Reflect.field(controller, currentMapping.getControllerFunctionName());

            // Make the call with the correct parameters
            if(Reflect.isFunction(controllerFunction)) {
                // Handle request
                if(controller.handleRequest()) {
                    Reflect.callMethod(
                            controller,
                            controllerFunction,
                            this.extractParameters(currentMapping)
                    );
                }
            } else {
                // Controller function was not found - error!
                throw new ServerErrorException();
            }

        }

        // Return the status of the search
        return foundURL;
    }

    /**
     * Extract the parameters tha the controller needs from the URL
     * @param urlMapping The URLMapping in which to extract the parameters
     */
    private function extractParameters(urlMapping:URLMapping) : Array<String> {
        var parameters : Array<String> = new Array();
        var regEx : EReg = urlMapping.getURLReg();
        var counter : Int = 1;
        var parameter : String = null;

        // Get trough all the groups and fill the needed parameters
        do {
            parameter = regEx.matched(counter);
            parameters.push(parameter);
            counter++;
        } while(parameter != null);

        return parameters;
    }
}