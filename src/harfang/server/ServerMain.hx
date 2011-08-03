// Harfang - A Web development framework
// Copyright (C) 2011  Nicolas Juneau
// Full copyright notice can be found in the project root's "COPYRIGHT" file
//
// This file is part of Harfang.
//
// Harfang is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Harfang is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Harfang.  If not, see <http://www.gnu.org/licenses/>.

package harfang.server;

import php.Web;
import php.Lib;

import haxe.Template;
import haxe.Resource;

import harfang.server.ServerConfiguration;
import harfang.url.URLDispatcher;
import harfang.exceptions.Exception;
import harfang.exceptions.HTTPException;

import server.UserConfiguration;

/**
 * Program entry point
 * The configuration is loaded here
 * The request is recieved here
 */
class ServerMain {

    // This contains the user's server-side configuration
    private static var userConfiguration : ServerConfiguration;
    // Our URL dispatcher
    private static var urlDispatcher : URLDispatcher;

    /**
     * Program's entry point, starts up pretty much everything and handles
     * the recieved request.
     */
    public static function main() : Void {
        // Load the configuration
        userConfiguration = new UserConfiguration();

        var url:String = appendSlash(Web.getURI());
        urlDispatcher = new URLDispatcher(userConfiguration);

        try {
            // Dispatch the URL
            urlDispatcher.dispatch(url);
        } catch(he : HTTPException) {
            // Send error event
            userConfiguration.onError(he);
            // Print the HTTP error using an HTML page
            Web.setReturnCode(he.getErrorCode());
            var template : Template = new Template(Resource.getString(he.getTemplate()));
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
    private static function appendSlash(url : String) : String {

        if(url.charAt(url.length - 1) != "/") {
            url += "/";
        }

        return url;
    }
}