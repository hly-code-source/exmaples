//
//  ContentView.swift
//  Test
//
//  Created by helinyu on 2024/11/10.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedOption = 0
    let options = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        VStack {
            Picker("Select an option", selection: $selectedOption) {
                ForEach(0..<options.count) { index in
                    Text(options[index])
                }
            }
           .pickerStyle(MenuPickerStyle())
        }
       .frame(maxWidth:.infinity, maxHeight:.infinity)
       .onChange(of: selectedOption) { _ in
            openFinder()
        }
    }

    func openFinder() {
        let finderURL = URL(fileURLWithPath: "/System/Applications/")
        NSWorkspace.shared.activateFileViewerSelecting([finderURL])
    }
}

#Preview {
    ContentView()
}
