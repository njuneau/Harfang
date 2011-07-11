package framework.exceptions;

import framework.exceptions.Exception;
import haxe.Template;
import haxe.Resource;
import php.Web;

/**
 * The Five-O-Five exception is called whenever something went wrong server-side.
 */
class FOFServerErrorException extends Exception {
    
    private var template:Template;
    private static var ERROR_CODE:Int = 500;
    
    public function new(message:String = null) {
        
        if(message != null) {
            this.message = message;
        } else {
            this.message = "Internal server error - something went wrong";
        }
        
        this.template = new Template(Resource.getString("framework_http_error_template")); 
        this.message = template.execute({errorCode:ERROR_CODE, message:this.message});
        Web.setReturnCode(ERROR_CODE);
    }
}