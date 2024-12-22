import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                // 首页 Tab
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("首页")
                    }
                
                // 搜索 Tab
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("搜索")
                    }
                
                // 通知 Tab
                NotificationsView()
                    .tabItem {
                        Image(systemName: "bell.fill")
                        Text("通知")
                    }
                
                // 我的 Tab
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("我的")
                    }
            }
            .navigationTitle("首页") // 默认的导航栏标题
            .navigationBarTitleDisplayMode(.inline) // 控制导航栏样式
        }
    }
}

// 首页视图
struct HomeView: View {
    var body: some View {
        VStack {
            Text("这是首页内容")
                .font(.largeTitle)
                .padding()
            
            // 跳转按钮
            NavigationLink(destination: DetailView(title: "首页详情")) {
                Text("跳转到详情页")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

// 搜索视图
struct SearchView: View {
    var body: some View {
        VStack {
            Text("这是搜索页内容")
                .font(.largeTitle)
                .padding()
            
            // 跳转按钮
            NavigationLink(destination: ChatView()) {
                Text("跳转到详情页")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
}

// 通知视图
struct NotificationsView: View {
    @State private var showFullScreen = false
    var body: some View {
        VStack {
            Button("全屏显示模态视图") {
               showFullScreen = true
           }
           .fullScreenCover(isPresented: $showFullScreen) {
               FullScreenModalView()
           }
        }
    }
}

// 我的页面视图
struct ProfileView: View {
    @State private var showModal = false

    var body: some View {
        VStack {
            Button("显示模态视图") {
                         showModal = true
                     }
                     .sheet(isPresented: $showModal) {
                         ModalView() // 模态视图内容
                     }
        }
    }
}

struct ModalView: View {
    var body: some View {
        VStack {
            Text("这是模态视图")
                .font(.largeTitle)
                .padding()

            Button("关闭") {
                // 关闭模态视图由父视图的状态控制
                
            }
            .font(.headline)
            .padding()
        }
    }
}

struct FullScreenModalView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("这是全屏模态视图")
                .font(.largeTitle)
                .padding()

            Button("关闭") {
                dismiss() // 使用环境变量关闭模态视图
            }
            .font(.headline)
            .padding()
        }
    }
}

// 详情视图
struct DetailView: View {
    var title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle(title) // 设置详情页的导航栏标题
    }
}
