//
//  test.swift
//  TestMacApp
//
//  Created by helinyu on 2024/10/25.
//

import SwiftUI

struct EditCutBottomView: View {
    var body: some View {
        VStack {
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
                    
            }.frame(height: 40.0)
            SecondEditView()
        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .background(Color.black.opacity(0.7))
            .frame(width: 350.0 )
            .frame(maxWidth: .infinity)
    }
}

struct SecondEditView: View {
    var isText: Bool = false
    @AppStorage("text-font-size") var selectedNumber: Int = 12
    var body: some View {
        HStack {
            if isText {
                HStack {
                    Stepper("文字: \(selectedNumber)", value: $selectedNumber, in: 0...100)
                        .padding()
                        .foregroundColor(.white)
                }.frame(width: 140.0)
            }
            else {
                HStack {
                    if let small1Img = NSImage(systemSymbolName: "smallcircle.filled.circle.fill", accessibilityDescription: nil) {
                        Image(nsImage: small1Img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                            .padding(10)
                            .onTapGesture {
                                
                            }
                    }
                    if let small2Img = NSImage(systemSymbolName: "smallcircle.filled.circle.fill", accessibilityDescription: nil) {
                        Image(nsImage: small2Img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                            .padding(10)
                            .onTapGesture {
                                
                            }
                    }
                    if let small3Img = NSImage(systemSymbolName: "smallcircle.filled.circle.fill", accessibilityDescription: nil) {
                        Image(nsImage: small3Img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                            .onTapGesture {
                                
                            }
                    }
                }.frame(width: 150.0)
            }
           
            HStack {
                Color.red
                    .frame(height: 30.0)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                    
                    }
                
                Color.yellow
                    .frame(height: 30.0)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                    
                    }
                Color.green
                    .frame(height: 30.0)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                    
                    }
                Color.blue
                    .frame(height: 30.0)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                    
                    }
                Color.gray
                    .frame(height: 30.0)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                    
                    }
                Color.white
                    .frame(height: 30.0)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                    
                    }
                
            }.frame(width: 200.0)
        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .background(Color.black.opacity(0.7))
        .frame(width: 350.0 ,height: 40)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SecondEditView()
}

#Preview {
    EditCutBottomView()
}


//struct EditCutBottomView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCutBottomView()
//    }
//}
