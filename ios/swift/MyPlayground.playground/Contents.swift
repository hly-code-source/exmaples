//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport
import Combine
import SwiftUI

let name:String? = nil
print("lt -- count :\(String(describing: name?.count))")
if (name?.count ?? 0 > 0) {
    print("lt count \(String(describing: name?.count))")
}
else {
    print("lt --")
}
