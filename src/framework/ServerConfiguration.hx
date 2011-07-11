package framework;

import php.db.Connection;
import framework.Module;

/**
 * The configuration specifies pretty much everything that the framework needs
 * to work. It is a singleton class.
 */
class ServerConfiguration {
    
    private function new();
    
    /**
     * Returns the unique instance of the configuration
     * @return The unique instance of the configuration
     */
    public static function getInstance():ServerConfiguration {
        throw "Configuration instance getter not set!";
        return null;
    }
    
    /**
     * Returns the database connexion (can be null)
     * @return The database connexion
     */
    public function getConnection():Connection {
        throw "Connection getter not set!";
        return null;
    }
    
    /**
     * Returns the modules contained in the application
     * @return The modules contained in the application
     */
    public function getModules():List<Module> {
        throw "Modules getter not set!";
        return null;
    }
}