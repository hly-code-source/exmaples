//
//  OverlayerView.swift
//  TestSwiftUI
//
//  Created by helinyu on 2024/10/24.
//

//import SwiftUI

//struct OverlayerView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

import SwiftUI

struct OverlayerView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .overlay(
//                RoundedRectangle(cornerRadius: 0)
//                    .stroke(style: StrokeStyle(lineWidth: 4))
//                    .padding(4)
//                    .foregroundColor(.blue.opacity(0.5))
                Rectangle()
                    .stroke(Color.red, lineWidth: 50)
                    .padding(25)
            )
    }
}


#Preview {
    OverlayerView()
}


