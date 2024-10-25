//
//  ContentView.swift
//  TestMacApp
//
//  Created by helinyu on 2024/10/24.
//

import SwiftUI
import FileKit

struct ContentView: View {
    var body: some View {
        VStack {
            Button("保存图片") {
                Task {
                    await ScreenCut().captureScreenImage()
                }
            }
            
            Button("显示蒙版") {
                Task {
                    AppDelegate.shared.showAreaSelector(size: NSSize(width: 600, height: 450))
                }
            }
        }
        .padding()
    }
}

//struct ContentView: View {
//    var body: some View {
//        Text("悬停在这里")
//            .padding()
//            .background(Color.blue.opacity(0.3))
//            .cornerRadius(8)
//            .onHover { hovering in
//                if hovering {
////                    NSCursor.pen.set()  // 设置手形光标
//                    NSCursor.init(image: NSImage(size: NSSize(width: 20, height: 20)), hotSpot: NSPoint(x: 20, y: 20))
//                } else {
//                    NSCursor.arrow.set()  // 恢复为默认光标
//                }
//            }
//            .frame(width: 200, height: 100)
//    }
//}


