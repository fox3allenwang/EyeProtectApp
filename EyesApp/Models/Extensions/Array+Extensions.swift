//
//  Array+Extensions.swift
//  EyesApp
//
//  Created by Leo Ho on 2023/12/9.
//

import Foundation

public extension Array where Element: FloatingPoint {
    
    var sum: Element {
        return reduce(0, +)
    }

    var average: Element {
        guard !isEmpty else {
            return 0
        }
        return sum / Element(count)
    }

}
