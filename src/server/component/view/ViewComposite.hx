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

package server.component.view;

import haxe.Template;
import haxe.Resource;
import Hash;

/**
 * A ViewComposite is the basis to construct template-based views. You can
 * combine views by constructing View objects and then having a root view
 * with the ViewComposite.
 */
class ViewComposite {

    private var resourceName : String;

    /**
     * Constructs a new composite view
     * @param resourceName The template's resource identificator
     */
    public function new(resourceName : String) {
        this.resourceName = resourceName;
    }

    /**
     * Renders the template as a string
     *
     * @param context Context variables
     * @param macros Template macros
     * @return The rendered template
     */
    private function renderTemplate(context : Dynamic, ? macros : Dynamic) : String {
        var template : Template = new Template(Resource.getString(this.resourceName));
        return template.execute(context, macros);
    }

    /**
     * Renders the view as a string
     *
     * @param context Context variables
     * @param macros Template macros
     * @return The rendered template
     */
    public function render(context : Dynamic, ? macros : Dynamic) : String {
        return this.renderTemplate(context, macros);
    }
}