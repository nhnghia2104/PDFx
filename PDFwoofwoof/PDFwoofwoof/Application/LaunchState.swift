//
//  LaunchState.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/16/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation

protocol LaunchURLDelegate: class {
    func open(url: URL)
}

final class LaunchState {
    
    static let shared: LaunchState = LaunchState()
    
    var launchURL: URL? {
        didSet {
            guard let url = launchURL else { return }
            launchURLDelegate?.open(url: url)
        }
    }
    
    weak var launchURLDelegate: LaunchURLDelegate?
    
    private init() { }
    
}
