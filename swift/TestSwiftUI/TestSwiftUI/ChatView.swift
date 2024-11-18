import SwiftUI

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isSentByUser: Bool
    let avatar: String // 头像图片的名字
}

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .center) {
            // 如果是接收者消息，头像位于左侧，反之右侧
            if !message.isSentByUser {
                // 接收者头像和三角形
                Image(message.avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle()) // 圆形头像
                    .background(.black)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))  // 给头像添加白色边框
                       .shadow(radius: 10)  // 给头像添加阴影
                HStack(spacing: 0.0) {
                    // 指向头像的三角形
                    Triangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 15, height: 15)
                        .rotationEffect(.degrees(-90)) // 翻转三角形指向左边
                        .offset(x: 0, y: -7) // 调整三角形位置
                    
                    // 消息气泡
                    Text(message.text)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
            } else {
                // 发送者头像和三角形
                Spacer()
                
                HStack(alignment:.center,spacing: 0) {
                    // 消息气泡
                    Text(message.text)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10.0)
                    
                    Triangle()
                        .fill(Color.blue)
                        .frame(width: 15, height: 15)
                        .rotationEffect(.degrees(90))
                        .offset(x: 0, y: -7)
                }
                
                // 发送者头像
                Image(message.avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle()) // 圆形头像
                    .padding(.bottom, 5)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 4))  // 给头像添加白色边框
                   .shadow(radius: 10)  // 给头像添加阴影
            }
        }
        .padding(.vertical, 5)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))  // 顶部
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // 左下
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // 右下
        path.closeSubpath()
        return path
    }
}

struct ChatView: View {
    @State private var messages: [Message] = [
        Message(text: "你好！", isSentByUser: false, avatar: "receiver_avatar"),
        Message(text: "你好，有什么可以帮您的吗？", isSentByUser: true, avatar: "sender_avatar")
    ]
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            // 消息列表
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .frame(maxWidth: .infinity, alignment: message.isSentByUser ? .trailing : .leading)
                                .padding(message.isSentByUser ? .trailing : .leading, 10)
                        }
                    }
                }
                .onChange(of: messages) { _ in
                    // 自动滚动到底部
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // 输入框
            HStack {
                TextField("输入消息...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                
                Button(action: sendMessage) {
                    Text("发送")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        let newMessage = Message(text: inputText, isSentByUser: true, avatar: "sender_avatar")
        messages.append(newMessage)
        inputText = ""
        
        // 模拟对方回复
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let reply = Message(text: "收到：\(newMessage.text)", isSentByUser: false, avatar: "receiver_avatar")
            messages.append(reply)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
