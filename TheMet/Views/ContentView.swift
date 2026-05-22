//
//  ContentView.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var store = TheMetStore(defaultData: true)
    @State private var query = "Lorem ipsum"
    @State private var showQueryField = false

    var body: some View {
        NavigationStack {
            List(store.objects, id: \.objectId) { object in
                if !object.isPublicDomain,
                    let url = URL(string: object.objectURL)
                {
                    NavigationLink(value: url) {
                        WebIndicatorView(title: object.title)
                    }
                    .listRowBackground(Color.metBackground)
                    .foregroundStyle(.white)
                } else {
                    NavigationLink(value: object) {
                        Text(object.title)
                    }
                    .listRowBackground(Color.metForeground)
                }

            }
            .navigationTitle("The Met")
            .navigationDestination(
                for: URL.self,
                destination: { url in
                    SafariView(url: url)
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea()
                }
            )
            .navigationDestination(
                for: Object.self,
                destination: { object in
                    ObjectView(object: object)
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
