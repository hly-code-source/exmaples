import SwiftUI
import Cocoa
import UserNotifications

struct ContentView: View {

    var body: some View {
        HStack {
            Button(action: {
//                AppDelegate.showAreaSelector()
            }, label: {
                VStack{
                    Image(systemName: "record.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.red)
                    Text("Start")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 12))
                }
            }).buttonStyle(.plain)
            
            Button(action: {
//                AppDelegate.showAreaSelector()
            }, label: {
                VStack{
                    Image(systemName: "record.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.red)
                    Text("关闭")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 12))
                }
            }).buttonStyle(.plain)
        }
        .frame(width: 400, height: 400)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

var rootWindow : ScreenshotWindow?

@main
struct MyApp: App {
        
    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
    
    var body: some Scene {
        MenuBarExtra("", systemImage: "record.circle.fill"){
            Button("选择截屏") {
                rootWindow = ScreenshotWindow()
                rootWindow!.makeKeyAndOrderFront(nil)
            }
            .keyboardShortcut("x", modifiers: [.control])
            .padding()
            Divider()
            Button("在View上编辑") {
//                OverlayWindowController().showWindow(NSScreen.main)
                // 添加进去新的子view
                
//                let subLay =  ScreenshotCircleOverlayView(frame: self.selectionRect!, size:NSSize.zero)
//                subLay.fillOverLayeralpha = 0.2
//                self.addSubview(subLay)
//                subLay.wantsLayer = true;
//                subLay.layer?.masksToBounds = true
            }
            .keyboardShortcut("c", modifiers: [.control])
            .padding()
            Divider()
            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("Q", modifiers: [.command])
        }
        
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 请求通知权限
        requestNotificationPermission()
        
        // 发送测试通知
        sendTestNotification()
    }

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("权限已授予")
            } else {
                print("权限未授予: \(error?.localizedDescription ?? "未知错误")")
            }
        }
    }

    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "测试通知"
        content.body = "这是一个测试通知的内容。"
        content.sound = UNNotificationSound.default
        
        // 创建触发器（可以是立即发送）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // 创建请求
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // 添加请求到通知中心
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("发送通知时出错: \(error.localizedDescription)")
            }
        }
    }
}
