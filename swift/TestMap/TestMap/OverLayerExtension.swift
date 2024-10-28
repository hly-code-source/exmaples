//
//  OverLayerExtension.swift
//  TestMap
//
//  Created by helinyu on 2024/10/26.
//

import Foundation
import AppKit
import SwiftUI

enum ResizeHandle: CaseIterable {
    case none
    case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
}

enum SelectedColorHandle: String, CaseIterable, Identifiable {
    case red, yellow, green, blue, gray, white
    var id: Self { self }
    var value: NSColor {
           switch self {
           case .red:
               return NSColor.red
           case .yellow:
               return NSColor.yellow
           case .green:
               return NSColor.green
           case .blue:
               return NSColor.blue
           case .gray:
               return NSColor.gray
           case .white:
               return NSColor.white
           }
       }
    
    var swiftColor : Color {
        switch self {
        case .red:
            return Color.red
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .gray:
            return Color.gray
        case .white:
            return Color.white
        }
    }
}

enum EditCutBottmType: CaseIterable,Identifiable {
    
    case none
    case square, circle, arrow, doodle, text
    
    static var allCases: [EditCutBottmType] = [square, circle, arrow, doodle, text]
    
    var id: Self { self }

    var imgName: String {
        switch self {
        case .square:
            return "square"
        case .circle:
            return "circle"
        case .arrow:
            return "arrow.up.forward"
        case .doodle:
            return "pencil.line"
        case .text:
            return "t.square.fill"
        default:
            return ""
        }
    }
    
}

enum LineWidthType: Int, CaseIterable, Identifiable {
    
    case Two = 2
    case Four = 4
    case Six = 6
    
    var id: Self { self }
    
    var imgName: String {
        switch self {
        case .Two:
            return "circlebadge.fill"
        case .Four:
            return "circlebadge.fill"
        case .Six:
            return "circlebadge.fill"
        default:
            return ""
        }
    }
    
}
