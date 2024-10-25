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
//    @AppStorage("selectedNumber") var selectedNumber: Int = 12
//
//    var body: some View {
//        VStack {
//            Text("选择一个数字: \(selectedNumber)")
//                .font(.largeTitle)
//
//            
//        }
//        .padding()
//    }
//}

//struct ContentView: View {
//    @State private var selectedDate = Date()  // 初始日期为当前日期
//
//    var body: some View {
//        VStack {
//            Text("选择的日期: \(formattedDate)")
//                .font(.largeTitle)
//                .padding()
//
//            DatePicker("选择日期", selection: $selectedDate, displayedComponents: [.date])
//                .datePickerStyle(GraphicalDatePickerStyle())  // 设置样式
//                .padding()
//
//            Spacer()
//        }
//        .padding()
//    }
//
//    // 格式化日期为字符串
//    private var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium  // 设置日期样式
//        return formatter.string(from: selectedDate)
//    }
//}

//struct ContentView: View {
//    @State private var selectedNumber: Int = 0  // 初始值
//
//    var body: some View {
//        VStack {
//            Text("当前选择的数字: \(selectedNumber)")
//                .font(.largeTitle)
//                .padding()
//
//            Stepper("选择数字: \(selectedNumber)", value: $selectedNumber, in: 0...100)
//                .padding()  // 设置边距
//
//            Spacer()
//        }
//        .padding()
//    }
//}

//struct ContentView: View {
//    @State private var sliderValue: Double = 50.0  // 初始值
//
//    var body: some View {
//        VStack {
//            Text("当前值: \(Int(sliderValue))")  // 显示当前值
//                .font(.largeTitle)
//                .padding()
//
//            Slider(value: $sliderValue, in: 0...100, step: 1.0)  // 设置 Slider 范围和步长
//                .padding()
//
//            Spacer()
//        }
//        .padding()
//    }
//}


//struct ContentView: View {
//    @State private var selectedSegment = 0
//    let options = ["选项 1", "选项 2", "选项 3"]
//
//    var body: some View {
//        VStack {
//            Text("当前选择: \(options[selectedSegment])")
//                .font(.largeTitle)
//                .padding()
//
//            Picker("选择一个选项", selection: $selectedSegment) {
//                ForEach(0..<options.count) { index in
//                    Text(options[index]).tag(index)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//
//            Spacer()
//        }
//        .padding()
//    }
//}


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

#Preview {
    ContentView()
}
