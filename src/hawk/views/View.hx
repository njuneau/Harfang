package hawk.views;

/**
 * A View object is part of a composite. You can combine as many as you want,
 * they are structured in a hierarchical manner. All of the view's parameters
 * are passed up to the parents.
 *
 * In order to render the contents of a sub-view in a view, you must reserve
 * a template variable named "__child_template"
 */
class View extends ViewComposite {

    private var parentView : View;

    /**
     * Constructs a new view
     * @param parentView This view's parent
     * @param resourceName The template's resource identificator
     */
    public function new(resourceName : String, parentView : ViewComposite) {
        super(resourceName);
        this.parentView = parentView;
    }

    /**
     * Renders the template as a string
     *
     * @param context Context variables
     * @param macros Template macros
     * @return The rendered template
     */
    public override function render(context : Dynamic, macros : Dynamic = null) : String {
        var subResult : String = this.renderTemplate(context, macros);

        // Set child view in the template context
        context.__child_template = subResult;

        // Render the parent view as a result
        return this.parentView.render(context, macros);
    }

}