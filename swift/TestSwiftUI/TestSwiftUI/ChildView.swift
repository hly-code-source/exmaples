//
//  ChildView.swift
//  TestSwiftUI
//
//  Created by helinyu on 2024/10/23.
//

import SwiftUI

struct ChildView: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Enter text", text: $text)
    }
}

//#Preview {
////    ChildView(text: "你好")
//    ChildView(text: <#T##Binding<String>#>)
//}
