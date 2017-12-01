//
//  GraphTableViewController.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

class GraphTableViewController: UITableViewController {
    var graphs: [Graph] = [
        Graph(name: "Graph1", color: 0.5, points: [
            Point(date: Meta.instance.dateFormatter.date(from: "Nov 1, 2017")!, value: 10),
            Point(date: Meta.instance.dateFormatter.date(from: "Nov 2, 2017")!, value: 30),
            Point(date: Meta.instance.dateFormatter.date(from: "Nov 3, 2017")!, value: 80),
            Point(date: Meta.instance.dateFormatter.date(from: "Nov 4, 2017")!, value: 40)], threshold: nil),
        Graph(name: "Graph2", color: 0.7, points: [
            Point(date: Meta.instance.dateFormatter.date(from: "Oct 10, 2017")!, value: 0),
            Point(date: Meta.instance.dateFormatter.date(from: "Oct 11, 2017")!, value: 5),
            Point(date: Meta.instance.dateFormatter.date(from: "Oct 12, 2017")!, value: 40)], threshold: nil)
        ] {
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
    
    private func loadGraphs() {
        if let data = UserDefaults.standard.array(forKey: "graphs") as? [[String : Any]] {
            graphs = data.flatMap(Graph.init(with:))
        }
    }
    
    private func saveGraphs() {
        UserDefaults.standard.setValue(graphs.map { $0.propertyList }, forKey: "graphs")
    }
    
    // UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGraphs()
        navigationItem.rightBarButtonItems?.insert(editButtonItem, at: 0)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
            .flatMap(Meta.instance.valueFormatter.string(from:))
        cell.graphView.graphColor = UIColor(hue: CGFloat(graph.color), saturation: 1.0, brightness: 0.5, alpha: 1.0)
        cell.graphView.values = sortedValues
        
        return cell
    }
}

extension GraphTableViewController: GraphViewControllerDelegate {
    func graphViewControllerDidRequestSave(_ controller: GraphViewController) {
        if let _ = controller.graph {
            // TODO: Update color/name
        }
        else {
            let newGraph = Graph(name: controller.nameTextField.text ?? "", color: controller.colorSlider.value, points: [], threshold: nil)
            graphs.append(newGraph)
            saveGraphs()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension GraphTableViewController: PointTableViewControllerDelegate {
    func pointTableViewControllerUpdatedGraph(_ controller: PointTableViewController) {
        if let graph = controller.graph {
            if let index = graphs.index(where: { $0.name == graph.name }) {
                graphs[index].points = graph.points
                saveGraphs()
            }
        }
    }
}

