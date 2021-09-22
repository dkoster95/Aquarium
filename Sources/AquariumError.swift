//
//  AquariumError.swift
//  Aquarium
//
//  Created by Daniel Koster on 9/17/21.
//

import Foundation

public enum AquariumError: Error {
    case dependencyNotRegistered
    case dependencyAlreadyRegistered
}
