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

package harfang.test.urldispatcher.mock;

import harfang.controller.AbstractController;
import harfang.module.Module;

/**
 * This is the mock controller that is used for the URL dispatcher test case
 */
class MockURLDispatcherController extends AbstractController {

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

    /**
     * Init the module
     */
    public override function init(module : Module) {
        super.init(module);
        MockURLDispatcherController.isInit = true;
    }

    /**
     * Handle a request (pre-method call)
     * @param controllerMethodName The controller method what will be called
     */
    public override function handleRequest(controllerMethodName : String) : Bool {
        MockURLDispatcherController.lastMethodName = controllerMethodName;

        var dispatch : Bool = true;

        if(controllerMethodName == "doNotDispatch") {
            dispatch = false;
        }

        return dispatch;
    }

    /**
     * Post-request call
     */
    public override function handlePostRequest(controllerMethodName : String) : Void {
        MockURLDispatcherController.calledPostRequest = true;
        MockURLDispatcherController.lastPostMethodName = controllerMethodName;
    }

    /**
     * Dispatch a simple request
     */
    public function dispatchSimple() : Void {
        MockURLDispatcherController.dispatchedSimple = true;
    }

    /**
     * Dispatch a request with a parameter
     */
    public function dispatchParam(param : String) : Void {
        MockURLDispatcherController.dispatchedParam = true;
        MockURLDispatcherController.dispatchParamParam = param;
    }

    /**
     * Dispatch a request with multiple parameters
     */
    public function dispatchMultipleParam(paramA : String, paramB : String) {
        MockURLDispatcherController.dispatchedMutlipleParam = true;
        MockURLDispatcherController.dispatchMutlipleParamParamA = paramA;
        MockURLDispatcherController.dispatchMutlipleParamParamB = paramB;
    }

    /**
     * Although this method is mapped in the configuration, it should not be
     * called because we prevent so in the handleRequest method.
     */
    public function doNotDispatch() : Void {
        MockURLDispatcherController.dispatchedDoNotDispatch = true;
    }

    /**************************************************************************/
    /*                                DIAGNOSTICS                             */
    /**************************************************************************/

    /**
     * Indicates if the controller was call at initialisation
     */
    public static function getIsInit() : Bool {
        return MockURLDispatcherController.isInit;
    }

    /**
     * Resets all test variables
     */
    public static function reset() : Void {
        MockURLDispatcherController.dispatchedSimple = false;
        MockURLDispatcherController.dispatchedParam = false;
        MockURLDispatcherController.dispatchParamParam = null;
        MockURLDispatcherController.dispatchedMutlipleParam = false;
        MockURLDispatcherController.dispatchMutlipleParamParamA = null;
        MockURLDispatcherController.dispatchMutlipleParamParamB = null;
        MockURLDispatcherController.dispatchedDoNotDispatch = false;
        MockURLDispatcherController.lastMethodName = null;
        MockURLDispatcherController.lastPostMethodName = null;
        MockURLDispatcherController.isInit = false;
        MockURLDispatcherController.calledPostRequest = false;
    }

    /**
     * Indicates if "dispatchSimple" was called
     */
    public static function getDispatchedSimple() : Bool {
        return MockURLDispatcherController.dispatchedSimple;
    }

    /**
     * Indicates if "dispatchParam" was called
     */
    public static function getDispatchedParam() : Bool {
        return MockURLDispatcherController.dispatchedParam;
    }

    /**
     * Returns the value of the parameter that was given to "dispatchParam"
     */
    public static function getDispatchParamParam() : String {
        return MockURLDispatcherController.dispatchParamParam;
    }

    /**
     * Indicates if "dispatchMultipleParam" was called
     */
    public static function getDispatchedMultipleParam() : Bool {
        return MockURLDispatcherController.dispatchedMutlipleParam;
    }

    /**
     * Returns the value of the first parameter that was given to "dispatchMutlipleParam"
     */
    public static function getDispatchMutlipleParamParamA() : String {
        return MockURLDispatcherController.dispatchMutlipleParamParamA;
    }

    /**
     * Returns the value of the second parameter that was given to "dispatchMutlipleParam"
     */
    public static function getDispatchMutlipleParamParamB() : String {
        return MockURLDispatcherController.dispatchMutlipleParamParamB;
    }

    /**
     * Indicates if the "doNotDispatch" method was called
     */
    public static function getDispatchedDoNotDispatch() : Bool {
        return MockURLDispatcherController.dispatchedDoNotDispatch;
    }

    /**
     * Returns the last method name that was sent to handleRequest
     */
    public static function getLastMethodName() : String {
        return MockURLDispatcherController.lastMethodName;
    }

    /**
     * Indicates if the "postRequest" method was called
     */
    public static function getCalledPostRequest() : Bool  {
        return MockURLDispatcherController.calledPostRequest;
    }

    /**
     * Returns the last method name that was sent to handlePostRequest
     */
    public static function getLastPostMethodName() : String {
        return MockURLDispatcherController.lastPostMethodName;
    }

}