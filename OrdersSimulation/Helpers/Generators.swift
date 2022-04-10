//
//  Generators.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 09/04/2022.
//

import Foundation

import GameplayKit

class SeededRandomNumberGenerator : RandomNumberGenerator {
    let range: ClosedRange<Double> = Double(UInt64.min) ... Double(UInt64.max)
    init(seed: Int) {
        // srand48() — Pseudo-random number initializer
        srand48(seed)
    }
    func next() -> UInt64 {
        // drand48() — Pseudo-random number generator
        return UInt64(range.lowerBound + (range.upperBound - range.lowerBound) * drand48())
    }
    
}

extension Double {

    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }

    static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

class TriangularGenerator {
    let from: Double
    let mean: Double
    let to: Double
    var seeder: SeededRandomNumberGenerator
    
    internal init(from: Double, mean: Double, to: Double, seeder: SeededRandomNumberGenerator) {
        self.from = from
        self.mean = mean
        self.to = to
        self.seeder = seeder
    }
    
    func next()-> Double {
        let fc = (mean - from) / (to - from)
        let random = Double.random(in: 0...1, using: &seeder)
         if( random < fc) {
             return from + sqrt(random * (to - from) * (mean - from))
        } else {
            return to - sqrt((1 - random) * (to - from) * (to - mean))
        }

    }
    
}
