package server.test.controllers;

import php.Lib;

import hawk.server.Controller;

import server.components.views.ViewComposite;

/**
 * Test controller that receives parameters from the request
 */
class ParameterController extends Controller {

    public function handleARequest(parameter:String):Void {
        //Just the test
        var indexView : ViewComposite = new ViewComposite("blog_view_index");

        Lib.print(indexView.render({param:parameter}));
    }

    public function handleAnotherRequest(parameter1:String, parameter2:String):Void {
        //Another test
        var indexView : ViewComposite = new ViewComposite("blog_view_index");

        Lib.print(indexView.render({param:parameter1 + " and " + parameter2}));
    }
}