//
//  PrototypeContainerTests.swift
//  AquariumTests
//
//  Created by Daniel Koster on 9/21/21.
//

import XCTest
import Aquarium

class PrototypeContainerTests: XCTestCase {

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
}
