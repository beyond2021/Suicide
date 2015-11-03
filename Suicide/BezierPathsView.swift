//
//  BezierPathsView.swift
//  Suicide
//
//  Created by KEEVIN MITCHELL on 11/2/15.
//  Copyright © 2015 Beyond 2021. All rights reserved.
//  This draws as many bezier Paths as you want

import UIKit

class BezierPathsView: UIView {
    private var bezierPaths = [String : UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String){
        bezierPaths[name] = path
        
        //I just change my model so setNeedsDisplay
        setNeedsDisplay()
        
    }
    
    
    override func drawRect(rect: CGRect) {
        for(_, path) in bezierPaths {
            path.stroke()
        }
    }

}
