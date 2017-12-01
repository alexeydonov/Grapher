//
//  GraphViewController.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

protocol GraphViewControllerDelegate: class {
    func graphViewControllerDidRequestSave(_ controller: GraphViewController)
}

class GraphViewController: UIViewController {
    weak var delegate: GraphViewControllerDelegate?
    
    var graph: Chart?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var colorSlider: UISlider!
    
    @IBOutlet weak var minTextField: UITextField!
    
    @IBOutlet weak var maxTextField: UITextField!
    
    @IBOutlet weak var thresholdTextField: UITextField!
    
    // MARK: Implementation
    
    @IBAction private func colorChanged(_ sender: UISlider) {
        let color = UIColor(hue: CGFloat(sender.value), saturation: 1.0, brightness: 0.5, alpha: 1)
        sender.minimumTrackTintColor = color
        sender.maximumTrackTintColor = color
    }
    
    @IBAction private func save() {
        guard let text = nameTextField.text, !text.isEmpty else {
            nameTextField.becomeFirstResponder()
            return
        }
        
        if let text = minTextField.text, !text.isEmpty {
            if Meta.instance.valueFormatter.number(from: text) == nil {
                minTextField.becomeFirstResponder()
                return
            }
        }
        
        if let text = maxTextField.text, !text.isEmpty {
            if Meta.instance.valueFormatter.number(from: text) == nil {
                maxTextField.becomeFirstResponder()
                return
            }
        }
        
        if let text = thresholdTextField.text, !text.isEmpty {
            if Meta.instance.valueFormatter.number(from: text) == nil {
                thresholdTextField.becomeFirstResponder()
                return
            }
        }
        
        delegate?.graphViewControllerDidRequestSave(self)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let graph = graph {
            title = graph.name
            navigationItem.leftBarButtonItem = nil
            
            colorSlider.value = graph.color
            
            nameTextField.text = graph.name
            
            let color = UIColor(hue: CGFloat(graph.color), saturation: 1.0, brightness: 0.5, alpha: 1.0)
            colorSlider.minimumTrackTintColor = color
            colorSlider.maximumTrackTintColor = color
            
            if let min = graph.min {
                minTextField.text = Meta.instance.valueFormatter.string(from: NSNumber(value: min))
            }
            if let max = graph.max {
                maxTextField.text = Meta.instance.valueFormatter.string(from: NSNumber(value: max))
            }
        }
        else {
            title = "New Graph"
            
            let color = UIColor(hue: 0.5, saturation: 1, brightness: 0.5, alpha: 1.0)
            colorSlider.minimumTrackTintColor = color
            colorSlider.maximumTrackTintColor = color
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
}

extension GraphViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameTextField {
            minTextField.becomeFirstResponder()
            return false
        }
        
        if textField === minTextField {
            maxTextField.becomeFirstResponder()
            return false
        }
        
        if textField === maxTextField {
            thresholdTextField.becomeFirstResponder()
            return false
        }
        
        if textField === thresholdTextField {
            save()
            return false
        }
        
        return true
    }
}



