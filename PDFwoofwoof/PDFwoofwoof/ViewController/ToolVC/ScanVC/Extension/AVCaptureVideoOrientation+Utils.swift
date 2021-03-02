//
//  AVCaptureVideoOrientation+Utils.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/6/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

extension AVCaptureVideoOrientation {
    
    /// Maps UIDeviceOrientation to AVCaptureVideoOrientation
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait:
            self.init(rawValue: AVCaptureVideoOrientation.portrait.rawValue)
        case .portraitUpsideDown:
            self.init(rawValue: AVCaptureVideoOrientation.portraitUpsideDown.rawValue)
        case .landscapeLeft:
            self.init(rawValue: AVCaptureVideoOrientation.landscapeLeft.rawValue)
        case .landscapeRight:
            self.init(rawValue: AVCaptureVideoOrientation.landscapeRight.rawValue)
        case .faceUp:
            self.init(rawValue: AVCaptureVideoOrientation.portrait.rawValue)
        case .faceDown:
            self.init(rawValue: AVCaptureVideoOrientation.portraitUpsideDown.rawValue)
        default:
            self.init(rawValue: AVCaptureVideoOrientation.portrait.rawValue)
        }
    }
    
}
