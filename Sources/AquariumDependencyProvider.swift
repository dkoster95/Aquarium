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
            if let container = containers[registrationAvailable] {
                do {
                    let resolvedDependency: DependencyType = try container.resolve()
                    logger.info("Dependency of type: \(DependencyType.self) found in current container under type: \(registrationAvailable)")
                    return resolvedDependency
                } catch let error {
                    logger.info("Dependency of type: \(DependencyType.self) not found under registration type: \(registrationAvailable) error: \(error)")
                }
            }
        }
        logger.info("Dependency type of \(DependencyType.self) not found in current Aquarium, proceeding to search in subAquariums")
        for aquarium in aquariums {
            do {
                let resolvedDependency: DependencyType = try aquarium.resolve()
                logger.info("Dependency type of \(DependencyType.self) found in current subAquarium")
                return resolvedDependency
            } catch let error {
                logger.info("Error while resolving in subAquarium \(error)")
            }
        }
        logger.error("Dependency not registered in current Aquarium")
        throw AquariumError.dependencyNotRegistered
    }
}
