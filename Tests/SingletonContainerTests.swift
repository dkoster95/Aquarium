//
//  SingletonContainerTests.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/21/21.
//

import XCTest
import Aquarium

class SingletonContainerTests: XCTestCase {
    
    private var sut: SingletonContainer!
    
    override func setUp() {
        sut = SingletonContainer()
    }

    func test_WhenDependencyExistentIsRegistered_ExpectDependencyRegisteredError() throws {
        try sut.register { _ -> SomeDependency in
            return SomeConcreteClass()
        }
        XCTAssertThrowsError(try sut.register { _ -> SomeDependency in
            return SomeConcreteClass()
        })
    }
    
    func test_WhenDependencyIsRegistered_ExpectDependencyToBeResolved() throws {
        try sut.register { _ -> SomeDependency in
            return SomeConcreteClass()
        }
        
        let result: SomeDependency = try sut.resolve()
        result.someDependencyMethod(value: "value")
        XCTAssertEqual("value", result.someValue)
    }
    
    func test_WhenDependencyIsRegistered_ExpectSameInstanceToBeResolved() throws {
        try sut.register { _ -> SomeDependency in
            return SomeConcreteClass()
        }
        
        let result: SomeDependency = try sut.resolve()
        let resolveDependency: SomeDependency = try sut.resolve()
        XCTAssert(result === resolveDependency)
    }
    
    func test_WhenDependencyIsRegisteredUnderClassType_ExpectProtocolNotToBeResolved() throws {
        try sut.register { _ in
            return SomeConcreteClass()
        }
        if let _: SomeDependency = try? sut.resolve() {
            XCTAssert(false)
        }
        let result: SomeConcreteClass = try sut.resolve()
        result.someDependencyMethod(value: "value")
        XCTAssertEqual("value", result.someValue)
    }
}

internal protocol SomeDependency: class {
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
