//
//  AquariumLogger.swift
//  Aquarium
//
//  Created by Daniel Koster on 2/9/26.
//
import Foundation
import os

public struct DefaultLogger: AquariumLogger {
    private let logger: os.Logger
    
    public init(subsystem: String, category: String) {
        logger = os.Logger(subsystem: subsystem, category: category)
    }
    
    public func debug(_ msg: String) {
        logger.debug("\(msg)")
    }
    
    public func info(_ msg: String) {
        logger.info("\(msg)")
    }
    
    public func error(_ msg: String) {
        logger.error("\(msg)")
    }
    
    public func trace(_ msg: String) {
        logger.trace("\(msg)")
    }
}
