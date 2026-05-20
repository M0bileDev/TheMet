//
//  WebIndicatorView.swift
//  TheMet
//
//  Created by Damian Ogórek on 20/05/2026.
//

import SwiftUI

struct WebIndicatorView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Image(
                systemName:
                    "rectangle.portrait.and.arrow.right.fill"
            ).font(.footnote)
        }
    }
}

#Preview {
    WebIndicatorView(title: "Lorem ipsum")
}
