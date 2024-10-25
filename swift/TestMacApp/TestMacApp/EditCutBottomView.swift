//
//  test.swift
//  TestMacApp
//
//  Created by helinyu on 2024/10/25.
//

import SwiftUI

struct EditCutBottomView: View {
    var body: some View {
        HStack {
        if let squareImg = NSImage(systemSymbolName: "square", accessibilityDescription: nil) {
                    Image(nsImage: squareImg) // 转换为 SwiftUI Image
                        .resizable() // 可调整大小
                        .scaledToFit() // 保持比例
                        .frame(width: 20, height: 20) // 设置框架
                        .foregroundColor(.white)
                        .padding(10)
                        .onTapGesture {
                            print("点击了矩形")
                        }
                        
            }

            if let circleImg = NSImage(systemSymbolName: "circle", accessibilityDescription: nil) {
                Image(nsImage: circleImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .onTapGesture {
                        
                    }
            }
            if let arrowImg = NSImage(systemSymbolName: "arrow.up.forward", accessibilityDescription: nil) {
                Image(nsImage: arrowImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .onTapGesture {
                        
                    }
            }
            if let lineImg = NSImage(systemSymbolName: "pencil.line", accessibilityDescription: nil) {
                Image(nsImage: lineImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .onTapGesture {
                        
                    }
            }
            if let TImg = NSImage(systemSymbolName: "t.square.fill", accessibilityDescription: nil) {
                Image(nsImage: TImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .onTapGesture {
                        
                    }
            }
            Divider()
                .frame(width: 2, height: 30)  // 设置分割线的高度
                .background(Color.black.opacity(0.3))  // 设置分割线的颜色
            if let xImg = NSImage(systemSymbolName: "xmark", accessibilityDescription: nil) {
                Image(nsImage: xImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .onTapGesture {
                        
                    }
            }
            if let downloadImg = NSImage(systemSymbolName: "square.and.arrow.down", accessibilityDescription: nil) {
                Image(nsImage: downloadImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .onTapGesture {
                        
                    }
            }
            
        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .background(Color.black.opacity(0.7))
    }
}

#Preview {
    EditCutBottomView()
}

//struct EditCutBottomView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCutBottomView()
//    }
//}
