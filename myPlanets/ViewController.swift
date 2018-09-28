//
//  ViewController.swift
//  myPlanets
//
//  Created by Christopher Davis on 11/29/17.
//  Copyright © 2017 Christopher Davis. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var lblPlanet: UILabel!
    
    let configuration = ARWorldTrackingConfiguration()
    var starsEnabled = true
    
    let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
    let stars = SCNNode(geometry: SCNSphere(radius: 5.0))
    let mercury = SCNNode(geometry: SCNSphere(radius: 0.2))
    let venus = SCNNode(geometry: SCNSphere(radius: 0.2))
    let earth = SCNNode(geometry: SCNSphere(radius: 0.2))
    let mars = SCNNode(geometry: SCNSphere(radius: 0.2))
    let jupiter = SCNNode(geometry: SCNSphere(radius: 0.2))
    let saturn = SCNNode(geometry: SCNSphere(radius: 0.2))
    let uranus = SCNNode(geometry: SCNSphere(radius: 0.2))
    let neptune = SCNNode(geometry: SCNSphere(radius: 0.2))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        // calling delegate
        self.sceneView.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "2k_sun_diffuse")
        sun.position = SCNVector3(0,0,-1)
    
        self.sceneView.scene.rootNode.addChildNode(sun)
        
        planet(node: stars, diffuse: UIImage(named: "2k_stars_diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,0), name: "Stars")
        
        planet(node: mercury, diffuse: UIImage(named: "2k_mercury_diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(0.5,0,0), name: "Mercury")

        planet(node: venus, diffuse: UIImage(named: "2k_venus_diffuse")!, specular: nil, emission: UIImage(named: "2k_venus_emission"), normal: nil, position: SCNVector3(1.0,0,0), name: "Venus")
        
        planet(node: earth, diffuse: UIImage(named: "2k_earth_day")!, specular: UIImage(named: "2k_earth_specular")!, emission: UIImage(named: "2k_earth_clouds")!, normal: UIImage(named: "2k_earth_normal")!, position: SCNVector3(1.5,0,0), name: "Earth")
        
        planet(node: mars, diffuse: UIImage(named: "2k_mars_diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(2.0,0,0), name: "Mars")
        
        planet(node: jupiter, diffuse: UIImage(named: "2k_jupiter_diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(2.5,0,0), name: "Jupiter")
        
        planet(node: saturn, diffuse: UIImage(named: "2k_saturn_diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(3.0,0,0), name: "Saturn")
        
        planet(node: uranus, diffuse: UIImage(named: "2k_uranus_diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(3.5,0,0), name: "Uranus")
        
        planet(node: neptune, diffuse: UIImage(named: "2k_neptune_diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(4.0,0,0), name: "Neptune")
        
        sun.addChildNode(mercury)
        sun.addChildNode(venus)
        sun.addChildNode(earth)
        sun.addChildNode(mars)
        sun.addChildNode(jupiter)
        sun.addChildNode(saturn)
        sun.addChildNode(uranus)
        sun.addChildNode(neptune)
        sun.addChildNode(stars)
        
        
//        let action = SCNAction.rotateBy(x: 0, y: CGFloat(380.degreesToRadians), z: 0, duration: 8)
//        earth.runAction(action)
//        let forever = SCNAction.repeatForever(action)
//        earth.runAction(forever)
        
    }
    
    func planet(node: SCNNode, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3, name: String) {
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.geometry?.firstMaterial?.diffuse.contents = diffuse
        node.geometry?.firstMaterial?.specular.contents = specular
        node.geometry?.firstMaterial?.emission.contents = emission
        node.geometry?.firstMaterial?.normal.contents = normal
        node.position = position
        node.name = name
    }
    

    @IBAction func starsAction(_ sender: UIButton) {
        
        if starsEnabled {
            stars.removeFromParentNode()
            starsEnabled = false
        } else {
            sun.addChildNode(stars)
            starsEnabled = true
        }
        
    }
    
    func distanceVec(obj1: SCNVector3, obj2: SCNVector3) -> Double {
        let xA = Double(obj1.x)
        let xB = Double(obj2.x)
        let yA = Double(obj1.y)
        let yB = Double(obj2.y)
        let zA = Double(obj1.z)
        let zB = Double(obj2.z)
        
        let distance = sqrt((xB - xA) + (yB-yA) + (zB-zA))
        return distance
    }
    
    func roundDouble(_ value: Double, toNearest: Double) -> Double {
        return round(value / toNearest) * toNearest
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        
        // these two are rotation and translation of the phone relative to the root csys
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPostionOfCamera = orientation + location
        
        let earthDistance = distanceVec(obj1: currentPostionOfCamera, obj2: earth.position)
        
        if earthDistance < 1.0 {
            DispatchQueue.main.async {
                self.lblPlanet.text = "Distance from Earth: \(self.roundDouble(earthDistance, toNearest: 0.01))"
            }
        } else {
            DispatchQueue.main.async {
                self.lblPlanet.text = " "
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    
}

// this adds the x, y & z to form a location matrix.  currentPostionOfCamera uses this.
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

