//
//  ContentView.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var store = TheMetStore()
    @State private var query = "Lorem ipsum"
    @State private var showQueryField = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("You searched for '\(query)'")
                    .padding(10)
                    .background(Color.metForeground)
                    .cornerRadius(10)
                    .padding()

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
                .toolbar {
                    Button("Search the Met") {
                        query = ""
                        showQueryField = true
                    }
                    .foregroundColor(Color.metBackground)
                    .padding(.horizontal)
                    .shadow(color: Color.red.opacity(0.5), radius: 6)
                }
                .alert(
                    "Search the Met",
                    isPresented: $showQueryField,
                    actions: {
                        TextField("Seatch the Met", text: $query)
                        Button("Search") {}
                    }
                )
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
}

#Preview {
    ContentView()
}
