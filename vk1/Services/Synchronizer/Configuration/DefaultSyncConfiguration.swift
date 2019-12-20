import Foundation

struct DefaultSyncConfiguration {
    var startTime: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    var endTime: Date {
        return Calendar.current.date(bySettingHour: 08, minute: 0, second: 0, of: Date.tomorrow)!
    }
    
    var interval: TimeInterval {
        return 1 //min // every hour
    }
}
