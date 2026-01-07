//
//  AquariumResolver.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public final class Aquarium: AquariumDependencyProvider {
    private var containers: [RegistrationType: DependencyContainer] = [:]
    private var aquariums: [any AquariumDependencyProvider]
    private let logger: AquariumLogger
    
    public init(containers: [RegistrationType : DependencyContainer],
                aquariums: [any AquariumDependencyProvider] = [],
                logger: AquariumLogger) {
        self.containers = containers
        self.aquariums = aquariums
        self.logger = logger
    }
    
    public func register<DependencyType>(dependencyType: DependencyType.Type,
                                         registration: @escaping RegistrationHandler<DependencyType>,
                                         with type: RegistrationType) throws {
        if let container = containers[type] {
            logger.info("container of type \(type) found")
            try container.register(dependencyType: dependencyType,
                                   registration: registration)
            return
        }
        logger.error("container of type \(type) not configured")
        throw AquariumError.registrationTypeNotConfigured
    }
    
    public func resolve<DependencyType>() throws -> DependencyType {
        let registrationTypes = containers.keys.sorted { $0.rawValue < $1.rawValue }
        logger.info("container of types \(registrationTypes) found")
        for registrationAvailable in registrationTypes {
            if let resolvedDependency: DependencyType = try? containers[registrationAvailable]?.resolve() {
                return resolvedDependency
            }
        }
        for aquarium in aquariums {
            if let resolvedDependency: DependencyType = try? aquarium.resolve() {
                return resolvedDependency
            }
        }
        throw AquariumError.dependencyNotRegistered
    }
}
