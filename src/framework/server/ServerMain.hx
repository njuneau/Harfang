package framework.server;

import php.Web;
import php.Lib;
import framework.server.ServerConfiguration;
import framework.url.URLDispatcher;
import framework.exceptions.Exception;
import server.UserConfiguration;

/**
 * Program entry point
 * The configuration is loaded here
 * The request is recieved here
 */
class ServerMain {

    //This contains the user's server-side configuration
    private static var userConfiguration:ServerConfiguration;
    //Our URL dispatcher
    private static var urlDispatcher:URLDispatcher;

    /**
     * Program's entry point, starts up pretty much everything and handles
     * the recieved request.
     */
    public static function main() {
        // Load the configuration
        userConfiguration = new UserConfiguration();

        // Dispatch the URL
        var url:String = appendSlash(Web.getURI());
        urlDispatcher = new URLDispatcher(userConfiguration);

        // Check for errors
        try {
            urlDispatcher.dispatch(url);
        } catch(e:Exception) {
            userConfiguration.onError(e);
            Lib.print(e.getMessage());
        }

        // Close the application
        userConfiguration.onClose();
    }

    /**
     * Appends a slash to the URL if it doesn't have one at the end.
     * It won't appear in browsers, but it will simplify the regular expressions
     * a lot.
     *
     * @param url The url in which to append the slash
     * @return The url, with the trailing slash
     */
    private static function appendSlash(url:String):String {

        if(url.charAt(url.length - 1) != "/") {
            url += "/";
        }

        return url;
    }
}