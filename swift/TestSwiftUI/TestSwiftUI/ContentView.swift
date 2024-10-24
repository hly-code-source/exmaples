//
//  ContentView.swift
//  TestSwiftUI
//
//  Created by helinyu on 2024/10/23.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}

//struct ContentView: View {
//    var body: some View {
//        ZStack {
//            Color.red // 最底层
//            Image(systemName: "star.fill") // 中间层
//                .resizable()
//                .frame(width: 100, height: 100)
//                .foregroundColor(.yellow)
//            Text("Hello, ZStack!") // 最上层
//                .foregroundColor(.white)
//                .padding()
//        }
//
//    }
//}
//
//struct ContentView: View {
//    @AppStorage("username") var username: String = "Guest"
//
//    var body: some View {
//        VStack {
//            Text("Hello, \(username)!")
//            TextField("Enter your name", text: $username)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//        }
//        .padding()
//    }
//}

//struct ContentView: View {
//    @State private var count: Int = 0
//
//    var body: some View {
//        VStack {
//            Text("Count: \(count)")
//            Button("Increment") {
//                count += 1
//            }
//        }
//        .padding()
//    }
//}


class Model: ObservableObject {
    @Published var text: String = "Hello"
}

struct ContentView: View {
    @ObservedObject var model = Model()
    
    var body: some View {
        VStack {
            ChildView(text: $model.text).padding()
            Label(model.text, systemImage: "star.fill")
                          .font(.title)
        }.padding().background(.red)
       

    }
}


#Preview {
    ContentView()
}
