package framework.mvc;

/**
 * A controller handles requests from the client
 */
class Controller {

    /**
     * Handles the HTTP request - called when the URL dispatcher calls the
     * controller
     */
    public function handleRequest() : Bool {
        return true;
    }

}