package server;

import hawk.server.AbstractServerConfiguration;

import server.test.Test;

/**
 * This contains the user's configuration. Refer to the ServerConfiguration
 * interface to see the available methods
 */
class UserConfiguration extends AbstractServerConfiguration {

    /**
     * Constructor (initialize your parameters here)
     */
    public function new() {
        super();
        this.addModule(new Test());
    }

}