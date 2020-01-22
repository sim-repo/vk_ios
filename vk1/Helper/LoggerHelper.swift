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
    
    // for debug purpose only: fast way to enable console logging by area
    enum PrintLogEnum: Int {
        
        case realm, presenter, presenterCallsFromSync, presenterCallsFromView, sync, alamofire, viewReloadData, login, pagination, warning
           
        var print: Bool {
           switch self {
           case .realm:
               return true
           case .presenter:
               return false
           case .presenterCallsFromSync:
               return false
           case .presenterCallsFromView:
               return false
           case .sync:
               return true
           case .alamofire:
               return true
           case .viewReloadData:
               return false
           case .login:
               return false
           case .pagination:
               return false
           case .warning:
               return false
           }
        }
    }
    
    static func log(clazz: String,  _ msg: String, level: Logger.LogLevelEnum, printEnum: PrintLogEnum) {
        switch level {
        case .info:
            Logger.console(msg: "\(clazz): " + msg, printEnum: printEnum)
        case .warning:
            Logger.catchWarning(msg: "\(clazz): " + msg)
        case .error:
            Logger.catchError(msg: "\(clazz): " + msg)
        }
    }
}
