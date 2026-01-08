//
//  PrototypeContainerTests.swift
//  AquariumTests
//
//  Created by Daniel Koster on 9/21/21.
//

import Testing
import Aquarium

class SimpleContainerTests {
    
    @Test func test_WhenDependencyExistentIsRegistered_ExpectDependencyRegisteredError() throws {
        let sut = SimpleContainer()
        let registration = {
            try sut.register(dependencyType: SomeDependency.self) { _ in
                return SomeConcreteClass()
            }
        }
        try registration()
        #expect(throws: AquariumError.dependencyAlreadyRegistered) {
            try registration()
        }
    }
    
    @Test func test_WhenDependencyIsRegistered_ExpectDependencyToBeResolved() throws {
        let sut = SimpleContainer()
        let registration = {
            try sut.register(dependencyType: SomeDependency.self) { _ in
                return SomeConcreteClass()
            }
        }
        try registration()
        let result: SomeDependency = try sut.resolve()
        result.someDependencyMethod(value: "value")
        #expect("value" == result.someValue)
    }
    
    @Test func multipleDependencies() throws {
        let singletonContainer = SingletonContainer()
        let sut = SimpleContainer(containers: [singletonContainer], logger: Logger())
        try singletonContainer.register(dependencyType: SomeDependency.self) { _ in
            return SomeConcreteClass()
        }
        try sut.register(dependencyType: DependencyA.self) { resolver in
            let someDependency: SomeDependency = try resolver.resolve()
            return DependencyAImp(someDependency: someDependency)
        }

        let result: DependencyA = try sut.resolve()
        #expect("Empty" == result.someValue)
    }
}
