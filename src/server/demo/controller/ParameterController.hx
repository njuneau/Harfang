// Harfang - A Web development framework
// Copyright (C) 2011  Nicolas Juneau <n.juneau@gmail.com>
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

package server.demo.controller;

import php.Lib;

import harfang.controller.AbstractController;

import server.component.view.ViewComposite;

/**
 * Very similar to the IndexController class, but this one shows how parameters
 * are received
 */
class ParameterController extends AbstractController {

    /**
     * Same as in the index, with one parameter
     */
    public function handleARequest(parameter:String):Void {
        var indexView : ViewComposite = new ViewComposite("blog_view_index");
        Lib.print(indexView.render({param:parameter}));
    }

    /**
     * Same as in the index, with two parameters
     */
    public function handleAnotherRequest(parameter1:String, parameter2:String):Void {
        var indexView : ViewComposite = new ViewComposite("blog_view_index");
        Lib.print(indexView.render({param:parameter1 + " and " + parameter2}));
    }
}