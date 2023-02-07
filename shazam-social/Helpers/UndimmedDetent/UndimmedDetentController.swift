//
//  UndimmedDetentController.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import Foundation
import UIKit

/**
 View controller to manipulate the sheet presentation controller, which can't be done directly from SwiftUI.
 */
class UndimmedDetentController: UIViewController {
    var largestUndimmed: UndimmedPresentationDetent?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avoidDimmingParent()
        avoidDisablingControls()
    }

    func avoidDimmingParent() {
        let id = largestUndimmed?.uiKitIdentifier
        sheetPresentationController?.largestUndimmedDetentIdentifier = id
    }

    func avoidDisablingControls() {
        presentingViewController?.view.tintAdjustmentMode = .normal
    }
}

