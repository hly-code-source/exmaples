import SwiftUI

@objc
class XXViewController: NSObject{
    @MainActor @objc func createTestViewController() -> UIViewController{
        let vc = UIHostingController(rootView: MySwiftUIView());
        return vc
    }
}

public struct MySwiftUIView: View {
    public var body: some View {
        NavigationLink(destination: UIKitViewController()) {
            Text("Hello from SwiftUI!")
                .font(.largeTitle)
                .padding()
                            
        }
    }
    
}
