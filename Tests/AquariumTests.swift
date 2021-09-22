//
//  AquariumTests.swift
//  AquariumTests
//
//  Created by Daniel Koster on 9/17/21.
//

import XCTest
@testable import Aquarium

public protocol SomeProtocol {
    func showValue(val: String)
}
class AquariumTests: XCTestCase {

    private var sut: Aquarium!
    private let singletonMock = ContainerMock()
    private let prototypeMock = ContainerMock()
    
    override func setUp() {
        sut = Aquarium(singletonContainer: singletonMock, prototypeContainer: prototypeMock)
    }
    
    func test_whenRegisteringDependency_errorThrown() throws {
        singletonMock.errorThrown = AquariumError.dependencyAlreadyRegistered
        XCTAssertThrowsError(try sut.register(registration: { _ -> SomeDependency in
                                            return SomeConcreteClass() },
                                          with: .singleton))
    }
    
    func test_whenRegisteringDependencyProtoypeWithError_expectError() {
        prototypeMock.errorThrown = AquariumError.dependencyAlreadyRegistered
        XCTAssertThrowsError(try sut.register(registration: { _ -> SomeDependency in
                                            return SomeConcreteClass() },
                                          with: .prototype))
    }
    
    func test_whenRegisteringDependencyOk_expectNoError() throws {
        XCTAssertNoThrow(try sut.register(registration: { _ -> SomeDependency in
                                            return SomeConcreteClass() },
                                          with: .singleton))
    }
    
    func test_whenRegisteringPrototypeDependencyOk_expectNoError() throws {
        XCTAssertNoThrow(try sut.register(registration: { _ -> SomeDependency in
                                            return SomeConcreteClass() },
                                          with: .prototype))
    }
    
    func test_whenResolvingUnexistentDependencyPrototype_expectError() throws {
        singletonMock.errorThrown = AquariumError.dependencyAlreadyRegistered
        prototypeMock.errorThrown = AquariumError.dependencyAlreadyRegistered
        if let _: SomeProtocol = try? sut.resolve() {
            XCTAssert(false)
        }
    }
    
//    func test_whenResolvingExistentDependencyPrototype_expectError() throws {
//        try sut.register(registration: { container -> SomeDependency in
//                                            return SomeConcreteClass() },
//                                          with: .singleton)
//        let result: SomeDependency = try sut.resolve()
//        
//    }

}
