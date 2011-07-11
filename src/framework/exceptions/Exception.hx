package framework.exceptions;

/**
 * An exception is thrown when an error occurs somewhere in the application and
 * the message is displayed.
 */
class Exception {
    
    private var message:String;
    
    /**
     * Returns the Exception's message
     * @return the Exception's message
     */
    public function getMessage():String {
        return this.message;
    }
}