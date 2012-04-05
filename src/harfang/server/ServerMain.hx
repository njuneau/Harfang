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
     * Harfang's entry point - creates the user's configuration and launches the
     * server with it.
     */
    public static function main() : Void {
        // Load the configuration and start the application
        launch(new UserConfiguration(), Web.getURI());
    }

    /**
     * Launches the Harfang server (request processing, controller dispatching
     * and error detection)
     * @param userConfiguration The configuration to use in the server
     * @param uri The URI that has been requested
     */
    public static function launch(userConfiguration : ServerConfiguration, uri : String) : Void {
        var urlDispatcher : URLDispatcher = new URLDispatcher(userConfiguration);

        try {
            // Dispatch the URL
            urlDispatcher.dispatch(uri);
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
}