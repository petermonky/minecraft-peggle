//
//  RendererDelegate.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/26.
//

import Foundation

protocol RendererDelegate: AnyObject {
    func didAppear(frame: Frame)
    func didRefreshDisplay(interval: TimeInterval)
    func didUpdateCannonTowards(position: CGPoint)
    func didAddBallTowards(position: CGPoint)
}
