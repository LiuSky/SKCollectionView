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
    
    fileprivate lazy var tableView: UITableView = {
        
        let temporaryTableView = UITableView()
        temporaryTableView.backgroundColor = UIColor.white
        temporaryTableView.backgroundView = nil
        temporaryTableView.dataSource = self
        temporaryTableView.delegate = self
        temporaryTableView.tableFooterView = UIView()
        temporaryTableView.register(UITableViewCell.self , forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        return temporaryTableView
    }()
    
    
    var array = ["OrdinaryViewController","PinterestViewController","StickyHeadersViewController","NoSolidWideViewController","AppStoreCollectionViewController"]
    
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
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ConllectionView集合"
        configurationView()
        configurationLocation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var indexPath = self.tableView.indexPathForSelectedRow
        if  indexPath == nil {
            indexPath = IndexPath(row: 0, section: 0)
        }
        self.tableView.deselectRow(at: indexPath!, animated:true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: -
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))
        cell?.textLabel?.text = "\(array[indexPath.row])"
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let className = "SKCollectionView.\(self.array[indexPath.row])"
        let aClass = NSClassFromString(className) as! UIViewController.Type
        let viewController = aClass.init()
        viewController.title = "\(self.array[indexPath.row])"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
