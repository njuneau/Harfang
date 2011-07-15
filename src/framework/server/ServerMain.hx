package framework.server;

import haxe.Resource;
import haxe.Template;
import php.Web;
import php.Lib;

import framework.server.ServerConfiguration;
import framework.url.URLDispatcher;
import framework.exceptions.Exception;
import framework.exceptions.HTTPException;

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
        } catch(he : HTTPException) {
            // Print the HTTP error using an HTML page
            var template : Template = new Template(Resource.getString(he.getTemplate()));
            userConfiguration.onError(he);
            Web.setReturnCode(he.getErrorCode());
            Lib.print(template.execute({errorCode:he.getErrorCode(), message:he.getMessage()}));
        } catch(e : Exception) {
            // This is not an HTTP exception - print it straight
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