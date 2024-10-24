import ScreenCaptureKit
import Cocoa
import FileKit
import VarExtension

class ScreenCapture {
    
    func captureScreenImage() async {
        SCShareableContent.getExcludingDesktopWindows(false, onScreenWindowsOnly: false) { content, error in
            if let error = error {
                switch error {
                case SCStreamError.userDeclined: Auth.requestPermissions()
                default: print("Error: failed to fetch available content: ", error.localizedDescription)
                }
                return
            }
            
            guard let displays = content?.displays else {
                return
            }
            let display: SCDisplay = displays.first!
            let contentFilter = SCContentFilter(display: display, excludingWindows: [])
            let configuration = SCStreamConfiguration()
            configuration.width = display.width
            configuration.height = display.height
            SCScreenshotManager.captureImage(contentFilter: contentFilter, configuration: configuration) { image, error in
                print("lt -- image : eror : %@", error.debugDescription)
                guard let img = image else {
                    print(" : %@", error.debugDescription)
                    return
                }
                self.saveImageToFile(img)
            }
        }
    }

    @MainActor private func saveImageToFile(_ image: CGImage) {
        let imgName = Date.getNameByDate()
        let curPath = "file://" + VarExtension.createTargetDirIfNotExit() + imgName + ".png"
        let destinationURL: CFURL = URL(string: curPath)! as CFURL
        let destination = CGImageDestinationCreateWithURL(destinationURL, kUTTypePNG, 1, nil)
        guard let destination = destination else {
            print("保存路径没有创建成功")
            return
        }
        CGImageDestinationAddImage(destination, image, nil)
        
        if CGImageDestinationFinalize(destination) {
            print("保存成功路径: \(destinationURL)")
        } else {
            print("保存失败")
        }
    }
}




