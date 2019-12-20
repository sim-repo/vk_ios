import Foundation

struct Logger {
    
    enum LogLevelEnum {
        case info
        case warning
        case error
    }

    static func catchError(msg: String){
        #if DEBUG
            print("----------------------")
            print("ERROR: " + msg)
            print("----------------------")
            //fatalError()
        #else
            sendCrashlytics(msg)
        #endif
    }

    static func catchWarning(msg: String){
        guard PrintLogEnum.warning.print
            else { return }
        #if DEBUG
               print("----------------------")
               print("WARNING: " + msg)
               print("----------------------")
        #else
           sendCrashlytics(msg)
        #endif
    }


    static func console(msg: String, printEnum: PrintLogEnum) {
        #if DEBUG
            if printEnum.print {
                print(msg)
                print()
            }
        #else
            logInf(msg)
        #endif
    }

    static func logInf(msg: String) {
        //TODO
    }

    static func sendCrashlytics(_ msg: String) {
        //TODO
    }
}
