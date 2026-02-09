//
//  ContainerMock.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/21/21.
//

import Foundation
import Aquarium
import os

class ContainerMock: DependencyContainer {
    
    var isEmpty: Bool = true
    
    var containers: [any DependencyContainer] = []
    
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
