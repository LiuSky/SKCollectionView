//
//  TrackingScrollView.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/5/25.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit


/// MARK - TrackingScrollView
public class TrackingScrollView: UIScrollView {

    weak var trackingView: UIView? {
        willSet {
            trackingView?.removeGestureRecognizer(panGestureRecognizer)
        }
        didSet {
            trackingView?.addGestureRecognizer(panGestureRecognizer)
            frame = trackingView?.bounds ?? .zero
        }
    }
    
    
    var trackingFrame: CGRect = CGRect.zero {
        didSet {
            contentSize = trackingFrame.size
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.contents = UIImage().cgImage
        panGestureRecognizer.maximumNumberOfTouches = 1
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.contents = UIImage().cgImage
        panGestureRecognizer.maximumNumberOfTouches = 1
    }
    
    
    // MARK - 询问一个手势接收者是否应该开始解释执行一个触摸接收事件
    @objc public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, panGestureRecognizer === self.panGestureRecognizer else {
            return false
        }
        
        let positionInTrackingView = panGestureRecognizer.location(in: trackingView)
        return trackingFrame.contains(positionInTrackingView)
    }
    
    
    // MARK - 询问delegate，两个手势是否同时接收消息，返回YES同时接收。返回NO，不同是接收（如果另外一个手势返回YES，则并不能保证不同时接收消息）the default implementation returns NO。
    // 这个函数一般在一个手势接收者要阻止另外一个手势接收自己的消息的时候调用
    @objc fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, panGestureRecognizer === self.panGestureRecognizer else {
            return false
        }
        guard let otherPanGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer, otherPanGestureRecognizer.delegate is TrackingScrollView && otherPanGestureRecognizer.view === trackingView else {
            return false
        }
        
        return true
    }
    
    // MARK - 询问delegate是否允许手势接收者接收一个touch对象
    // 返回YES，则允许对这个touch对象审核，NO，则不允许。
    // 这个方法在touchesBegan:withEvent:之前调用，为一个新的touch对象进行调用
    @objc fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, self.panGestureRecognizer === panGestureRecognizer else {
            return false
        }
        
        let positionInTrackingView = touch.location(in: trackingView)
        return trackingFrame.contains(positionInTrackingView)
    }
}
