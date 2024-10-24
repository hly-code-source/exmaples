//
//  DetailView.swift
//  TestSwiftExample
//
//  Created by helinyu on 2024/10/23.
//

import SwiftUI

// collectionVeiw 的内容显示

struct DetailView: View {
    @State var item = ""
    
    let items = Array(1...30).map { "Item \($0)" } // 示例数据
    let columns = [
        GridItem(.adaptive(minimum: 100)) // 自适应列，最小宽度为100
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            Rectangle() // 模拟图像
                                .fill(Color.blue)
                                .frame(height: 100)
                                .cornerRadius(10)
                            Text(item) // 显示文本
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .navigationTitle("Collection View")
        }
    }
}


#Preview {
    DetailView(item: "item")
}
