//
//  ViewController.swift
//  VanjoEngine
//
//  Created by Vanjo Lutik on 27.12.2021.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    private lazy var metalView = view as! MTKView
    private let renderer = Renderer()
    
    override func loadView() {
        view = MTKView()
        metalView.device = renderer.engine.device
        renderer.inputController.targetView = view
    }
    
    override func viewDidLoad() {
        metalView.delegate = renderer
    }
    
    override var next: UIResponder? {
        return renderer.inputController
    }
}

