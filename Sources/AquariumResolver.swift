//
//  AquariumResolver.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public protocol AquariumResolver: class {
    func resolve<DependencyType>() throws -> DependencyType
}

public enum RegistrationType {
    case singleton
    case prototype
}

public protocol AquariumRegister {
    func register<DependencyType>(registration: @escaping (AquariumResolver) -> DependencyType) throws
}

public protocol AquariumDependencyFacade: AquariumResolver {
    func register<DependencyType>(registration: @escaping (AquariumResolver) -> DependencyType, with type: RegistrationType) throws
}
