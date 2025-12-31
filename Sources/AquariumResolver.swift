//
//  AquariumResolver.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public protocol AquariumContainerResolver {
    func resolve<DependencyType>() throws -> DependencyType
}

public enum RegistrationType {
    case singleton
    case prototype
}

public protocol AquariumContainerRegister {
    func register<DependencyType>(registration: @escaping (AquariumContainerResolver) -> DependencyType) throws
}

public protocol AquariumDependencyFacade: AquariumContainerResolver {
    func register<DependencyType>(registration: @escaping (AquariumContainerResolver) -> DependencyType,
                                  with type: RegistrationType) throws
}
