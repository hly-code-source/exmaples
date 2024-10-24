//
//  RectangleTest.swift
//  TestSwiftUI
//
//  Created by helinyu on 2024/10/24.
//

import SwiftUI

struct RectangleTestView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: 200, height: 50)
            .cornerRadius(10)
            .overlay(Text("点击我").foregroundColor(.white))
            .onTapGesture {
                print("Button tapped!")
            }

    }
}


#Preview {
    RectangleTestView()
}
