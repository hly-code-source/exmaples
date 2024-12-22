//
//  TestViewController.swift
//  TESTUI
//
//  Created by helinyu on 2024/10/21.
//

import UIKit
import SwiftUI


// 将 UIKit 的视图控制器嵌入 SwiftUI
struct UIKitViewController: UIViewControllerRepresentable {
    // 使用 SwiftUI 的上下文创建和配置 UIKit 控制器
    func makeUIViewController(context: Context) -> some UIViewController {
        // 这里可以是你想要的任何 UIKit 视图控制器
        return TestViewController() // 自定义的 UIViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 可以在需要时更新视图控制器的状态
    }
}


class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .green

        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        btn.backgroundColor = .purple
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
        @objc func buttonTapped() {
           print("Button was tapped!")
            let swiftUIView = MySwiftUIView()
            let hostingController = UIHostingController.init(rootView: swiftUIView)
            self.present(hostingController, animated:true)
//            self.navigationController?.pushViewController(hostingController, animated: true)
//            self.navigationController?.pushViewController(ViewController(), animated: true)
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
