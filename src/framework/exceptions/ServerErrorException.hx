package framework.exceptions;

import framework.exceptions.HTTPException;

/**
 * The 505 exception is called whenever something went wrong server-side.
 */
class ServerErrorException extends HTTPException {

    /**
     * Creates a new 500 HTTP error
     * @param message The message you want to show to the user (optional)
     */
    public function new(message:String = null) {
        super("Internal server error - something went wrong", 500, "framework_http_error_template");

        if(message != null) {
            this.setMessage(message);
        }
    }
}