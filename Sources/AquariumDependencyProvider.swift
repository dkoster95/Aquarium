//
//  AquariumResolver.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public final class Aquarium: AquariumDependencyProvider, ComposableAquarium {
    private var containers: [RegistrationType: DependencyContainer] = [:]
    private let logger: AquariumLogger
    public var root: DependencyContainer
    
    public init(containers: [RegistrationType : DependencyContainer],
                aquariums: [any AquariumDependencyProvider & ComposableAquarium] = [],
                logger: AquariumLogger) {
        self.containers = containers
        self.logger = logger
        root = containers[RegistrationType.simple] != nil ? containers[.simple]! : containers[.singleton]!
        initRoot(aquariums: aquariums)
    }
    
    private func initRoot(aquariums: [any AquariumDependencyProvider & ComposableAquarium]) {
        for registrationType in RegistrationType.allCases where registrationType != .simple {
            if let container = containers[registrationType] {
                root += container
            }
        }
        for aquarium in aquariums {
            if !aquarium.root.isEmpty {
                root += aquarium.root
            }
        }
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
        do {
            let resolvedDependency: DependencyType = try root.resolve()
            logger.info("Dependency of type: \(DependencyType.self) found in current Aquarium")
            return resolvedDependency
        } catch let error {
            logger.info("Dependency of type: \(DependencyType.self) not found error: \(error)")
        }
        logger.error("Dependency not registered in current Aquarium")
        throw AquariumError.dependencyNotRegistered
    }
}

public extension Aquarium {
    convenience init(aquariums: [any AquariumDependencyProvider & ComposableAquarium] = [],
                     logger: AquariumLogger = DefaultLogger(subsystem: "Aquarium", category: "Aquarium Logs")) {
        self.init(containers: [.simple: SimpleContainer(),
                               .singleton: SingletonContainer()],
                  aquariums: aquariums,
                  logger: logger)
    }
}
