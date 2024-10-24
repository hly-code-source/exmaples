//
//  ScreenSelector.swift
//  VCB
//
//  Created by helinyu on 2024/10/23.
//

import SwiftUI
import ScreenCaptureKit

struct ScreenSelector: View {
    @StateObject var viewModel = ScreenSelectorViewModel()
    
    var body: some View {
        ZStack {
           
        }.frame(width: 780, height:555)
    }
    
    func startRecording() {
    }
}

class ScreenSelectorViewModel: NSObject, ObservableObject, SCStreamDelegate, SCStreamOutput {
    @Published var screenThumbnails = [ScreenThumbnail]()
    private var allScreens = [SCDisplay]()
    private var streams = [SCStream]()
    
    override init() {
        super.init()
    }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
    }

    func setupStreams() {
    }
}

class ScreenThumbnail {
    let image: NSImage
    let screen: SCDisplay

    init(image: NSImage, screen: SCDisplay) {
        self.image = image
        self.screen = screen
    }
}
