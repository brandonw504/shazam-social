//
//  UndimmedPresentationDetent.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import Foundation
import SwiftUI
import UIKit

/**
 Connect SwiftUI PresentationDetent and UIKit detent identifier.
 */
enum UndimmedPresentationDetent {
    case large
    case medium

    var swiftUIDetent: PresentationDetent {
        switch self {
        case .large: return .large
        case .medium: return .medium
        }
    }

    var uiKitIdentifier: UISheetPresentationController.Detent.Identifier {
        switch self {
        case .large: return .large
        case .medium: return .medium
        }
    }
}

// Provides a Set of detents (.medium, .large, if we have both)
extension Collection where Element == UndimmedPresentationDetent {
    var swiftUISet: Set<PresentationDetent> {
        Set(map { $0.swiftUIDetent })
    }
}
