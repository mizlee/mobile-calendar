//
//  MonthViewController.swift
//  Calendar
//
//  Created by Jeff Conniff on 9/25/14.
//  Copyright (c) 2014 jconniff. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    @IBOutlet weak var dateTransLabel: UILabel!
    @IBOutlet weak var fakeWeek: UIImageView!
    @IBOutlet weak var monthImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    var isPresenting: Bool = true
    
    var whereTap: CGPoint!
    @IBAction func tapMonth(sender: UITapGestureRecognizer) {
        
        whereTap = sender.locationInView(view)
        performSegueWithIdentifier("segueToWeek", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1000)
        
        // Do any additional setup after loading the view.
    }

    
    //this sets up the custom transitions
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 1
    }
    
    var tempView: UIImageView!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        func calcDateStr(tap: CGPoint) ->NSString {
            // this function only works for oct 5 - 31
            // and will not work if the image changes
            
            println("whereTap: \(self.whereTap)")
            
            var row:Int = Int(floor((whereTap.y - 130) / 50)) // depends on dimensions of the image
            var col:Int = Int(floor(whereTap.x / 48)) // depends on dimensions of the image
            
            var num: Int64 = (row * 7 + 5 + col)
            var numA: Int64 = (row * 7 + 5)
            var numB: Int64 = (row * 7 + 11)
            var day: NSString!
            
            if (col == 0) {day = "Sun"}
            else if (col == 1) {day = "Mon"}
            else if (col == 2) {day = "Tue"}
            else if (col == 3) {day = "Wed"}
            else if (col == 4) {day = "Thur"}
            else if (col == 5) {day = "Fri"}
            else if (col == 6) {day = "Sat"}
            
            println("row: \(row) col: \(col) num-day: \(num) day: \(day)")
        
            return "Oct \(numA)-\(numB) 2014"
        }
        
        
        if (isPresenting) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
        
            var weekVC = toViewController as WeekViewController
            weekVC.dateHeadLabel.hidden = true
            
            // I decided not to create a tempView, but to just use the fakeWeek
            // println("tap \(whereTap)")
            
            // fakeWeek is in the out-most view in viewcontroller so it
            // has the coordinates of the whole page
            // It's easier to match the position of the weekView body this way
            
            self.fakeWeek.hidden = false
            self.dateTransLabel.hidden = false
            
            // starts small and at the tap point before animation begins
            self.fakeWeek.frame = CGRect(
                x: whereTap.x - 10,
                y: whereTap.y - 10,
                width: 20,
                height: 20
            )

            // I didn't have success at getting the date label font size to animate, 
            // so I animated the alpha instead
            // someone said, fontsize change works on phone but not simulator
            // self.dateTransLabel.font = UIFont(name: self.dateTransLabel.font.fontName, size: 2)
            
            self.dateTransLabel.alpha = 0
            self.dateTransLabel.frame = CGRect(x: whereTap.x - 160, y: whereTap.y - 10, width: 320, height: 20)
            
            // this is the normal way to change a label string
            self.dateTransLabel.text = "hello"
            
            // this changes the label string to a faux date string by calling the func calcDateStr
            self.dateTransLabel.text = calcDateStr(CGPoint(x: 3, y: 4))
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                
                self.fakeWeek.frame = CGRect(x: 53, y: 80, width: 696, height: 1045)
                self.dateTransLabel.frame.origin.x = 0
                self.dateTransLabel.frame.origin.y = 31
                
                // not working on simulator, do alpha instead
                // self.dateTransLabel.font = UIFont(name: self.dateTransLabel.font.fontName, size: 14)
                self.dateTransLabel.alpha = 1
                
                toViewController.view.alpha = 1
                
                }) { (finished: Bool) -> Void in
                    
                    // Add the dateLabel to the MonthViewController.view so it will stay after the transition
                    toViewController.view.addSubview(self.dateTransLabel)
                    transitionContext.completeTransition(true)
                    
                    // hide this so it won't show up next time we nav to the MonthView
                    self.fakeWeek.hidden = true
            }
            
        } else {
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    
                    // This was unhidden from WeekViewController, so need to hide it here
                    self.dateTransLabel.hidden = true
                    
                    // put it back in the MonthView
                    toViewController.view.addSubview(self.dateTransLabel)
                    
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    
            }
        }
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationVC = segue.destinationViewController as UIViewController
        destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationVC.transitioningDelegate = self
        
        // this var window needs to be inside this func
        var window = UIApplication.sharedApplication().keyWindow
        
        // we do need the dateTransLabel in the window so it can be added to the WeekViewController.view
        window.addSubview(self.dateTransLabel)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
