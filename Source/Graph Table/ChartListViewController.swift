//
//  GraphListViewController.swift
//  Grapher
//
//  Created by Alexey Donov on 01/12/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

class ChartListViewController: ListViewController {
    var charts: [Chart] = []
    
    // MARK: Implementation
    
    private struct UI {
        static let chartTableViewCellIdentifier = "Graph Cell"
        static let showChartSegueIdentifier = "Show Chart"
        static let addChartSegueIdentifier = "Add Chart"
    }
    
    private func loadCharts() {
        if let data = UserDefaults.standard.array(forKey: "charts") as? [[String : Any]] {
            charts = data.flatMap(Chart.init(with:))
        }
    }
    
    private func saveCharts() {
        UserDefaults.standard.setValue(charts.map { $0.propertyList }, forKey: "charts")
    }
    
    @IBAction private func unwindToChartList(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyListLabel.text = "No Charts"
        
        loadCharts()
        navigationItem.rightBarButtonItems?.insert(editButtonItem, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch segueIdentifier {
        case UI.showChartSegueIdentifier:
            guard let controller = segue.destination.contentViewController as? ChartViewController else { break }
            controller.delegate = self
            
        case UI.addChartSegueIdentifier: break
            
        default: break
        }
    }
}

extension ChartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UI.chartTableViewCellIdentifier, for: indexPath) as! ChartTableViewCell
        
        let chart = charts[indexPath.row]
        let sortedValues = chart.points.sorted { $0.date < $1.date }.map { $0.value }
        cell.nameLabel.text = chart.name
        cell.valueLabel.text = sortedValues
            .last
            .flatMap(NSNumber.init(value:))
            .flatMap(Meta.instance.valueFormatter.string(from:))
        cell.chartView.graphColor = UIColor(hue: CGFloat(chart.color), saturation: 1.0, brightness: 0.5, alpha: 1.0)
        cell.chartView.min = chart.min
        cell.chartView.max = chart.max
        cell.chartView.values = sortedValues
        
        return cell
    }
}

extension ChartListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIView.setAnimationsEnabled(false)
            let contentOffset = tableView.contentOffset
            
            tableView.beginUpdates()
            charts.remove(at: indexPath.row)
            saveCharts()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            tableView.contentOffset = contentOffset
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension ChartListViewController: ChartViewControllerDelegate {
    func chartViewController(_ controller: ChartViewController, didUpdateChart chart: Chart) {
        if let index = charts.index(where: { $0.name == chart.name }) {
            charts[index] = chart
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}











