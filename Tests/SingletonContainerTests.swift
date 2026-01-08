//
//  SingletonContainerTests.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/21/21.
//

import Testing
import Aquarium

extension SimpleContainer {
    convenience init() {
        self.init(logger: Logger())
    }
}

class SingletonContainerTests {

    @Test func test_WhenDependencyExistentIsRegistered_ExpectDependencyRegisteredError() throws {
        let sut = SingletonContainer()
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
        let sut = SingletonContainer()
        try sut.register(dependencyType: SomeDependency.self) { _ in
            return SomeConcreteClass()
        }
        
        let result: SomeDependency = try sut.resolve()
        result.someDependencyMethod(value: "value")
        #expect("value" == result.someValue)
    }
    
    @Test func test_WhenDependencyIsRegistered_ExpectSameInstanceToBeResolved() throws {
        let sut = SingletonContainer()
        try sut.register(dependencyType: SomeDependency.self) { _ in
            return SomeConcreteClass()
        }
        
        let result: SomeDependency = try sut.resolve()
        let resolveDependency: SomeDependency = try sut.resolve()
        #expect(result === resolveDependency)
    }
    
    @Test func test_WhenDependencyIsRegisteredUnderClassType_ExpectProtocolNotToBeResolved() throws {
        let sut = SingletonContainer()
        try sut.register(dependencyType: SomeConcreteClass.self) { _ in
            return SomeConcreteClass()
        }
        #expect(throws: AquariumError.dependencyNotRegistered) {
            let _: SomeDependency = try sut.resolve()
        }
        let result: SomeConcreteClass = try sut.resolve()
        result.someDependencyMethod(value: "value")
        #expect("value" == result.someValue)
    }
}

internal protocol SomeDependency: AnyObject {
    func someDependencyMethod(value: String)
    var someValue: String { get }
}

internal class SomeConcreteClass: SomeDependency {
    
    private var previousVal = "Empty"
    var someValue: String { previousVal }
    
    func someDependencyMethod(value: String) {
        previousVal = value
    }
}

protocol DependencyA {
    var someValue: String { get }
}

class DependencyAImp: DependencyA {
    let someDependency: SomeDependency
    init(someDependency: SomeDependency) {
        self.someDependency = someDependency
    }
    var someValue: String { someDependency.someValue }
}
