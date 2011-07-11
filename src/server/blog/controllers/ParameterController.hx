package server.blog.controllers;

import framework.server.Controller;
import haxe.Template;
import haxe.Resource;
import php.Lib;

class ParameterController extends Controller {

    public function handleARequest(parameter:String):Void {
        //Just the test
        var sampleTemplate:String = Resource.getString("blog_view_index");

        var template = new Template(sampleTemplate);
        var output:String = template.execute({param:parameter});
        Lib.print(output);
    }

    public function handleAnotherRequest(parameter1:String, parameter2:String):Void {
        //Another test
        var sampleTemplate:String = Resource.getString("blog_view_index");

        var template = new Template(sampleTemplate);
        var output:String = template.execute({param:parameter1 + " and " + parameter2});
        Lib.print(output);
    }
}