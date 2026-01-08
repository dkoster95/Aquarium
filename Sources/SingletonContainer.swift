//
//  SingletonContainer.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public final class SingletonContainer: SimpleContainer {
    
    private var singletons: [String: Any] = [:]
    
    public override func resolve<DependencyType>() throws -> DependencyType {
        if let dependencyInstantiated = singletons["\(DependencyType.self)"],
            let instance = dependencyInstantiated as? DependencyType {
            logger.info("Dependency of Type \(DependencyType.self) resolved as singleton")
            return instance
        }
        logger.info("Dependency of Type \(DependencyType.self) singleton not instantiated proceeding to init")
        let instance: DependencyType = try super.resolve()
        singletons["\(DependencyType.self)"] = instance
        logger.info("Dependency of Type \(DependencyType.self) saved as singleton")
        return instance
    }
}
