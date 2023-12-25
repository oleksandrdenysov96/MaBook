//
//  MBLogger.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import Foundation
import os.log

class MBLogger {

    static let shared = MBLogger()

    private let logger: Logger

    private init() {
        self.logger = Logger(subsystem: "com.personal.MaBook", category: "GenericCategory")
    }

    func debugInfo(_ message: String) {
        logger.log(level: .debug, "**DEBUG** \(message.uppercased())")
    }

    func logInfo(_ message: String) {
        logger.log(level: .info, "Info: \(message)")
    }

    func logError(_ message: String) {
        logger.log(level: .error, "Error: \(message)")
    }
}
