//
//  UndimmedDetentView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import SwiftUI

/**
 Serves a parent view of a sheet that isn't dimmed when covered by a sheet.
 */
struct UndimmedDetentView: UIViewControllerRepresentable {
    // Parent view undimming stops working unless you provide a largest undimmed detent size.
    var largestUndimmed: UndimmedPresentationDetent?

    func makeUIViewController(context: Context) -> UIViewController {
        let result = UndimmedDetentController()
        result.largestUndimmed = largestUndimmed
        return result
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

// Provides a new implementation of presentationDetents that doesn't dim the view the sheet is covering.
extension View {
    // Single sheet
    func presentationDetents(undimmed detents: [UndimmedPresentationDetent], largestUndimmed: UndimmedPresentationDetent? = nil) -> some View {
        self.background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
            .presentationDetents(detents.swiftUISet)
    }

    // Multiple sheets
    func presentationDetents(undimmed detents: [UndimmedPresentationDetent], largestUndimmed: UndimmedPresentationDetent? = nil, selection: Binding<PresentationDetent>) -> some View {
        self.background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
            .presentationDetents(
                Set(detents.swiftUISet),
                selection: selection
            )
    }
}
