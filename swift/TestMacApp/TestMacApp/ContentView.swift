//
//  ContentView.swift
//  TestMacApp
//
//  Created by helinyu on 2024/10/24.
//

import SwiftUI
import FileKit
import VarExtension

struct ContentView: View {
    var body: some View {
        VStack {
            Button("你好点击我把") {
                Task {
                    await ScreenCapture().captureScreenImage()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
