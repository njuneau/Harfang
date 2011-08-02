package server.test.controllers;

import php.Lib;

import hawk.server.Controller;
import hawk.views.ViewComposite;

/**
 * Index controller of the application
 */
class IndexController extends Controller {

    public function handleARequest() : Void {
        //Just the test
        var indexView : ViewComposite = new ViewComposite("blog_view_index");
        Lib.print(indexView.render({param:""}));
    }
}