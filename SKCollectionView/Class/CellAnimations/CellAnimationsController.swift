//
//  CellAnimationsController.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/6/13.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit

class CellAnimationsController: UICollectionViewController {
    
    var colors: [UIColor] = []
    var layout = Layout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...20 {
            colors.append(UIColor.randomColor())
        }
        collectionView?.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.kind)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.kind, for: indexPath) as! ContentCell
        cell.backgroundColor = colors[indexPath.item]
        cell.label.text = "Cell \(indexPath.item)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        layout.selectedCellIndexPath = layout.selectedCellIndexPath == indexPath ? nil : indexPath
        
        let bounceEnabled = false
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: bounceEnabled ? 0.5 : 1.0,
            initialSpringVelocity: bounceEnabled ? 2.0 : 0.0,
            options: UIViewAnimationOptions(),
            animations: {
                self.layout.invalidateLayout()
                self.collectionView?.layoutIfNeeded()
        },
            completion: nil
        )
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

struct Number {
    static func random(from: Int, to: Int) -> Int {
        guard from < to else { fatalError("`from` MUST be less than `to`") }
        let delta = UInt32(to + 1 - from)
        
        return from + Int(arc4random_uniform(delta))
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        
        let red = CGFloat(Number.random(from: 0, to: 255)) / 255.0
        let green = CGFloat(Number.random(from: 0, to: 255)) / 255.0
        let blue = CGFloat(Number.random(from: 0, to: 255)) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
