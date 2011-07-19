package server.blog.controllers;

import php.Lib;

import framework.server.Controller;
import framework.views.ViewComposite;

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