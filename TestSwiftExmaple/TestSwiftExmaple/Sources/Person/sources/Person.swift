//
//  Person.swift
//  TestSwiftExmaple
//
//  Created by helinyu on 2024/10/19.
//

import Foundation

public class Person {
    var name:String
    
    public init(_ name: String) {
        self.name = name
    }

    public func printName() {
        print("名字: \(name)")
    }
}
