//
//  InputController.swift
//  InputController
//
//  Created by Vanjo Lutik on 20.01.2022.
//

import Foundation
import CoreGraphics
import UIKit


protocol InputControllerDelegate: AnyObject {
    func didTouch(for point: CGPoint)
}


class InputController: UIResponder {
    
    weak var delegate: InputControllerDelegate?
    
    weak var targetView: UIView?
    
    override init() {}
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        
        let location = firstTouch.location(in: targetView)
        delegate?.didTouch(for: location)
    }
}
