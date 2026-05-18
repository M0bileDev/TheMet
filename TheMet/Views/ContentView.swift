//
//  ContentView.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var store = TheMetStore(defaultData: true)

    var body: some View {
        NavigationStack {
            List(store.objects, id: \.objectId) { object in
                NavigationLink(object.title) {
                    ObjectView(object: object)
                }
            }
            .navigationTitle("The Met")
        }
    }
}

#Preview {
    ContentView()
}
