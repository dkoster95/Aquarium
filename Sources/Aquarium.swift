//
//  AquariumContainer.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public typealias DependencyGenerator = ((AquariumResolver) -> Any)
public typealias DependencyContainer = AquariumRegister & AquariumResolver

public final class Aquarium: AquariumDependencyFacade {
    
    private var singletonContainer: DependencyContainer
    private var prototypeContainer: DependencyContainer
    public static let shared = Aquarium(singletonContainer: SingletonContainer(), prototypeContainer: PrototypeContainer())
    
    public init(singletonContainer: DependencyContainer, prototypeContainer: DependencyContainer) {
        self.singletonContainer = singletonContainer
        self.prototypeContainer = prototypeContainer
    }
    
    public func register<DependencyType>(registration: @escaping (AquariumResolver) -> DependencyType, with type: RegistrationType) throws {
        if type == .singleton {
            try singletonContainer.register(registration: registration)
        } else {
            try prototypeContainer.register(registration: registration)
        }
    }
    
    public func resolve<DependencyType>() throws -> DependencyType {
        if let singletonResolvedInstance: DependencyType = try? singletonContainer.resolve() {
            return singletonResolvedInstance
        }
        return try prototypeContainer.resolve()
    }
}
