// Harfang - A Web development framework
// Copyright (C) 2011-2013  Nicolas Juneau <n.juneau@gmail.com>
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

import haxe.macro.Expr;
import haxe.macro.Context;

import harfang.configuration.ServerConfiguration;
import harfang.url.URLDispatcher;
import harfang.exception.Exception;
import harfang.exception.HTTPException;
import harfang.exception.WrappedException;
import harfang.server.event.ServerEventListener;
import harfang.server.request.RequestInfo;

/**
 * Program entry point
 */
class ServerMain {

    // This variable contains the name of the server configuration class
    private static var SERVER_CONFIGURATION_CLASS_NAME : String = "server.UserConfiguration";

    /**
     * Harfang's entry point - creates the user's configuration and launches the
     * server with it.
     */
    public static function main() : Void {
        // Load the configuration and start the application
        var requestInfo : RequestInfo = buildRequestInfo();
        launch(getServerConfigurationConstructorCall(), requestInfo);
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

    /**************************************************************************/
    /*                             INTERNAL MACROS                            */
    /**************************************************************************/

    /**
     * This method sets the server configuration class that will be used at
     * launch of the framework
     *
     * @param serverConfigurationClassName The full name of the class, including
     * its package. For example : 'server.UserConfiguration'
     */
    macro private static function setServerConfigurationClass(serverConfigurationClassName : String) : Void {
        SERVER_CONFIGURATION_CLASS_NAME = serverConfigurationClassName;
    }

    /**
     * Returns a call to the server configuration's constructor
     *
     * @return A call to the server configuration's constructor
     * (by default, calls 'new server.UserConfiguration()')
     */
    macro private static function getServerConfigurationConstructorCall() : Expr {
        var pathParts : Array<String> = SERVER_CONFIGURATION_CLASS_NAME.split(".");
        var packParts : Array<String> = new Array<String>();

        // Separate package from class name
        var i : Int = 0;
        while(i < pathParts.length - 1) {
            packParts.push(pathParts[i]);
            i++;
        }

        // Class name is the last part of the full class' path
        var className : String = pathParts[i];

        var constructorCall : Expr = {
            pos : Context.currentPos(),
            expr : ENew({
                    pack : packParts,
                    name : className,
                    sub : null,
                    params : []
                }, []
            )
        }

        return constructorCall;
    }

    /**************************************************************************/
    /*                            PRIVATE FUNCTIONS                           */
    /**************************************************************************/

    /**
     * Builds the request info object based on the server's information
     * @return A RequestInfo instance containing the HTTP request information
     */
    private static function buildRequestInfo() : RequestInfo {
        return new RequestInfo(Web.getURI(), Web.getMethod());
    }
}