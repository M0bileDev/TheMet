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
        List(store.objects, id: \.objectId) { object in
            Text(object.title)
        }
    }
}

#Preview {
    ContentView()
}
