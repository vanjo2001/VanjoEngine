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
	
	private let inputController = InputController()
	
	private var scene = SandboxScene(id: "SandboxScene")
    
    override func loadView() {
        view = MTKView()
        metalView.device = renderer.engine.device
		
		renderer.nodeToRender = scene
		
		inputController.targetView = view
		inputController.delegate = scene
    }
    
    override func viewDidLoad() {
        metalView.delegate = renderer
    }
    
    override var next: UIResponder? {
        return inputController
    }
}

