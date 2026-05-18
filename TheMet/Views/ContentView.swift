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
                NavigationLink(
                    destination: SafariView(
                        url: URL(string: object.objectURL)!
                    ),
                    label: {
                        HStack {
                            Text(object.title)
                            Spacer()
                            Image(
                                systemName:
                                    "rectangle.portrait.and.arrow.right.fill"
                            ).font(.footnote)
                        }
                    }
                )
            }
            .navigationTitle("The Met")
        }
    }
}

#Preview {
    ContentView()
}
