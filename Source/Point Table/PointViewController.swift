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
    @IBOutlet weak var valueTextField: UITextField! {
        didSet {
            valueTextField.delegate = self
        }
    }
    
    @IBAction private func save() {
        guard let text = valueTextField.text, Meta.instance.valueFormatter.number(from: text) != nil else {
            valueTextField.becomeFirstResponder()
            return
        }
        
        delegate?.pointViewControllerDidRequestSave(self)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let point = point {
            title = Meta.instance.dateFormatter.string(from: point.date)
            navigationItem.leftBarButtonItem = nil
            
            datePicker.date = point.date
            valueTextField.text = Meta.instance.valueFormatter.string(from: NSNumber(value: point.value))
        }
        else {
            title = "New Point"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        valueTextField.becomeFirstResponder()
    }

}

extension PointViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save()
        return false
    }
}




