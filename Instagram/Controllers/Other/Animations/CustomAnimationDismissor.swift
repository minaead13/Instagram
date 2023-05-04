//
//  CustomAnimationDismissor.swift
//  Instagram
//
//  Created by Mina on 04/05/2023.
//

import UIKit

class CustomAnimationDismissor : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let formView = transitionContext.view(forKey: .from) else { return }
        guard let toview = transitionContext.view(forKey: .to) else { return }
        
        container.addSubview(toview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut , animations:  {
            formView.frame = CGRect(x: -formView.frame.width, y: 0, width: formView.frame.width, height: formView.frame.height)
            
            toview.frame = CGRect(x: 0, y: 0, width: toview.frame.width, height: toview.frame.height)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
