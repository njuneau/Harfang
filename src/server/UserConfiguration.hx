package server;

import hawk.server.AbstractServerConfiguration;

import server.blog.Blog;

/**
 * This contains the user's configuration - do it the way you want,
 * as long as you implement de needed methods, described in the interface.
 */
class UserConfiguration extends AbstractServerConfiguration {

    /**
     * Constructor (initialize your parameters here)
     */
    public function new() {
        super();
        this.addModule(new Blog());
    }

}