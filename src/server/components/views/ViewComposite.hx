package server.components.views;

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
    private function renderTemplate(context : Dynamic, macros : Dynamic = null) : String {
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
    public function render(context : Dynamic, macros : Dynamic = null) : String {
        return this.renderTemplate(context, macros);
    }
}