//
//  AquariumTests.swift
//  AquariumTests
//
//  Created by Daniel Koster on 9/17/21.
//

import Testing
import Aquarium

public protocol SomeProtocol {
    func showValue(val: String)
}

struct AquariumTests {
    
    func setUp(aquariums: [AquariumDependencyProvider] = []) -> (sut: Aquarium,
                     singletonContainerMock: ContainerMock,
                     simpleContainerMock: ContainerMock) {
        let singletonMock = ContainerMock()
        let simpleMock = ContainerMock()
        return (Aquarium(containers: [.singleton: singletonMock,
                                      .simple: simpleMock],
                         aquariums: aquariums,
                         logger: Logger()),
                singletonMock,
                simpleMock)
    }
    
    @Test func test_whenRegisteringDependency_errorThrown() throws {
        let (sut, singletonMock, _) = setUp()
        
        singletonMock.errorThrown = AquariumError.dependencyAlreadyRegistered
        #expect(throws: AquariumError.dependencyAlreadyRegistered) {
            try sut.register(dependencyType: SomeDependency.self, registration: { _ in
                return SomeConcreteClass() },
                             with: .singleton)
        }
    }

    
    @Test func test_whenRegisteringDependencyProtoypeWithError_expectError() {
        let (sut, _, simpleMock) = setUp()
        simpleMock.errorThrown = AquariumError.dependencyAlreadyRegistered
        #expect(throws: AquariumError.dependencyAlreadyRegistered) {
            try sut.register(dependencyType: SomeDependency.self, registration: { _ in
                return SomeConcreteClass() },
                             with: .simple)
        }
    }
    
    @Test func test_whenRegisteringDependencyOk_expectNoError() throws {
        let (sut, singletonMock, _) = setUp()
        
        try sut.register(dependencyType: SomeDependency.self, registration: { _ in
            return SomeConcreteClass() },
                         with: .singleton)
        
        #expect(singletonMock.registerCount == 1)
    }
    
    @Test func test_whenRegisteringPrototypeDependencyOk_expectNoError() throws {
        let (sut, _, simpleMock) = setUp()
        
        try sut.register(dependencyType: SomeDependency.self, registration: { _ in
            return SomeConcreteClass() },
                         with: .simple)
        
        #expect(simpleMock.registerCount == 1)
    }
    
    @Test func test_whenResolvingUnexistentDependencyPrototype_expectError() throws {
        let (sut, singletonMock, simpleMock) = setUp()
        singletonMock.errorThrown = AquariumError.dependencyNotRegistered
        simpleMock.errorThrown = AquariumError.dependencyNotRegistered
        #expect(throws: AquariumError.dependencyNotRegistered) {
            let _: SomeProtocol = try sut.resolve()
        }
    }
    
    @Test func test_whenResolvingExistentDependencyPrototype_expectError() throws {
        let (sut, singletonMock, _) = setUp()
        singletonMock.resolveResult = SomeConcreteClass()
        
        try sut.register(dependencyType: SomeDependency.self,
                         registration: { container -> SomeDependency in
                                            return SomeConcreteClass() },
                                          with: .singleton)
        let _: SomeDependency = try sut.resolve()
        
        #expect(singletonMock.resolveCount == 1)
    }
    
    @Test func test_whenResolvingMultipleDependencies() throws {
        let (secondaryAquarium, secondarySingleton, secondarySimple) = setUp()
        let (sut, singletonMock, simpleMock) = setUp(aquariums: [secondaryAquarium])
        secondarySimple.resolveResult = SomeConcreteClass()
        
        try secondaryAquarium.register(dependencyType: SomeDependency.self,
                                       registration: { container in
            return SomeConcreteClass() },
                                       with: .singleton)
        secondarySingleton.errorThrown = AquariumError.dependencyNotRegistered
        singletonMock.errorThrown = AquariumError.dependencyNotRegistered
        simpleMock.errorThrown = AquariumError.dependencyNotRegistered
        let _: SomeDependency = try sut.resolve()
        
        #expect(secondarySimple.resolveCount == 1)
    }

}
