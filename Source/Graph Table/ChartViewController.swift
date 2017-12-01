//
//  ChartViewController.swift
//  Grapher
//
//  Created by Alexey Donov on 01/12/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

protocol ChartViewControllerDelegate: class {
    func chartViewController(_ controller: ChartViewController, didUpdateChart chart: Chart)
}

class ChartViewController: UIViewController {
    weak var delegate: ChartViewControllerDelegate?
    
    var chart: Chart? {
        didSet {
            points = chart?.points.sorted { $0.date > $1.date } ?? []
        }
    }
    
    // MARK: Implementation
    
    private struct UI {
        static let pointTableViewCellIdentifier = "Point Cell"
        static let showPointSegueIdentifier = "Show Point"
        static let addPointSegueIdentifier = "Add Point"
    }
    
    private var points: [Point] = []
    
    @IBOutlet private var pointTableView: UITableView!
    
    @objc private func save() {
        
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let chart = self.chart {
            title = chart.name
        }
        else {
            title = "New Chart"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // TODO: Animate
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch segueIdentifier {
        case UI.showPointSegueIdentifier:
            guard let controller = segue.destination.contentViewController as? PointViewController else { break }
            guard let cell = sender as? UITableViewCell, let indexPath = pointTableView.indexPath(for: cell) else { break }
            controller.delegate = self
            controller.point = points[indexPath.row]
            
        case UI.addPointSegueIdentifier: break
            
        default: break
        }
    }
}

extension ChartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UI.pointTableViewCellIdentifier, for: indexPath)
        
        let point = points[indexPath.row]
        cell.textLabel?.text = Meta.instance.dateFormatter.string(from: point.date)
        cell.detailTextLabel?.text = Meta.instance.valueFormatter.string(from: NSNumber(value: point.value))
        
        return cell
    }
}

extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
}

extension ChartViewController: PointViewControllerDelegate {
    func pointViewController(_ controller: PointViewController, didUpdatePoint point: Point) {
        if let existingPoint = controller.point {
            // TODO: Update point
        }
        else {
            chart?.points.append(point)
            pointTableView.reloadData()
        }
    }
}











