//
//  AquariumContainer.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public typealias DependencyGenerator = ((AquariumContainerResolver) throws -> Any)

public typealias DependencyContainer = AquariumContainerRegister & AquariumContainerResolver
public typealias RegistrationHandler<DependencyType> = (AquariumContainerResolver) throws -> DependencyType

typealias Registration = (generator: DependencyGenerator, type: Any.Type)

public protocol AquariumContainerResolver {
    func resolve<DependencyType>() throws -> DependencyType
}

public enum RegistrationType: Int, CaseIterable {
    case singleton
    case simple
}

public protocol AquariumContainerRegister {
    func register<DependencyType>(dependencyType: DependencyType.Type,
                                  registration: @escaping RegistrationHandler<DependencyType>) throws
}

public protocol AquariumDependencyProvider: AquariumContainerResolver {
    func register<DependencyType>(dependencyType: DependencyType.Type,
                                  registration: @escaping RegistrationHandler<DependencyType>,
                                  with type: RegistrationType) throws
}

public protocol AquariumLogger {
    func debug(_ msg: String)
    func info(_ msg: String)
    func error(_ msg: String)
    func trace(_ msg: String)
}
