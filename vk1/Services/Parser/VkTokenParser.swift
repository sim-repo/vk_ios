import SwiftyJSON


class VkTokenParser {
    typealias success = String
    typealias error = String
    
    public static func parseCheckTokenJson(_ json: JSON) -> (success, error){
        
        Logger.console(msg: "VkTokenParser(): parseCheckTokenJson(): \n \(json)", printEnum: .login)
        let errorMsg = json["error"]["error_msg"].stringValue
        if errorMsg != ""  {
            Logger.console(msg: "VkTokenParser(): parseCheckTokenJson(): error", printEnum: .login)
            return ("",errorMsg)
        }
        Logger.console(msg: "VkTokenParser(): parseCheckTokenJson(): success", printEnum: .login)
        return ("success","")
    }
}

