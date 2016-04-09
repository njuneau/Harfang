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

package requestdispatcher.mock;

import harfang.controller.AbstractController;
import harfang.module.Module;
import harfang.request.RequestInfo;
import harfang.url.URLMapping;

/**
 * This is the mock controller that is used for the URL dispatcher test case
 */
class MockRequestDispatcherController extends AbstractController {

    private static var isInit : Bool = false;
    private static var dispatchedSimple : Bool = false;

    private static var dispatchedParam : Bool = false;
    private static var dispatchParamParam : String;

    private static var dispatchedMutlipleParam : Bool = false;
    private static var dispatchMutlipleParamParamA : String;
    private static var dispatchMutlipleParamParamB : String;

    private static var dispatchedDoNotDispatch : Bool = false;
    private static var lastMethodName : String;

    private static var calledPostRequest : Bool = false;
    private static var lastPostMethodName : String;

    public override function init(module : Module) {
        super.init(module);
        MockRequestDispatcherController.isInit = true;
    }

    public override function handleRequest(urlMapping : URLMapping, requestInfo : RequestInfo) : Bool {
        MockRequestDispatcherController.lastMethodName = urlMapping.getControllerMethodName();

        var dispatch : Bool = true;

        if(urlMapping.getControllerMethodName() == "doNotDispatch") {
            dispatch = false;
        }

        return dispatch;
    }

    /**
     * Post-request call
     */
    public override function handlePostRequest(urlMapping : URLMapping, requestInfo : RequestInfo) : Void {
        MockRequestDispatcherController.calledPostRequest = true;
        MockRequestDispatcherController.lastPostMethodName = urlMapping.getControllerMethodName();
    }

    /**
     * Dispatch a simple request
     */
    public function dispatchSimple() : Void {
        MockRequestDispatcherController.dispatchedSimple = true;
    }

    /**
     * Dispatch a request with a parameter
     */
    public function dispatchParam(param : String) : Void {
        MockRequestDispatcherController.dispatchedParam = true;
        MockRequestDispatcherController.dispatchParamParam = param;
    }

    /**
     * Dispatch a request with multiple parameters
     */
    public function dispatchMultipleParam(paramA : String, paramB : String) {
        MockRequestDispatcherController.dispatchedMutlipleParam = true;
        MockRequestDispatcherController.dispatchMutlipleParamParamA = paramA;
        MockRequestDispatcherController.dispatchMutlipleParamParamB = paramB;
    }

    /**
     * Although this method is mapped in the configuration, it should not be
     * called because we prevent so in the handleRequest method.
     */
    public function doNotDispatch() : Void {
        MockRequestDispatcherController.dispatchedDoNotDispatch = true;
    }

    /**************************************************************************/
    /*                                DIAGNOSTICS                             */
    /**************************************************************************/

    /**
     * Indicates if the controller was call at initialisation
     */
    public static function getIsInit() : Bool {
        return MockRequestDispatcherController.isInit;
    }

    /**
     * Resets all test variables
     */
    public static function reset() : Void {
        MockRequestDispatcherController.dispatchedSimple = false;
        MockRequestDispatcherController.dispatchedParam = false;
        MockRequestDispatcherController.dispatchParamParam = null;
        MockRequestDispatcherController.dispatchedMutlipleParam = false;
        MockRequestDispatcherController.dispatchMutlipleParamParamA = null;
        MockRequestDispatcherController.dispatchMutlipleParamParamB = null;
        MockRequestDispatcherController.dispatchedDoNotDispatch = false;
        MockRequestDispatcherController.lastMethodName = null;
        MockRequestDispatcherController.lastPostMethodName = null;
        MockRequestDispatcherController.isInit = false;
        MockRequestDispatcherController.calledPostRequest = false;
    }

    /**
     * Indicates if "dispatchSimple" was called
     */
    public static function getDispatchedSimple() : Bool {
        return MockRequestDispatcherController.dispatchedSimple;
    }

    /**
     * Indicates if "dispatchParam" was called
     */
    public static function getDispatchedParam() : Bool {
        return MockRequestDispatcherController.dispatchedParam;
    }

    /**
     * Returns the value of the parameter that was given to "dispatchParam"
     */
    public static function getDispatchParamParam() : String {
        return MockRequestDispatcherController.dispatchParamParam;
    }

    /**
     * Indicates if "dispatchMultipleParam" was called
     */
    public static function getDispatchedMultipleParam() : Bool {
        return MockRequestDispatcherController.dispatchedMutlipleParam;
    }

    /**
     * Returns the value of the first parameter that was given to "dispatchMutlipleParam"
     */
    public static function getDispatchMutlipleParamParamA() : String {
        return MockRequestDispatcherController.dispatchMutlipleParamParamA;
    }

    /**
     * Returns the value of the second parameter that was given to "dispatchMutlipleParam"
     */
    public static function getDispatchMutlipleParamParamB() : String {
        return MockRequestDispatcherController.dispatchMutlipleParamParamB;
    }

    /**
     * Indicates if the "doNotDispatch" method was called
     */
    public static function getDispatchedDoNotDispatch() : Bool {
        return MockRequestDispatcherController.dispatchedDoNotDispatch;
    }

    /**
     * Returns the last method name that was sent to handleRequest
     */
    public static function getLastMethodName() : String {
        return MockRequestDispatcherController.lastMethodName;
    }

    /**
     * Indicates if the "postRequest" method was called
     */
    public static function getCalledPostRequest() : Bool  {
        return MockRequestDispatcherController.calledPostRequest;
    }

    /**
     * Returns the last method name that was sent to handlePostRequest
     */
    public static function getLastPostMethodName() : String {
        return MockRequestDispatcherController.lastPostMethodName;
    }

}