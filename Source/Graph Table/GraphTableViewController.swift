//
//  GraphTableViewController.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

class GraphTableViewController: UITableViewController {
    var graphs: [Graph] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // MARK: Implementation
    
    private struct UI {
        static let graphCellIdentifier = "Graph Cell"
        static let detailsSegueIdentifier = "Show Details"
        static let addGraphSegueIdentifier = "Add Graph"
        static let editGraphSegueIdentifier = "Edit Graph"
    }
    
    private lazy var valueFormatter: NumberFormatter = {
        return NumberFormatter()
    }()
    
    // UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch segueIdentifier {
        case UI.detailsSegueIdentifier:
            guard let ptvc = segue.destination as? PointTableViewController else { return }
            ptvc.delegate = self
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                ptvc.graph = graphs[indexPath.row]
            }
            
        case UI.addGraphSegueIdentifier:
            guard let gvc = segue.destination as? GraphViewController else { return }
            gvc.delegate = self
            gvc.graph = nil
            
        case UI.editGraphSegueIdentifier:
            guard let gvc = segue.destination as? GraphViewController else { return }
            gvc.delegate = self
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                gvc.graph = graphs[indexPath.row]
            }
            
        default: break
        }
    }
    
    // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graphs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let graph = graphs[indexPath.row]
        let sortedValues = graph.points.sorted { $0.date < $1.date }.map { $0.value }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UI.graphCellIdentifier, for: indexPath) as! GraphTableViewCell
        cell.nameLabel.text = graph.name
        cell.valueLabel.text = sortedValues
            .last
            .flatMap(NSNumber.init(value:))
            .flatMap(valueFormatter.string(from:))
        cell.graphView.graphColor = UIColor(hue: CGFloat(graph.color), saturation: 1.0, brightness: 0.5, alpha: 1.0)
        cell.graphView.values = sortedValues
        
        return cell
    }
}

extension GraphTableViewController: GraphViewControllerDelegate {
    func graphViewControllerDidRequestSave(_ controller: GraphViewController) {
        if let _ = controller.graph {
            
        }
        else {
            let newGraph = Graph(name: controller.nameTextField.text ?? "", color: controller.colorSlider.value, points: [])
            graphs.append(newGraph)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension GraphTableViewController: PointTableViewControllerDelegate {
    func pointTableViewControllerUpdatedGraph(_ controller: PointTableViewController) {
        // TODO: Update own's graph array
    }
}

