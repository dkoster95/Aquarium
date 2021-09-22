//
//  SingletonContainer.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

private typealias SingletonObject = (type: Any.Type, instance: Any)

public final class SingletonContainer: PrototypeContainer {
    
    private var singletons: [SingletonObject] = []
    
    public override init() {
        
    }
    
    private func fetchSingletonObject<DependencyType>(for type: DependencyType.Type) -> DependencyType? {
        if singletons.hasType(DependencyType.self) {
            return singletons.first { singleton in
                return (singleton.type as? (DependencyType.Type)) != nil
            }?.instance as? DependencyType
        }
        return nil
    }
    
    public override func resolve<DependencyType>() throws -> DependencyType {
        if let dependencyInstantiated = fetchSingletonObject(for: DependencyType.self) {
            return dependencyInstantiated
        }
        let instance: DependencyType = try super.resolve()
        singletons.append((DependencyType.self, instance))
        return instance
    }
}

private extension Array where Element == (type: Any.Type, instance: Any) {
    func hasType<Type>(_ type: Type) -> Bool {
        return contains { ($0.type as? Type) != nil }
    }
}
