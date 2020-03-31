//
//  ContentView.swift
//  WordScramble
//
//  Created by Ahad Islam on 3/31/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        List {
            Section(header: Text("Section 1")) {
                Text("Static row 1")
                Text("Static row 2")
                Text("Static row 3")
            }
            
            Section(header: Text("Section 2")) {
                ForEach(0..<5) {
                    Text("Dynamic row \($0)")
                }
            }
            
            Section(header: Text("Section 3")) {
                Text("Static row 3")
                Text("Static row 4")
            }
        }
    .listStyle(GroupedListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
