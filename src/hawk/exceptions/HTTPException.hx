package hawk.exceptions;

/**
 * An HTTP exception represents an error that must be communicated down to the
 * browser (400 error, 500 error etc.)
 */
class HTTPException extends Exception {

    private var template : String;
    private var errorCode : Int;

    /**
     * Construcs a new HTTP exception
     * @param message The error message
     * @param errorCode The HTTP error code
     * @param template The HTML template to render the error
     */
    public function new(message : String, errorCode : Int, template : String) {
        super(message);
        this.template = template;
        this.errorCode = errorCode;
    }

    public function getTemplate() : String {
        return this.template;
    }

    public function getErrorCode() : Int {
        return this.errorCode;
    }
}