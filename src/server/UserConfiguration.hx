package server;

import framework.ServerConfiguration;
import framework.Module;
import server.blog.Blog;
import php.db.Connection;
import php.db.Mysql;

/**
 * This contains the user's configuration - do it the way you want,
 * as long as you implement de needed methods, described in the interface.
 */
class UserConfiguration extends ServerConfiguration {
    
    /*************************************/
    /*            STATIC FIELDS          */
    /*************************************/
    
    private static var MY_INSTANCE:UserConfiguration = null;
    
    /*************************************/
    /*           PRIVATE FIELDS          */
    /*************************************/
    
    //The database connection
    private var myConnection:Connection;
    //The list of modules of the server side of your application
    private var myModules:List<Module>;
    
    /**
     * Constructor (initialize your parameters here)
     */
    private function new() {
        super();
        this.myConnection = null;
        this.myModules = new List<Module>();
        this.myModules.add(new Blog());
    }
    
    /*************************************/
    /*              GETTERS              */
    /*************************************/
    
    /**
     * Returns the database connexion (can be null)
     * @return The database connexion
     */
    public override function getConnection():Connection {
        return this.myConnection;
    }
    
    /**
     * Returns the modules contained in the application
     * @return The modules contained in the application
     */
    public override function getModules():List<Module> {
        return this.myModules;
    }
    
    /**
     * Returns the unique instance of the configuration
     * @return The unique instance of the configuration
     */
    public static function getInstance():ServerConfiguration {
        if(MY_INSTANCE == null) {
            MY_INSTANCE = new UserConfiguration();
        }
        
        return MY_INSTANCE;
    }
    
}