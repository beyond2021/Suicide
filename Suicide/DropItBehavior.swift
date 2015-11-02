//
//  DropItBehavior.swift
//  Suicide
//
//  Created by KEEVIN MITCHELL on 11/2/15.
//  Copyright © 2015 Beyond 2021. All rights reserved.
//

import UIKit

class DropItBehavior: UIDynamicBehavior {
    
    //Let make em fall
    
    //let take the default magnitude and direction which is down at 1000 points/sec/sec
    let gravity = UIGravityBehavior() //Create gravity
    
    
    //To make the containers
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        //I am doing it with a clousure because I want to configure it. I want to tyraslate the reference bounds into a boundary.
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true// Any intems in this will bounce off
        return lazilyCreatedCollider
        
    }()
    
    //Stop the blocks from tumbling and make them bounce hnigher
    lazy var dropBehavior: UIDynamicItemBehavior =  {
        let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        //Lets make it NOT ROTATE
        lazilyCreatedDropBehavior.allowsRotation = false
        // Lets make it bouncier elasticity
        lazilyCreatedDropBehavior.elasticity = 0.75
        return lazilyCreatedDropBehavior
        
    }()
    
    
    
    override init(){
       super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        //Add drop Behavior
        addChildBehavior(dropBehavior)
        
    }
    
    func addDrop(drop:UIView){
        //Add the drop to the referenceView right here
        dynamicAnimator?.referenceView?.addSubview(drop)
        
        gravity.addItem(drop)
        collider.addItem(drop)
        
        // Add drops to it
        dropBehavior.addItem(drop)
        
    }
    
    func removeDrop (drop:UIView) {
        //Remove item here
        gravity.removeItem(drop)
        collider.removeItem(drop)
        collider.removeItem(drop)
        drop.removeFromSuperview()
        
        
    }
    
    

}
