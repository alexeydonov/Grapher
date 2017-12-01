//
//  ListViewController.swift
//  Grapher
//
//  Created by Alexey Donov on 01/12/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private(set) lazy var emptyListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .lightGray
        label.backgroundColor = .white
        label.isOpaque = true
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(emptyListLabel)
        
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label" : emptyListLabel]))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label" : emptyListLabel]))
        NSLayoutConstraint.activate(constraints)
    }

}
