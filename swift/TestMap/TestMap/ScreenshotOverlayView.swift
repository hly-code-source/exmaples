import Foundation
import SwiftUI
import ScreenCaptureKit
import AppKit

class ScreenshotOverlayView: NSView {
    
    var selectionRect: NSRect?
    var initialLocation: NSPoint?
    var dragIng: Bool = false
    var activeHandle: ResizeHandle = .none
    var lastMouseLocation: NSPoint?
    var maxFrame: NSRect?
    var size: NSSize
    let controlPointDiameter: CGFloat = 8.0
    let controlPointColor: NSColor = NSColor.white
    var fillOverLayeralpha: CGFloat = 0.5 // 默认值
    var editViewFinshed: Bool = false // 默认是编辑当前的页面
    var cutSelectedItem : EditCutBottomShareModel = EditCutBottomShareModel()

   
    
    init(frame: CGRect, size: NSSize, _ editCutSecondItem : EditCutSecondShowModel = EditCutSecondShowModel()) {
        self.size = size
        self.editCutSecondItem = editCutSecondItem;
        super.init(frame: frame)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTypeNotification), name: NSNotification.Name("firstEditType"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorNotification), name: NSNotification.Name("secondEditColor"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSizeNotification), name: NSNotification.Name("secondEditSize"), object: nil)
        
        self.wantsLayer = true
        self.layer?.masksToBounds = true
    }
    
    @objc func handleTypeNotification(_ notification: Notification) {
        print("Received notification: \(notification.name)")
        let item :EditCutBottomShareModel = notification.object as! EditCutBottomShareModel
        cutSelectedItem.cutType = item.cutType
        self.editViewFinshed = true
        editViewFinshed = true
        needsDisplay = true
        self.addCustomSubviews()
    }
    
    @objc func handleColorNotification(_ notification: Notification) {
        print("Received notification: \(notification.name)")
        let item = notification.object as! EditCutBottomShareModel
        self.cutSelectedItem.selectColor = item.selectColor
        self.configSubViewAttr(self.subviews.last!)
    }
    
    @objc func handleSizeNotification(_ notification: Notification) {
        print("Received notification: \(notification.name)")
        let item = notification.object as! EditCutBottomShareModel
        self.cutSelectedItem.sizeValue = item.sizeValue
        self.configSubViewAttr(self.subviews.last!)
    }
    
    func configSubViewAttr(_ view: NSView) {
        var subView:OverlayProtocol = view as! OverlayProtocol
        subView.selectedColor = self.cutSelectedItem.selectColor.value
        subView.lineWidth = self.cutSelectedItem.sizeValue
    }
    
    func addCustomSubviews() {
        var subView: OverlayProtocol?
        switch self.cutSelectedItem.cutType {
        case .square:
            subView = ScreenshotRectangleOverlayView(frame: self.selectionRect!, size:NSSize.zero)
        case .circle:
            subView = ScreenshotCircleOverlayView(frame: self.selectionRect!, size:NSSize.zero)
        case .arrow:
            subView = ScreenshotArrowOverlayView(frame: self.selectionRect!, size:NSSize.zero)
        case .doodle:
            subView = ScreenshotDoodleView(frame: self.selectionRect!, size:NSSize.zero)
        case .text:
            subView = ScreenshotTextView(frame: self.selectionRect!, size:NSSize.zero)
        default:
            break
        }
        guard subView != nil else {
            return
        }

        let curView:NSView = subView as! NSView
        self.addSubview(curView)
        curView.wantsLayer = true;
        curView.layer?.masksToBounds = true
        self.configSubViewAttr(curView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        let trackingArea = NSTrackingArea(rect: self.bounds,
                                          options: [.mouseEnteredAndExited, .mouseMoved, .cursorUpdate, .activeInActiveApp],
                                          owner: self,
                                          userInfo: nil)
        self.addTrackingArea(trackingArea)
        selectionRect = NSRect(x: (self.frame.width - size.width) / 2, y: (self.frame.height - size.height) / 2, width: size.width, height:size.height)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        maxFrame = dirtyRect
        
        NSColor.black.withAlphaComponent(fillOverLayeralpha).setFill()
        dirtyRect.fill()
        
        if (selectionRect!.size.equalTo(CGSize.zero)) {
            return
        }
        
        if let rect = selectionRect {
            // 绘制边框
            let dashedBorder = NSBezierPath(rect: rect)
            dashedBorder.lineWidth = 4.0
            dashedBorder.setLineDash([4.0, 4.0], count: 1, phase: 0.0)// 绘制虚线
            NSColor.white.setStroke()
            dashedBorder.stroke()
            NSColor.init(white: 1, alpha: 0.01).setFill()
            __NSRectFill(rect)
            if (!self.editViewFinshed) {
                // 绘制边框中的点
                for handle in ResizeHandle.allCases {
                    if let point = controlPointForHandle(handle, inRect: rect) {
                        let controlPointRect = NSRect(origin: point, size: CGSize(width: controlPointDiameter, height: controlPointDiameter))
                        let controlPointPath = NSBezierPath(ovalIn: controlPointRect)
                        controlPointColor.setFill()
                        controlPointPath.fill()
                    }
                }
            }
        }
    }
    
    func handleForPoint(_ point: NSPoint) -> ResizeHandle {
        guard let rect = selectionRect else { return .none }
        for handle in ResizeHandle.allCases {
            if let controlPoint = controlPointForHandle(handle, inRect: rect), NSRect(origin: controlPoint, size: CGSize(width: controlPointDiameter, height: controlPointDiameter)).contains(point) {
                return handle
            }
        }
        return .none
    }
    
    func controlPointForHandle(_ handle: ResizeHandle, inRect rect: NSRect) -> NSPoint? {
        switch handle {
        case .topLeft:
            return NSPoint(x: rect.minX - controlPointDiameter / 2 - 1, y: rect.maxY - controlPointDiameter / 2 + 1)
        case .top:
            return NSPoint(x: rect.midX - controlPointDiameter / 2, y: rect.maxY - controlPointDiameter / 2 + 1)
        case .topRight:
            return NSPoint(x: rect.maxX - controlPointDiameter / 2 + 1, y: rect.maxY - controlPointDiameter / 2 + 1)
        case .right:
            return NSPoint(x: rect.maxX - controlPointDiameter / 2 + 1, y: rect.midY - controlPointDiameter / 2)
        case .bottomRight:
            return NSPoint(x: rect.maxX - controlPointDiameter / 2 + 1, y: rect.minY - controlPointDiameter / 2 - 1)
        case .bottom:
            return NSPoint(x: rect.midX - controlPointDiameter / 2, y: rect.minY - controlPointDiameter / 2 - 1)
        case .bottomLeft:
            return NSPoint(x: rect.minX - controlPointDiameter / 2 - 1, y: rect.minY - controlPointDiameter / 2 - 1)
        case .left:
            return NSPoint(x: rect.minX - controlPointDiameter / 2 - 1, y: rect.midY - controlPointDiameter / 2)
        case .none:
            return nil
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if editViewFinshed {
            return
        }
        guard var initialLocation = initialLocation else { return }
        let currentLocation = convert(event.locationInWindow, from: nil)
        if activeHandle != .none {
            // Calculate new rectangle size and position
            var newRect = selectionRect ?? CGRect.zero
            
            // Get last mouse location
            let lastLocation = lastMouseLocation ?? currentLocation
            
            let deltaX = currentLocation.x - lastLocation.x
            let deltaY = currentLocation.y - lastLocation.y
            
            switch activeHandle {
            case .topLeft:
                newRect.origin.x = min(newRect.origin.x + newRect.size.width - 20, newRect.origin.x + deltaX)
                newRect.size.width = max(20, newRect.size.width - deltaX)
                newRect.size.height = max(20, newRect.size.height + deltaY)
            case .top:
                newRect.size.height = max(20, newRect.size.height + deltaY)
            case .topRight:
                newRect.size.width = max(20, newRect.size.width + deltaX)
                newRect.size.height = max(20, newRect.size.height + deltaY)
            case .right:
                newRect.size.width = max(20, newRect.size.width + deltaX)
            case .bottomRight:
                newRect.origin.y = min(newRect.origin.y + newRect.size.height - 20, newRect.origin.y + deltaY)
                newRect.size.width = max(20, newRect.size.width + deltaX)
                newRect.size.height = max(20, newRect.size.height - deltaY)
            case .bottom:
                newRect.origin.y = min(newRect.origin.y + newRect.size.height - 20, newRect.origin.y + deltaY)
                newRect.size.height = max(20, newRect.size.height - deltaY)
            case .bottomLeft:
                newRect.origin.y = min(newRect.origin.y + newRect.size.height - 20, newRect.origin.y + deltaY)
                newRect.origin.x = min(newRect.origin.x + newRect.size.width - 20, newRect.origin.x + deltaX)
                newRect.size.width = max(20, newRect.size.width - deltaX)
                newRect.size.height = max(20, newRect.size.height - deltaY)
            case .left:
                newRect.origin.x = min(newRect.origin.x + newRect.size.width - 20, newRect.origin.x + deltaX)
                newRect.size.width = max(20, newRect.size.width - deltaX)
            default:
                break
            }
            self.selectionRect = newRect
            initialLocation = currentLocation // Update initial location for continuous dragging
        } else {
            if dragIng {
                dragIng = true
                // 计算移动偏移量
                let deltaX = currentLocation.x - initialLocation.x
                let deltaY = currentLocation.y - initialLocation.y
                
                // 更新矩形位置
                let x = self.selectionRect?.origin.x
                let y = self.selectionRect?.origin.y
                let w = self.selectionRect?.size.width
                let h = self.selectionRect?.size.height
                self.selectionRect?.origin.x = min(max(0.0, x! + deltaX), self.frame.width - w!)
                self.selectionRect?.origin.y = min(max(0.0, y! + deltaY), self.frame.height - h!)
                initialLocation = currentLocation
            } else {
                // 创建新矩形
                guard let maxFrame = maxFrame else { return }
                let origin = NSPoint(x: max(maxFrame.origin.x, min(initialLocation.x, currentLocation.x)), y: max(maxFrame.origin.y, min(initialLocation.y, currentLocation.y)))
                var maxH = abs(currentLocation.y - initialLocation.y)
                var maxW = abs(currentLocation.x - initialLocation.x)
                if currentLocation.y < maxFrame.origin.y { maxH = initialLocation.y }
                if currentLocation.x < maxFrame.origin.x { maxW = initialLocation.x }
                let size = NSSize(width: maxW, height: maxH)
                self.selectionRect = NSIntersectionRect(maxFrame, NSRect(origin: origin, size: size))
            }
            self.initialLocation = initialLocation
        }
        lastMouseLocation = currentLocation
        needsDisplay = true
    }
    
//     点击按钮下去的时候
    override func mouseDown(with event: NSEvent) {
//        1、首先判断是否在已经的框框上面了
//        1.0 没有子view 就做有关的框框
//        1.1、有： 就可以聚焦扩展
//        1.2、没有：就添加新的内容 （线实现新的内容） ——> 2步骤： 添加新的views叠加
//        2、
        if (self.editViewFinshed) {
            return
        }
        let location = convert(event.locationInWindow, from: nil)
        initialLocation = location
        lastMouseLocation = location
        activeHandle = handleForPoint(location)
        if let rect = selectionRect, NSPointInRect(location, rect) {
            dragIng = true
        }
        needsDisplay = true
        
        if let pannel = self.areaPannel {
            pannel.orderBack(nil)
            pannel.setIsVisible(false)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if self.editViewFinshed {
            self.addCustomSubviews()
            return
        }

        initialLocation = nil
        activeHandle = .none
        dragIng = false
        needsDisplay = true
        
        self.showEditCutBottomView()
    }
    
    override func mouseMoved(with event: NSEvent) {
        let curlocation = convert(event.locationInWindow, from: nil)
        activeHandle = handleForPoint(curlocation)
        if (activeHandle != .none) {
            switch activeHandle {
            case .top, .bottom:
                NSCursor.frameResize(position: .top, directions: [.inward, .outward]).set()
            case .left, .right:
                NSCursor.frameResize(position: .left, directions: [.inward, .outward]).set()
            case .topLeft, .bottomRight:
                NSCursor.frameResize(position: .topLeft, directions: [.inward, .outward]).set()
            case .topRight, .bottomLeft:
                NSCursor.frameResize(position: .topRight, directions: [.inward, .outward]).set()
            default:
                NSCursor.resizeLeftRight.set()
                break
            }
        }
        else {
            if (self.selectionRect!.contains(curlocation)) {
                NSCursor.closedHand.set()
            }
            else {
                NSCursor.crosshair.set()
            }
        }
    }
    
    
    var areaPannel: NSPanel?
//    @AppStorage("EditCutHeight") var EditCutHeight:Int = 40
//    @AppStorage("isEditCutSecondShow") var isEditCutSecondShow:Bool = false
//    @ObservedObject var counterModel: CounterModel
    @ObservedObject var editCutSecondItem : EditCutSecondShowModel

    var EditCutHeight: Int {
        if (editCutSecondItem.isEditCutSecondShow) {
            return 85
        }
        else {
            return 45
        }
    }
    
    func showEditCutBottomView() {
        if (areaPannel == nil) {
            let contentView = NSHostingView(rootView: EditCutBottomView())
            contentView.frame = NSRect(x: selectionRect!.origin.x + selectionRect!.size.width - 340 , y:selectionRect!.origin.y - CGFloat(self.EditCutHeight), width: contentView.frame.size.width, height: contentView.frame.size.height)
            contentView.focusRingType = .none
            let areaPanel = EditCutBottomPanel(contentRect: contentView.frame, styleMask: [.fullSizeContentView], backing: .buffered, defer: false)
            areaPanel.collectionBehavior = [.canJoinAllSpaces]
            areaPanel.setFrame(contentView.frame, display: true)
            areaPanel.level = .screenSaver
            areaPanel.title = "编辑图片"
            areaPanel.contentView = contentView
            areaPanel.backgroundColor = .clear
            areaPanel.titleVisibility = .hidden
            areaPanel.isReleasedWhenClosed = false
            areaPanel.titlebarAppearsTransparent = true
            areaPanel.isMovableByWindowBackground = true
            areaPanel.orderFront(nil)
            self.areaPannel =  areaPanel
        }
        else {
            self.areaPannel!.setFrameOrigin(NSMakePoint(selectionRect!.origin.x + selectionRect!.size.width - 340 , selectionRect!.origin.y - CGFloat(self.EditCutHeight)))
            self.areaPannel!.orderFront(self)
        }
        self.areaPannel!.setIsVisible(true)
    }
}

