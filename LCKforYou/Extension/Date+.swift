//
//  Date+.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 25/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation

public var dateformatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    return formatter
}

extension Date {
    /// 몽고디비 시간 바꿔주고 유저가 원하는 시간으로 바꿔줌.
    ///
    /// 몽고디비의 타임존이 UTC로 고정되어 있기 때문에 9시간을 더해줌.
    public func convertToSettingTime(time: Double) -> Date {
        
        return self.toCorrectTime().addingTimeInterval(time)
    }
    
    /// 몽고디비 때문에 시간을 더해준다.
    ///
    /// 몽고디비의 타임존이 UTC로 고정되어 있기 때문에 9시간을 더해줌.
    public func toCorrectTime() -> Date {
        return self.addingTimeInterval(60.0 * 60.0 * 9)
    }
}
