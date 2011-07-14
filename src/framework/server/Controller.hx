package framework.server;

/**
 * A controller handles requests from the client
 */
class Controller {

    private var configuration : ServerConfiguration;

    /**
     * Constructs a new controller
     * @param configuration The server configuration
     */
    public function new(configuration : ServerConfiguration) {
        this.configuration = configuration;
    }

    /**
     * Returns the server configuration
     * @return The server configuration
     */
    private function getConfiguration() : ServerConfiguration {
        return this.configuration;
    }

    /**
     * Handles the HTTP request - called when the URL dispatcher calls the
     * controller
     */
    public function handleRequest() : Bool {
        return true;
    }

}