//
//  OSLog.swift
//
//  Created by dwKang on 2021/06/19.
//

import Foundation
import os.log

extension OSLog {
    
//    ## Check
//    Console App > 동작 > 정보 메시지 포함
//                         디버그 메시지 포함
//    import os.log
//
//    type: .default
//           .info
//           .debug
//           .error
//           .fault
//
//    ## ex)
//    os_log("message", log: OSLog.dwLog, type: .info)
//    os_log("didReceiveRegistrationToken : %{public}@", log: OSLog.dwLog, type: .info, fcmToken)
    
    
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let dwLog = OSLog(subsystem: subsystem, category: "dwLog")
}
