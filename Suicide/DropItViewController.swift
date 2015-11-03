//
//  DropItViewController.swift
//  Suicide
//
//  Created by KEEVIN MITCHELL on 11/2/15.
//  Copyright © 2015 Beyond 2021. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController, UIDynamicAnimatorDelegate
    
{
    var attachment: UIAttachmentBehavior? {
    willSet{
        //This is about to attach to something new here. remove the existin attachment if there is any attached
        if attachment != nil{
            animator.removeBehavior(attachment!)
            gameView.setPath(nil , named: PathNames.Attachment)
        }
    }
    didSet{
        if attachment != nil{
          animator.addBehavior(attachment!)
            attachment?.action = { [unowned self] in 
            
            if let attachedView = self.attachment?.items.first as? UIView {
                              //Lets see the anchor
                let path = UIBezierPath()
                //how do we get thje view to attach the string
                path.moveToPoint(self.attachment!.anchorPoint)
                path.addLineToPoint(attachedView.center)
                self.gameView.setPath(path, named: PathNames.Attachment)
                }
                
            }
            
            
        }
        
    }
    }
    
   // var dropView : UIView?
    
// TODA WE CAN PUT THIS IN THE DROPITBEHAVIOR. Its opyional because i only have the attachment when I am panning.
    
    //We also need a dynamic animator
//    var animator:UIDynamicAnimator = UIDynamicAnimator(referenceView: gameView)
//    This would not work because I am in the middle of initializing here. You cannot access your own properties and methods before you are initialized.
    
    //1 way to do it is make it an optional and set it in viewDidLoad
    //2 Use lazy instantiation and set its initial value as a result of executing a clousure
    lazy  var animator:UIDynamicAnimator = {
        //This will not get initialized until someone ask for it. But this clousure better return a dynamic animator. Because we are setting it to the result. IMPORTANT DONOT CALL THIS BEFORE GAMEVIEW GETS SET. SO I NOT ACCESS IT UNTIL VIEW DID LOAD.
    let lazilyCreatedDynamicAnimator =    UIDynamicAnimator(referenceView: self.gameView)
        // Make ourself the delegate
        lazilyCreatedDynamicAnimator.delegate = self
        
        return lazilyCreatedDynamicAnimator
    }()
    
    //Create a drtopit behavior
    let dropItBehavior = DropItBehavior()
    
    
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        
        for view in gameView.subviews {
           
               // dropItBehavior.removeDrop(view)
            
            if let _ = view as? UILabel {
               // print("this is a label")
            } else {
                dropItBehavior.removeDrop(view)
            }
         
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DropZone"
        
        // add gravity here
        animator.addBehavior(dropItBehavior) //here we add gravity to an animator. All we need to do here is say which items are affected by gravity. drop()
        
        //Add the boundary
       // animator.addBehavior(collider)
        
        
    }
    struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    
    //Put our individual boundary in view didlayoutSubView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // I want it right in the center. Lets make the size the same as the drop
        let barrierSize = dropSize
        // the origin of it in the middle
        let barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width/2, y: gameView.bounds.midY -  barrierSize.height/2)
        //Lets create the bezierPath a circle using ovalInRect
        let path = UIBezierPath(ovalInRect: CGRect(origin:barrierOrigin, size: barrierSize))
        dropItBehavior.addBarrier(path, named: PathNames.MiddleBarrier)
        //Lets see the Path
        gameView.setPath(path, named: PathNames.MiddleBarrier)
    }
        
    

    @IBOutlet weak var gameView: BezierPathsView!
    
    //Along the top of my view im going to drop those squares
    
    //Lets line them up on top. Lests make them evenly spaced
    var dropsPerRow = 10 // could make this configurable and set it in settings
    
    //So lets calculate the size of each drop based on the amount of drops (dropsPerRow)
    var dropSize: CGSize {
        //We are making squares here
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow) //Equally divide my width
        return CGSize(width: size, height: size) //a square
        
        
    }

    @IBAction func grabDrop(sender: UIPanGestureRecognizer) {
        
       // 1. First we need to create the attachment
        //get the point which is just the senders location in our gameView
        let gesturePoint = sender.locationInView(gameView)
        
        //2. As it moves we are just going to move the anchor point
        // Here we switch on what stae we are in
        switch sender.state{
            //if we r in began I am just going to create the attachment
        case .Began:
            //In case lastDroppedView is not around
            if let viewToAttachTo = lastDroppedView{
            //Start the attachment business
            attachment = UIAttachmentBehavior(item: viewToAttachTo, attachedToAnchor: gesturePoint)
                //Lets add a feature that if u grab onto something u cant grab on to it again
                lastDroppedView = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
            
          //3 At the end we will set the attachment back to nil
        case .Ended:
            attachment = nil
            
        default: break // might be attachment == nil in case a phonecall comes it
            
        }
        
        
        
    }
    
    
    var lastDroppedView: UIView?
    
    
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
//        gameView.addSubview(dropView)
        // add gravity
//        gravity.addItem(dropView) //Everything is going to start animating. I can add them later to start animating I can take them out to stop animating. ITS INSTANEOUS
//        
//        // add collider
//        collider.addItem(dropView)
        lastDroppedView = dropView
        
        //
        dropItBehavior.addDrop(dropView)
        
    }
    
    
    
    //This function look for rows thats full and clls reove drop on them. This will be call when the animator settles down. I can find that out using the dynamic animator's delegate. dynamicAnimatorDidPause
    
    func removeCompletedRow()
    {
       var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        repeat{
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
            for _ in 0 ..< dropsPerRow {
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil){
                    if hitView.superview == gameView {
                        dropsFound.append(hitView)
                        
            } else {
                rowIsComplete = false
            }
        }
        dropFrame.origin.x += dropSize.width
    }
    if rowIsComplete {
    dropsToRemove += dropsFound
    
    }
    
            
        } while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        
        for drop in dropsToRemove {
            dropItBehavior.removeDrop(drop)
            
        }
        
    }
   
    
    //MARK : UIDynamicAnimatorDelegate Methods
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    //MARK: get the dropViews
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(subview)
            }
        }
        return results
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



