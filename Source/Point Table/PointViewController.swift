//
//  PointViewController.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

protocol PointViewControllerDelegate: class {
    func pointViewControllerDidRequestSave(_ controller: PointViewController)
}

class PointViewController: UIViewController {
    weak var delegate: PointViewControllerDelegate?
    
    var point: Point?
    
    // MARK: Implementation
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var valueTextField: UITextField!
    
    private lazy var dateFormatter: DateFormatter = {
        return DateFormatter()
    }()
    
    private lazy var valueFormatter: NumberFormatter = {
        return NumberFormatter()
    }()

    @IBAction private func save(_ sender: UIBarButtonItem) {
        delegate?.pointViewControllerDidRequestSave(self)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let point = point {
            title = dateFormatter.string(from: point.date)
            datePicker.date = point.date
            valueTextField.text = valueFormatter.string(from: NSNumber(value: point.value))
        }
        else {
            title = "New Point"
        }
    }

}
