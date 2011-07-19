package server.blog.controllers;

import php.Lib;

import framework.server.Controller;
import framework.views.ViewComposite;

class IndexController extends Controller {

    public function handleARequest():Void {
        //Just the test
        var indexView : ViewComposite = new ViewComposite("blog_view_index");
        Lib.print(indexView.render({param:""}));
    }
}