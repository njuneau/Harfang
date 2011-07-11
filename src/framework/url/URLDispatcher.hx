package framework.url;

import framework.Module;
import framework.mvc.Controller;
import framework.exceptions.FOFNotFoundException;
import framework.exceptions.FOFServerErrorException;
/**
 * This class handles the request made to your application
 */
class URLDispatcher {
    
    /*************************************/
    /*           PRIVATE FIELDS          */
    /*************************************/
    
    //The modules that this dispatcher handles
    private var modules:List<Module>;
    //The URL that is currently being processed
    private var currentURL:String;
    
    
    /**
     * Constructor
     * @param modules The modules you want this dispatcher to handle
     */
    public function new(modules:List<Module>) {
        this.modules = modules;
    }
    
    /*************************************/
    /*              BEHAVIOR             */
    /*************************************/
    
    /**
     * Dipatches the URL to the correct view
     * @param url The URL to process
     */
    public function dispatch(url:String):Void {
        this.currentURL = url;
        var dispatched:Bool = false;
        var moduleIterator:Iterator<Module> = this.modules.iterator();
        
        //Scan all the URLS
        while(!dispatched && moduleIterator.hasNext()) {
            dispatched = this.scanURLs(moduleIterator.next());
        }
        
        //If the URL could not have been dispatched, throw some kind of 404
        if(!dispatched) {
            throw new FOFNotFoundException();
        }
    }
    
    /*************************************/
    /*           PRIVATE METHODS         */
    /*************************************/
    
    /**
     * Try matching the URLS with one of the module's regexes.
     * @return Scan status (true if URL has been found, false otherwize)
     */
    private function scanURLs(module:Module):Bool {
        var foundURL = false;
        var mappingIterator:Iterator<URLMapping> = module.getURLMappings().iterator();
        var currentMapping:URLMapping = null;
        var controller:Controller = null;
        var controllerFunction:Dynamic = null;
        var controllerFunctionParams:Array<String> = null;
        
        //Try matching a pattern
        while(!foundURL && mappingIterator.hasNext()) {
            currentMapping = mappingIterator.next();
            //Try matching the URL
            foundURL = currentMapping.getURLReg().match(this.currentURL);
        }
        
        //Call the controller
        if(foundURL) {
            controller = Type.createInstance(currentMapping.getControllerClass(), []);
            controllerFunction = Reflect.field(controller, currentMapping.getControllerFunctionName());
            
            // Make the call with the correct parameters
            if(Reflect.isFunction(controllerFunction)) {
                Reflect.callMethod(
                        controller,
                        controllerFunction,
                        this.extractParameters(currentMapping)
                );
            } else {
                // Controller function was not found - error!
                throw new FOFServerErrorException();
            }
            
        }
        
        //Return the status of the search
        return foundURL;
    }
    
    /**
     * Extract the parameters tha the controller needs from the URL
     * @param urlMapping The URLMapping in which to extract the parameters
     */
    private function extractParameters(urlMapping:URLMapping):Array<String> {
        var parameters:Array<String> = new Array();
        var regEx:EReg = urlMapping.getURLReg();
        var counter:Int = 0;
        var parameter:String = regEx.matched(counter + 1);
        
        //Get trough all the groups and fill the needed parameters
        while(parameter != null) {
            parameters.push(parameter);
            counter++;
            parameter = regEx.matched(counter + 1);
        }
        
        return parameters;
    }
}