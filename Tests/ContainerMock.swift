//
//  ContainerMock.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/21/21.
//

import Foundation
import Aquarium

class ContainerMock: AquariumRegister, AquariumResolver {
    
    public var errorThrown: Error?
    public var instances: [(generator: DependencyGenerator, type: Any.Type)] = []
    
    func register<DependencyType>(registration: @escaping (AquariumResolver) -> DependencyType) throws {
        if let error = self.errorThrown {
            throw error
        }
        instances.append((registration,DependencyType.self))
    }
    
    func resolve<DependencyType>() throws -> DependencyType {
        if let error = self.errorThrown {
            throw error
        }
        
        let registration = instances.first { instances in
            return (instances.type as? (DependencyType.Type)) != nil
        } as? (generator: DependencyGenerator, type: DependencyType.Type)
        
        return registration!.generator(self) as! DependencyType
    }  
}
