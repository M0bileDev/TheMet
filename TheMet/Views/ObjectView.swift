//
//  ObjectView.swift
//  TheMet
//
//  Created by Damian Ogórek on 15/05/2026.
//

import SwiftUI

struct ObjectView: View {

    let object: Object

    @ViewBuilder
    var placeholder: some View {
        if object.isPublicDomain {
            AsyncImage(url: URL(string: object.primaryImageSmall)) { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
            } placeholder: {
              PlaceholderView(note: "Display image here")
            }
        } else {
            PlaceholderView(note: "Image not in public domain.")
        }
    }

    var body: some View {
        VStack {
            Text(object.title)
                .multilineTextAlignment(.leading)
                .font(.callout)
                .frame(minHeight: 44)
            placeholder
            Text(object.creditLine)
                .font(.caption)
                .padding()
                .background(Color.metForeground)
                .cornerRadius(10)
        }
        .padding(.vertical)
    }
}

#Preview {
    ObjectView(object: initialObjects[0])
}
