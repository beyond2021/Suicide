//
//  DropItViewController.swift
//  Suicide
//
//  Created by KEEVIN MITCHELL on 11/2/15.
//  Copyright © 2015 Beyond 2021. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {
    //Let make em fall
    
    //let take the default magnitude and direction which is down at 1000 points/sec/sec
    let gravity = UIGravityBehavior() //Create gravity
    
    //We also need a dynamic animator
//    var animator:UIDynamicAnimator = UIDynamicAnimator(referenceView: gameView)
//    This would not work because I am in the middle of initializing here. You cannot access your own properties and methods before you are initialized.
    
    //1 way to do it is make it an optional and set it in viewDidLoad
    //2 Use lazy instantiation and set its initial value as a result of executing a clousure
    lazy  var animator:UIDynamicAnimator = {
        //This will not get initialized until someone ask for it. But this clousure better return a dynamic animator. Because we are setting it to the result. IMPORTANT DONOT CALL THIS BEFORE GAMEVIEW GETS SET. SO I NOT ACCESS IT UNTIL VIEW DID LOAD.
    let lazilyCreatedDynamicAnimator =    UIDynamicAnimator(referenceView: self.gameView)
        return lazilyCreatedDynamicAnimator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add gravity here
        animator.addBehavior(gravity) //here we add gravity to an animator. All we need to do here is say which items are affected by gravity. drop()
        
        //Add the boundary
        animator.addBehavior(collider)
        
        
    }
    //To make the containers
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        //I am doing it with a clousure because I want to configure it. I want to tyraslate the reference bounds into a boundary.
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true// Any intems in this will bounce off
        return lazilyCreatedCollider
        
    }()
    
    

    @IBOutlet weak var gameView: UIView!
    
    //Along the top of my view im going to drop those squares
    
    //Lets line them up on top. Lests make them evenly spaced
    var dropsPerRow = 10 // could make this configurable and set it in settings
    
    //So lets calculate the size of each drop based on the amount of drops (dropsPerRow)
    var dropSize: CGSize {
        //We are making squares here
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow) //Equally divide my width
        return CGSize(width: size, height: size) //a square
        
        
    }

    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop(){
        //Lets create one at 0,0 CGPointZero
        
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        //Let move it along randomly
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width // here we get a number between 0 and dropsPerRow - 1
        //Create my dropView
        let dropView = UIView(frame: frame)
        //Set thedropview's background color
        dropView.backgroundColor = UIColor.random //From my extention below
        
        //Now that we have our dropView let add it to my gameView
        gameView.addSubview(dropView)
        // add gravity
        gravity.addItem(dropView) //Everything is going to start animating. I can add them later to start animating I can take them out to stop animating. ITS INSTANEOUS
        
        // add collider
        collider.addItem(dropView)
        
    }


}

//Uses arc4random to create a random float
//Extentions are private meaning only I can use them
//Also means the name wouldnt conflick with anyone else

private extension CGFloat   {
    static func random(max: Int) -> CGFloat{
      return CGFloat(arc4random() % UInt32(max))
        
        
    }
    
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
            
        }
        
    }
    
    
}



