//
//  SafariView.swift
//  TheMet
//
//  Created by Damian Ogórek on 17/05/2026.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {}
}

struct SafariView_Preview: PreviewProvider {
    static var previews: some View {
        SafariView(
            url: URL(
                string: "https://www.metmuseum.org/art/collection/search/437094"
            )!
        )
    }
}
