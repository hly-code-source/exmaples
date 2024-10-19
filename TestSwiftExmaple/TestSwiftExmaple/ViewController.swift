//
//  ViewController.swift
//  TestSwiftExmaple
//
//  Created by helinyu on 2024/10/19.
//

import UIKit
import SnapKit
import Person

class ViewController: UIViewController {
    
    let view1 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.view1)
        self.view1.backgroundColor = .green
        self.view1.snp.makeConstraints { make in
            make.width.height.equalTo(50)
                      make.center.equalTo(self.view)
        }
        
        let p = Person("你好")
        p.printName()
        
        let l = LoadTestMo("hello")
        l.printName()
        

    }


}

