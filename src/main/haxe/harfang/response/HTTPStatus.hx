// Harfang - A Web development framework
// Copyright (C) Nicolas Juneau <n.juneau@gmail.com>
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

package harfang.response;

/**
 * This is a list of various HTTP status codes. This is based on a list found
 * on Wikipedia here : https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
 * Reference consulted on 2016-02-07.
 */
class HTTPStatus {
    public static inline var INFORMAL_CONTINUE : Int =                              100;
    public static inline var INFORMAL_SWITCHING_PROTOCOLS : Int =                   101;
    public static inline var INFORMAL_PROCESSING : Int =                            102;

    public static inline var SUCCESS_OK : Int =                                     200;
    public static inline var SUCCESS_CREATED : Int =                                201;
    public static inline var SUCCESS_ACCEPTED : Int =                               202;
    public static inline var SUCCESS_NON_AUTHORITATIVE_INFORMATION : Int =          203;
    public static inline var SUCCESS_NO_CONTENT : Int =                             204;
    public static inline var SUCCESS_RESET_CONTENT : Int =                          205;
    public static inline var SUCCESS_PARTIAL_CONTENT : Int =                        206;
    public static inline var SUCCESS_MULTI_STATUS : Int =                           207;
    public static inline var SUCCESS_ALREADY_REPORTED : Int =                       208;
    public static inline var SUCCESS_IM_USED : Int =                                226;

    public static inline var REDIRECTION_MULTIPLE_CHOICES : Int =                   300;
    public static inline var REDIRECTION_MOVED_PERMANENTLY : Int =                  301;
    public static inline var REDIRECTION_FOUND : Int =                              302;
    public static inline var REDIRECTION_SEE_OTHER : Int =                          303;
    public static inline var REDIRECTION_NOT_MODIFIED : Int =                       304;
    public static inline var REDIRECTION_USE_PROXY : Int =                          305;
    public static inline var REDIRECTION_SWITCHING_PROXY : Int =                    306;
    public static inline var REDIRECTION_TEMPORARY_REDIRECT : Int =                 307;
    public static inline var REDICTION_PERMANENT_REDIRECT : Int =                   308;

    public static inline var CLIENT_ERROR_BAD_REQUEST : Int =                       400;
    public static inline var CLIENT_ERROR_UNAUTHORIZED : Int =                      401;
    public static inline var CLIENT_ERROR_FORBIDDEN : Int =                         403;
    public static inline var CLIENT_ERROR_NOT_FOUND : Int =                         404;
    public static inline var CLIENT_ERROR_METHOD_NOT_ALLOWED : Int =                405;
    public static inline var CLIENT_ERROR_NOT_ACCEPTABLE : Int =                    406;
    public static inline var CLIENT_ERROR_PROXY_AUTHENTICATION_REQUIRED : Int =     407;
    public static inline var CLIENT_ERROR_REQUEST_TIMEOUT : Int =                   408;
    public static inline var CLIENT_ERROR_CONFLICT : Int =                          409;
    public static inline var CLIENT_ERROR_GONE : Int =                              410;
    public static inline var CLIENT_ERROR_LENGTH_REQUIRED : Int =                   411;
    public static inline var CLIENT_ERROR_PRECONDITION_FAILED : Int =               412;
    public static inline var CLIENT_ERROR_PAYLOAD_TOO_LARGE : Int =                 413;
    public static inline var CLIENT_ERROR_URI_TOO_LONG : Int =                      414;
    public static inline var CLIENT_ERROR_UNSUPPORTED_MEDIA_TYPE : Int =            415;
    public static inline var CLIENT_ERROR_RANGE_NOT_SATISFIABLE : Int =             416;
    public static inline var CLIENT_ERROR_EXPECTATION_FAILED : Int =                417;
    // ;)
    public static inline var CLIENT_ERROR_I_AM_A_TEAPOT : Int =                     418;
    public static inline var CLIENT_ERROR_AUTHENTICATION_TIMEOUT : Int =            419;
    public static inline var CLIENT_ERROR_MISDIRECTED_REQUEST : Int =               421;
    public static inline var CLIENT_ERROR_UNPROCESSABLE_ENTITY : Int =              422;
    public static inline var CLIENT_ERROR_LOCKED : Int =                            423;
    public static inline var CLIENT_ERROR_FAILED_DEPENDENCY : Int =                 424;
    public static inline var CLIENT_ERROR_UPGRADE_REQUIRED  : Int =                 426;
    public static inline var CLIENT_ERROR_PRECONDITION_REQUIRED : Int =             428;
    public static inline var CLIENT_ERROR_TOO_MANY_REQUESTS : Int =                 429;
    public static inline var CLIENT_ERROR_REQUEST_HEADER_FIELDS_TOO_LARGE : Int =   431;

    public static inline var SERVER_ERROR_INTERNAL_SERVER_ERROR : Int =             500;
    public static inline var SERVER_ERROR_NOT_IMPLEMENTED : Int =                   501;
    public static inline var SERVER_ERROR_BAD_GATEWAY : Int =                       502;
    public static inline var SERVER_ERROR_SERVICE_UNAVAILABLE : Int =               503;
    public static inline var SERVER_ERROR_GATEWAY_TIMEOUT : Int =                   504;
    public static inline var SERVER_ERROR_HTTP_VERSION_NOT_SUPPORTED : Int =        505;
    public static inline var SERVER_ERROR_VARIANT_ALSO_NEGOTIATES : Int =           506;
    public static inline var SERVER_ERROR_INSUFFICIENT_STORAGE : Int =              507;
    public static inline var SERVER_ERROR_LOOP_DETECTED : Int =                     508;
    public static inline var SERVER_ERROR_NOT_EXTENDED : Int =                      510;
    public static inline var SERVER_ERROR_NETWORK_AUTHENTICATION_REQUIRED : Int =   511;
}