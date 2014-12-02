//
//  DayViewController.swift
//  Calendar
//
//  Created by Jeff Conniff on 9/25/14.
//  Copyright (c) 2014 jconniff. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var navBarView: UIImageView!
    @IBOutlet weak var bkgLeavesView: UIImageView!
    @IBOutlet weak var octLabel: UILabel!
    @IBOutlet weak var quicViewInfo: UIImageView!
    @IBOutlet weak var dateBoxView: UIView!
    @IBOutlet weak var headLabel: UILabel!
    
    @IBOutlet weak var agendaView: UIScrollView!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var glassView: UIImageView!
    
    @IBAction func toTopBtn(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            //
            self.agendaView.contentOffset.y = 0
            }) { (finished: Bool) -> Void in
            //
        }
    }
    @IBAction func agendaButton(sender: AnyObject) {
       // agendaView.w(label)
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            //code
            self.agendaView.contentOffset.y = 533
            }) { (finished: Bool) -> Void in
                // after anim
        }
        println("event button")
    }

    var para: CGFloat = 40 //paralax initial animation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agendaView.delegate = self
        
        var headHeight: CGFloat = 60
        var blurContainerStopAtY: CGFloat = 145
        var blurContH: CGFloat = blurContainerView.frame.height
        
        agendaView.contentSize = CGSize(width: 320, height: 2800)

        blurContainerView.frame.origin.y = 568 - headHeight
        
        glassView.frame.origin.y = 0 - blurContH - blurContainerStopAtY - headHeight
        
        quicViewInfo.frame.origin.y = blurContainerView.frame.origin.y
        
        // initial animation of glass blur and quick view including paralax
        UIView.animateWithDuration(1, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.bkgLeavesView.frame.origin.y = -self.para

            self.blurContainerView.frame.origin.y = blurContainerStopAtY
            self.quicViewInfo.frame.origin.y = blurContainerStopAtY
                
            self.glassView.frame.origin.y = (-blurContainerStopAtY - headHeight) - self.para
            
            
            
            }) { (finished: Bool) -> Void in
            
            //code after anim
                self.glassInitialY = self.glassView.frame.origin.y
                self.bkgLeavesInitialY = self.bkgLeavesView.frame.origin.y
        }
    
    }

    var glassInitialY: CGFloat!
    var bkgLeavesInitialY: CGFloat!
    
    func scrollViewDidScroll(agendaView : UIScrollView) {
        
        var offY: CGFloat = agendaView.contentOffset.y
        var dist: CGFloat = 120
        println("scrolled agenda: \(offY)")
        
        if (offY <= dist) {
            dateBoxView.alpha = (dist - offY) / dist
            navBarView.alpha = offY / dist
            headLabel.alpha = offY / dist
        } else {
            dateBoxView.alpha = 0
            navBarView.alpha = 1
            headLabel.alpha = 1
        }
        glassView.frame.origin.y = glassInitialY + offY - (offY * 0.24)
        bkgLeavesView.frame.origin.y = bkgLeavesInitialY - (offY * 0.24)
        if (offY >= 507) {
            //bkgLeavesView.frame.origin.y = -para - offY * 0.05
            
        }
        
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
