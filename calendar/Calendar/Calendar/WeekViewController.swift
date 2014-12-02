//
//  WeekViewController.swift
//  Calendar
//
//  Created by Jeff Conniff on 9/25/14.
//  Copyright (c) 2014 jconniff. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var timesScrollView: UIScrollView!
    @IBOutlet weak var dateHeadScrollView: UIScrollView!
    @IBOutlet weak var dateHeadLabel: UILabel!
    @IBOutlet weak var scrollViewBody: UIScrollView!
    @IBOutlet weak var dayHeadImageView: UIImageView!
    @IBOutlet weak var alldayScrollView: UIScrollView!
    
    @IBOutlet weak var timeImageView: UIImageView!
    
    @IBAction func eventButton(sender: AnyObject) {
        //var dayView: ViewController = DayViewController
        
        performSegueWithIdentifier("segueToEvent", sender: self)
    }
    @IBAction func pinchMainView(sender: UIPinchGestureRecognizer) {
        var scale: CGFloat = sender.scale // scale relative to the touch points in screen coordinates
        var velocity: CGFloat = sender.velocity  // velocity of the pinch in scale/second

        if (velocity <= -1) {
            println("pinch scale: \(scale) velocity: \(velocity)")
            performSegueWithIdentifier("segueToMonth", sender: self)

        }
        
    }
    @IBAction func buttonBackTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dateHeadScrollView.contentSize = CGSize(width: 1869, height: 20)
        timesScrollView.contentSize = CGSize(width: 40, height: 1393)
        scrollViewBody.contentSize = CGSize(width: 1869, height: 1045)
        alldayScrollView.contentSize = CGSize(width:1869, height: 40)
        scrollViewBody.delegate = self

        //set initial time of day
        scrollViewBody.contentOffset.y = 325
        scrollViewBody.contentOffset.x = 363

        scrollViewBody.contentInset = UIEdgeInsetsZero;
        scrollViewBody.pagingEnabled = true;
        
        // Do any additional setup after loading the view.
    }
    
    
    func scrollViewDidScroll(scrollViewBody: UIScrollView!) {
        // This method is called as the user scrolls
        
        var offSet = scrollViewBody.contentOffset
        println("offset: \(offSet)")
        timeImageView.frame.origin.y = -offSet.y
        dayHeadImageView.frame.origin.x = -offSet.x - 9
        alldayScrollView.frame.origin.x = -offSet.x + 54
        
    }
    
    ///////////////////////////////////////////////
    // custom view controller Transition
    
    var isPresenting: Bool = true
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationVC = segue.destinationViewController as UIViewController
        destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationVC.transitioningDelegate = self
        
    }
    
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
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if (isPresenting) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
            }
        } else {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
            }
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
