//
//  View+HideKeyboard.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/27.
//

import Foundation
import SwiftUI

extension View {
  func hideKeyboard() {
      let resign = #selector(UIResponder.resignFirstResponder)
      UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
}
