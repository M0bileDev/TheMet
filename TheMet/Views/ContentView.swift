//
//  ContentView.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var store = TheMetStore(maxIndex: 5)
    @State private var query = ""
    @State private var showQueryField = false
    @State private var fetchObjectsTask: Task<Void, Error>?
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("You searched for '\(query)'")
                    .padding(10)
                    .background(Color.metForeground)
                    .cornerRadius(10)
                    .padding()

                List(store.objects, id: \.objectID) { object in
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
                        TextField("Search the Met", text: $query)
                        Button("Search") {
                            fetchObjectsTask?.cancel()
                            fetchObjectsTask = Task {
                                do {
                                    store.objects = []
                                    try await store.fetchObjects(query: query)
                                } catch {}
                            }
                        }
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
            .overlay {
                if store.objects.isEmpty { ProgressView() }
            }
        }
        .onOpenURL(perform: { url in
            if let id = url.host,
                let object = store.objects.first(where: {
                    String($0.objectID) == id
                })
            {
                if object.isPublicDomain {
                    path.append(object)
                } else {
                    if let url = URL(string: object.objectURL) {
                        path.append(url)
                    }
                }
            }
        })

    }
}

#Preview {
    ContentView()
}
