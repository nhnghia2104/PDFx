//
//  CaptureSession+Flash.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/6/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation

/// Extension to CaptureSession to manage the device flashlight
extension CaptureSession {
    /// The possible states that the current device's flashlight can be in
    enum FlashState {
        case on
        case off
        case unavailable
        case unknown
    }
    
    /// Toggles the current device's flashlight on or off.
    func toggleFlash() -> FlashState {
        guard let device = device, device.isTorchAvailable else { return .unavailable }
        
        do {
            try device.lockForConfiguration()
        } catch {
            return .unknown
        }
        
        defer {
            device.unlockForConfiguration()
        }
        
        if device.torchMode == .on {
            device.torchMode = .off
            return .off
        } else if device.torchMode == .off {
            device.torchMode = .on
            return .on
        }
        
        return .unknown
    }
}
