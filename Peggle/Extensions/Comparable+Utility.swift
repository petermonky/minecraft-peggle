//
//  Comparable+Utility.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/09.
//

import Foundation

extension Comparable {
    func clamp(between range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
