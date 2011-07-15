package framework.exceptions;

import framework.exceptions.HTTPException;

/**
 * The 404 exception is thrown whenever something is not found, server-side.
 */
class NotFoundException extends HTTPException {

    /**
     * Creates a new 404 not found HTTP error
     * @param message The message you want to show to the user (optional)
     */
    public function new(message:String = null) {
        super("You requested something that doesn't exists", 404, "framework_http_error_template");

        // If no default message is sent, put a default one
        if(message != null) {
            this.setMessage(message);
        }
    }
}