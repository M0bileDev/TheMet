//
//  DetailIndicatorView.swift
//  TheMet
//
//  Created by Damian Ogórek on 28/05/2026.
//

import SwiftUI

struct DetailIndicatorView: View {

    let title: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
            Spacer()
            Image(systemName: "doc.text.image.fill")
        }
    }
}

#Preview {
    DetailIndicatorView(title: "lorem ipsum")
}
