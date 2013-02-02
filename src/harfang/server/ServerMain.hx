// Harfang - A Web development framework
// Copyright (C) 2011-2012  Nicolas Juneau <n.juneau@gmail.com>
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
import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.exception.WrappedException;
import harfang.server.event.ServerEventListener;
import harfang.server.request.Method;
import harfang.server.request.RequestInfo;

import server.UserConfiguration;

/**
 * Program entry point
 */
class ServerMain {

    /**
     * Harfang's entry point - creates the user's configuration and launches the
     * server with it.
     */
    public static function main() : Void {
        // Load the configuration and start the application
        var requestInfo : RequestInfo = buildRequestInfo();
        launch(new UserConfiguration(), requestInfo);
    }

    /**
     * Launches the Harfang server (request processing, controller dispatching
     * and error detection)
     * @param requestInfo The request's information
     */
    public static function launch(userConfiguration : ServerConfiguration, requestInfo : RequestInfo) : Void {
        userConfiguration.init();
        var urlDispatcher : URLDispatcher = new URLDispatcher(userConfiguration);
        var serverEventListeners : Iterable<ServerEventListener> = userConfiguration.getServerEventListeners();

        try {
            // Dispatch the URL
            urlDispatcher.dispatch(requestInfo);
        } catch(he : HTTPException) {
            // Send HTTP error event to all listeners
            for(listener in serverEventListeners) {
                listener.onHTTPError(he);
            }
        } catch(e : Exception) {
            // Error does not lead to a 404 or 500 error and may need further
            // processing
            for(listener in serverEventListeners) {
                listener.onError(e);
            }
        } catch(e : String) {
            // Error is a string, may need further processing
            var stringException : Exception = new Exception(e);
            for(listener in serverEventListeners) {
                listener.onError(stringException);
            }
        } catch(e : Dynamic) {
            // Error is of unknown type. May need further processing
            var wrappedException : WrappedException = new WrappedException(e);
            for(listener in serverEventListeners) {
                listener.onError(wrappedException);
            }
        }

        // Close the application
        userConfiguration.onClose();
    }

    /**
     * Builds the request info object based on the server's information
     */
    private static function buildRequestInfo() : RequestInfo {
        var method : Method = null;
        var requestInfo : RequestInfo = new RequestInfo();

        // Determine request method
        var stringMethod = Web.getMethod();
        switch(stringMethod) {
            case "GET":
                method = Method.GET;
            case "PUT":
                method = Method.PUT;
            case "POST":
                method = Method.POST;
            case "DELETE":
                method = Method.DELETE;
            case "OPTIONS":
                method = Method.OPTIONS;
            default:
                method = Method.OTHER(stringMethod);
        }

        requestInfo.setMethod(method);
        requestInfo.setURI(Web.getURI());

        return requestInfo;
    }
}