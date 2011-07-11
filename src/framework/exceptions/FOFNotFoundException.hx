package framework.exceptions;

import framework.exceptions.Exception;
import haxe.Template;
import haxe.Resource;
import php.Web;

/**
 * The Four-O-Four exception is called whenever something is not found, server-side.
 */
class FOFNotFoundException extends Exception {
    
    private var template:Template;
    private static var ERROR_CODE:Int = 404;
    
    public function new(message:String = null) {
        
        if(message != null) {
            this.message = message;
        } else {
            this.message = "You requested something that doesn't exists";
        }
        
        this.template = new Template(Resource.getString("framework_http_error_template"));
        this.message = template.execute({errorCode:ERROR_CODE, message:this.message});
        Web.setReturnCode(ERROR_CODE);
    }
}