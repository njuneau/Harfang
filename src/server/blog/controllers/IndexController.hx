package server.blog.controllers;

import framework.server.Controller;
import haxe.Template;
import haxe.Resource;
import php.Lib;

class IndexController extends Controller {

    public function handleARequest():Void {
        //Just the test
        var sampleTemplate:String = Resource.getString("blog_view_index");

        var template = new Template(sampleTemplate);
        var output:String = template.execute({param:""});
        Lib.print(output);
    }
}