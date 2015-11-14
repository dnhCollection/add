//
//  ViewController.swift
//  Add
//
//  Created by chendong.xiaohong on 2015-11-08.
//  Copyright © 2015 dnhCollection. All rights reserved.
//

import UIKit

class PlaygroundVC: UIViewController {

    @IBOutlet weak var refView: UIView!
    
    var buttonNumber = 0
    
    let gravity = UIGravityBehavior()
    lazy var animator: UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.refView)
        return lazyAnimator
    }()
    
    lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCollider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(gravity)
        animator.addBehavior(collider)
    }
    
    var widthRatio = 10
    
    var dropSize : CGSize {
        let size = refView.bounds.size.width/CGFloat(widthRatio)
        return CGSize(width: size, height: size)
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop(){
//        var frame = CGRect(origin: CGPointZero, size:dropSize)
//        frame.origin.x = CGFloat.random(widthRatio) * dropSize.width
//        let dropView = UIView(frame: frame)
//        dropView.backgroundColor = UIColor.random
//        refView.addSubview(dropView)
//        
//        gravity.addItem(dropView)
//        collider.addItem(dropView)
        
        let buttonView = getButton("\(buttonNumber)")
        self.view.addSubview(buttonView)
        refView.addSubview(buttonView)
        
        gravity.addItem(buttonView)
        collider.addItem(buttonView)
        
        buttonNumber = buttonNumber + 1
    }
    
    
    private func getButton(text:String) -> UIButton{
        let button = UIButton()
        button.frame = CGRect(origin: CGPointZero, size: dropSize)
        button.frame.origin.x = CGFloat.random(widthRatio) * dropSize.width
        button.layer.cornerRadius = 18
        button.backgroundColor = UIColor.random
        button.setTitle(text, forState: .Normal)
        button.addTarget(self, action: "pressed", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    private func pressed(){
        print("pressed")
    }
}



private extension CGFloat{
    static func random(max:Int)->CGFloat{
        let x = arc4random() % UInt32(max)
        return CGFloat(x)
    }
}

private extension UIColor {
    class var random:UIColor{
        switch arc4random()%5{
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        
        }
    }
}


