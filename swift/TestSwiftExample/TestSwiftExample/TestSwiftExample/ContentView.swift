import SwiftUI

struct ContentView: View {
    @State private var items: [String] = []
    @State private var isLoading = false
    @State private var currentPage = 1
    private let itemsPerPage = 10

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }

                // 添加自定义加载指示器
                if isLoading {
                    LoadingView() // 使用自定义加载视图
                }
            }
            .navigationTitle("Load More List")
            .onAppear(perform: loadInitialItems)
            .onAppear {
                // 监测是否滚动到底部
                DispatchQueue.main.async {
                    loadMoreItems()
                }
            }
            .onChange(of: items) { items in
                if items.count > 0 && !isLoading {
                    loadMoreItems()
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear.onAppear {
                    // 检测滚动到达底部
                    let threshold = geometry.size.height
                    if geometry.frame(in: .global).maxY < threshold {
                        loadMoreItems()
                    }
                }
            }
        )
    }

    // 加载初始数据
    private func loadInitialItems() {
        loadItems()
    }

    // 加载更多数据
    private func loadMoreItems() {
        guard !isLoading else { return }
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 模拟延迟
            loadItems()
            isLoading = false
        }
    }

    // 从数据源加载项目
    private func loadItems() {
        let newItems = (1...itemsPerPage).map { "Item \($0 + (currentPage - 1) * itemsPerPage)" }
        items.append(contentsOf: newItems)
        currentPage += 1
    }
}

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                ProgressView()
                Text("Loading more items...")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}
// 生成列表、上啦刷新了

//import SwiftUI
//
//struct ContentView: View {
//    @State private var isLoading = false
//
//    var body: some View {
//        VStack {
//            // 菊花旋转视图
//            LoadingSpinner(isLoading: isLoading)
//
//            // 按钮控制加载状态
//            Button(action: {
//                isLoading.toggle()
//            }) {
//                Text(isLoading ? "Stop Loading" : "Start Loading")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .padding()
//    }
//}

//struct LoadingSpinner: View {
//    @State var rotation: Double = 0
//    var isLoading: Bool
//
//    var body: some View {
//        if isLoading {
//            Circle()
//                .stroke(lineWidth: 5)
//                .foregroundColor(.blue)
//                .frame(width: 50, height: 50)
//                .rotationEffect(.degrees(rotation))
//                .onAppear {
//                    // 创建旋转动画
//                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
//                        rotation = 360
//                    }
//                }
//                .transition(.scale)
//        } else {
//            // 在不加载时隐藏视图
//            EmptyView()
//        }
//    }
//}

#Preview {
    ContentView()
}
