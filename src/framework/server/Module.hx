package framework.server;

import framework.url.URLMapping;

/**
 * A module consist af a set of models, views and controllers. Modules are the
 * core of your Web site.
 */
interface Module {

    /**
     * Returns all the URLs mapping that belongs to this module
     * @return A list of all the URL mappings contained in the module
     */
    public function getURLMappings():List<URLMapping>;
}