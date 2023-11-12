//
//  UIView+Extensions.swift
//  iWeather
//
//  Created by Thais Aquino on 11/11/2023.
//

import Foundation
import UIKit

extension UIView {
    func setConstaintsToParent(_ parent: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])
    }
}
