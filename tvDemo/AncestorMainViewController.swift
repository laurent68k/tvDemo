//
//  ViewController.swift
//  Addition
//
//  Created by Laurent on 11/07/2017.
//  Copyright © 2017 Laurent68k. All rights reserved.
//

import UIKit

class AncestorMainViewController: UIViewController {
    
    @IBOutlet weak var imageDad: UIImageView!
    @IBOutlet weak var imageMom: UIImageView!
    @IBOutlet weak var imageCat: UIImageView!
    
    @IBOutlet weak var actionLabel: UILabel!
    
    private enum RotateDirection : Int {
        
        case    left = 1
        case    right = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.actionLabel.text = ""
        
        //  Personnals observers for background and kill App
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationWillEnterForeground),
            name: NSNotification.Name(rawValue: "applicationWillEnterForeground"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationDidBecomeActive),
            name: NSNotification.Name(rawValue: "applicationDidBecomeActive"),
            object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated:Bool ) {
        
        self.start3DRotateAnimation()
        self.start2DRotateAnimation(self.imageMom, direction:.left)
        self.start2DRotateAnimation(self.imageCat, direction:.right)
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    @objc private func applicationWillEnterForeground() {
        
        self.pauseAnimation(self.imageDad.layer)
        self.pauseAnimation(self.imageMom.layer)
        self.pauseAnimation(self.imageCat.layer)
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    @objc private func applicationDidBecomeActive() {
        
        self.resumeAnimation(self.imageDad.layer)
        self.resumeAnimation(self.imageMom.layer)
        self.resumeAnimation(self.imageCat.layer)
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func okAction(_ sender: UIButton) {
        
        self.actionLabel.text = "OK pressed"
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        self.actionLabel.text = "Cancel pressed"
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    private func start3DRotateAnimation(_ duration: TimeInterval = 10) {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        
        animation.fromValue = 0.0
        animation.toValue = CGFloat(.pi * 2.0)
        
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        
        self.imageDad.layer.add(animation, forKey: "r3")
    }
    
    private func start2DRotateAnimation(_ viewObject :UIView, direction: RotateDirection, duration: TimeInterval = 5) {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        if direction == .left {
            animation.fromValue = 0.0
            animation.toValue = CGFloat(.pi * 2.0)
        }
        else {
            animation.fromValue = CGFloat(.pi * 2.0)
            animation.toValue = 0.0
        }
        
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        
        viewObject.layer.add(animation, forKey: "rotate")
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// Functions to pause/resum any animations on a CALayer
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    private func pauseAnimation(_ layer:CALayer) {
        
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    private func resumeAnimation(_ layer:CALayer) {
        
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}

