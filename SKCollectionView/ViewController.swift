//
//  ViewController.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 16/3/9.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        
        let temporaryTableView = UITableView()
        temporaryTableView.backgroundColor = UIColor.whiteColor()
        temporaryTableView.backgroundView = nil
        temporaryTableView.dataSource = self
        temporaryTableView.delegate = self
        temporaryTableView.tableFooterView = UIView()
        temporaryTableView.registerClass(UITableViewCell.self , forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        return temporaryTableView
    }()
    
    
    var array = ["OrdinaryViewController","WaterfallViewController","PinterestViewController","StickyHeadersViewController"]
    
    /**
     配置View
     */
    func configurationView() {
        view.addSubview(tableView)
    }
    
    /**
     配置位置
     */
    func configurationLocation() {
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ConllectionView集合"
        configurationView()
        configurationLocation()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var indexPath = self.tableView.indexPathForSelectedRow
        if  indexPath == nil {
            indexPath = NSIndexPath(forRow: 0, inSection: 0)
        }
        self.tableView.deselectRowAtIndexPath(indexPath!, animated:true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: -
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self))
        cell?.textLabel?.text = "\(array[indexPath.row])"
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let className = "SKCollectionView.\(self.array[indexPath.row])"
        let aClass = NSClassFromString(className) as! UIViewController.Type
        let viewController = aClass.init()
        viewController.title = "\(self.array[indexPath.row])"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
