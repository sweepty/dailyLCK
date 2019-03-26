//
//  Log.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 25/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

extension LogLevel {
    var emoji: String {
        switch self {
        case .debug:
            return "💜"
        case .info:
            return "💙"
        case .warning:
            return "❤️"
        case .error:
            return "💔"
        }
    }
}

struct Log {
    static func debug(_ message: Any,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        #if DEBUG
        logger(level: .debug, message: message, file: file, function: function, line: line)
        #endif
    }
    
    static func info(_ message: Any,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
        logger(level: .info, message: message, file: file, function: function, line: line)
    }
    
    static func warning(_ message: Any,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
        logger(level: .warning, message: message, file: file, function: function, line: line)
    }
    
    static func error(_ message: Any,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        logger(level: .error, message: message, file: file, function: function, line: line)
    }
    
    static func logger(level: LogLevel, message: Any, file: String, function: String, line: Int) {
        let fileName = file.split(separator: "/").last ?? ""
        let functionName = function.split(separator: "(").first ?? ""
        print("\(level.emoji)\(level.rawValue) [\(fileName)] \(functionName)(\(line)): \(message)")
    }
}
