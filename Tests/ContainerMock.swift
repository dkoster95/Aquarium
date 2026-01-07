//
//  ContainerMock.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/21/21.
//

import Foundation
import Aquarium
import os

struct Logger: AquariumLogger {
    let logger = os.Logger(subsystem: "Aquarium", category: "Tests")
    
    func debug(_ msg: String) {
        logger.debug("\(msg)")
    }
    
    func info(_ msg: String) {
        logger.info("\(msg)")
    }
    
    func error(_ msg: String) {
        logger.error("\(msg)")
    }
    
    func trace(_ msg: String) {
        logger.trace("\(msg)")
    }
    
    
}

class ContainerMock: AquariumContainerRegister, AquariumContainerResolver {
    
    public var errorThrown: Error?
    private(set) var registerCount = 0
    
    func register<DependencyType>(dependencyType: DependencyType.Type,
                                  registration: @escaping RegistrationHandler<DependencyType>) throws {
        registerCount += 1
        if let error = self.errorThrown {
            throw error
        }
    }
    
    private(set) var resolveCount = 0
    var resolveResult: Any!
    func resolve<DependencyType>() throws -> DependencyType {
        resolveCount += 1
        if let error = self.errorThrown {
            throw error
        }
        
        return resolveResult as! DependencyType
    }
}
