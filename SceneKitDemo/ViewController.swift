//
//  ViewController.swift
//  SceneKitDemo
//
//  Created by Soerensen, Ole Lynge on 04/09/2017.
//  Copyright © 2017 Soerensen, Ole Lynge. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum ShapeType:Int{
    case box = 0
    case sphere
    case pyramid
    case torus
    case capsule
    case cylinder
    case cone
    case tube
    
//    static func random() -> ShapeType{
//
//    }
}

class ViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(self.sceneView)

        self.sceneView.delegate = self
        
        let scene = SCNScene()
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.03)
        
        let material = SCNMaterial()
        material.name = "Color"
        material.diffuse.contents = UIColor.purple
        
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 0.1, -0.5)

        scene.rootNode.addChildNode(node)

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        sceneView.scene = scene
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration, options:[])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer){
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options:[:])
        
        if !hitResults.isEmpty{
            let node = hitResults[0].node
            let material = node.geometry?.material(named: "Color")
            let randomRed = CGFloat(arc4random_uniform(255))
            let randomBlue = CGFloat(arc4random_uniform(255))
            let randomGreen = CGFloat(arc4random_uniform(255))
            material?.diffuse.contents = UIColor.init(
                red: randomRed/255.0,
                green: randomGreen/255.0,
                blue: randomBlue/255.0,
                alpha: 1.0)
        }
    }
}
