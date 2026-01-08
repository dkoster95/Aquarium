//
//  PrototypeContainer.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public class SimpleContainer: DependencyContainer {
    
    private let containers: [DependencyContainer]
    let logger: AquariumLogger
    var registrations: [Registration] = []
    
    public init(containers: [DependencyContainer] = [],
                logger: AquariumLogger) {
        self.containers = containers
        self.logger = logger
    }
    
    public func register<DependencyType>(dependencyType: DependencyType.Type,
                                         registration: @escaping RegistrationHandler<DependencyType>) throws {
        let dependencyExists = registrations.contains { registation in
            return (registation.type as? (DependencyType.Type)) != nil
        }
        if dependencyExists {
            logger.error("Dependency of Type \(DependencyType.self) is already registered")
            throw AquariumError.dependencyAlreadyRegistered
        }
        logger.info("Registering Dependency of Type \(DependencyType.self)")
        registrations.append((registration, DependencyType.self))
    }
    
    private func find<DependencyType>(type: DependencyType.Type) -> Registration? {
        return registrations.first { registation in
            return (registation.type as? (DependencyType.Type)) != nil
        } as? (generator: DependencyGenerator, type: DependencyType.Type)
    }
    
    private func findInContainers<DependencyType>(type: DependencyType.Type) throws -> DependencyType {
        logger.info("Resolving dependency of type \(DependencyType.self) in subContainers")
        for container in containers {
            logger.info("Resolving dependency of type \(DependencyType.self) in \(container)")
            do {
                let dependency: DependencyType = try container.resolve()
                return dependency
            } catch let error {
                logger.info("Error when resolving in container \(error)")
            }
        }
        throw AquariumError.dependencyNotRegistered
    }
    
    public func resolve<DependencyType>() throws -> DependencyType {
        logger.info("Resolving dependency of type \(DependencyType.self)")
        if let validDependency = find(type: DependencyType.self),
           let instance = try validDependency.generator(self) as? DependencyType {
            logger.info("Dependency of Type \(DependencyType.self) found in container")
            return instance
        }
        logger.info("Dependency of Type \(DependencyType.self) not found in current container")
        if let subDependency: DependencyType = try? findInContainers(type: DependencyType.self) {
            logger.info("Dependency of Type \(DependencyType.self) found in sub container")
            return subDependency
        }
        logger.error("Dependency of Type \(DependencyType.self) is not registered")
        throw AquariumError.dependencyNotRegistered
    }
}
