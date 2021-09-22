//
//  PrototypeContainer.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

typealias Registration = (generator: DependencyGenerator, type: Any.Type)

public class PrototypeContainer: AquariumRegister, AquariumResolver {
    
    var registrations: [Registration] = []
    
    public init() {
        
    }
    
    public func register<DependencyType>(registration: @escaping (AquariumResolver) -> DependencyType) throws {
        let dependencyExists = registrations.contains { registation in
            return (registation.type as? (DependencyType.Type)) != nil
        }
        if dependencyExists {
            throw AquariumError.dependencyAlreadyRegistered
        }
        registrations.append((registration, DependencyType.self))
    }
    
    private func findIfExists<DependencyType>(type: DependencyType.Type) -> Registration? {
        return registrations.first { registation in
            return (registation.type as? (DependencyType.Type)) != nil
        } as? (generator: DependencyGenerator, type: DependencyType.Type)
    }
    
    public func resolve<DependencyType>() throws -> DependencyType {
        let registrationIfExists = findIfExists(type: DependencyType.self)
        if let validDependency = registrationIfExists,
           let instance = validDependency.generator(self) as? DependencyType {
            return instance
        }
        throw AquariumError.dependencyNotRegistered
    }
}
