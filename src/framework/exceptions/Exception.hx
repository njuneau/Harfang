package framework.exceptions;

/**
 * An exception is thrown when an error occurs somewhere in the application and
 * the message is displayed.
 */
class Exception {

    private var message:String;

    /**
     * Creates a new exception
     * @param message The error message
     */
    public function new(message : String) {
        this.message = message;
    }

    /**
     * Sets the error message
     * @param message The error message
     */
    private function setMessage(message : String) : Void {
        this.message = message;
    }

    /**
     * Returns the Exception's message
     * @return the Exception's message
     */
    public function getMessage():String {
        return this.message;
    }
}