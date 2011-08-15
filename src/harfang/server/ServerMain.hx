// Harfang - A Web development framework
// Copyright (C) 2011  Nicolas Juneau <n.juneau@gmail.com>
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

#if php
import php.Web;
#elseif neko
import neko.Web;
#else
#error "Unsupported platform"
#end

import harfang.configuration.ServerConfiguration;
import harfang.url.URLDispatcher;
import harfang.exceptions.Exception;
import harfang.exceptions.HTTPException;

import server.UserConfiguration;

/**
 * Program entry point
 * The configuration is loaded here
 * The request is processed here
 */
class ServerMain {

    /**
     * Program's entry point, starts up pretty much everything and handles
     * the recieved request.
     */
    public static function main() : Void {
        // Load the configuration
        var userConfiguration : UserConfiguration = new UserConfiguration();

        var urlDispatcher : URLDispatcher = new URLDispatcher(userConfiguration);
        var url:String = appendSlash(Web.getURI());

        try {
            // Dispatch the URL
            urlDispatcher.dispatch(url);
        } catch(he : HTTPException) {
            // Send HTTP error event
            userConfiguration.onHTTPError(he);
        } catch(e : Exception) {
            // Error does not lead to a 404 or 500 error and may need further
            // processing
            userConfiguration.onError(e);
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