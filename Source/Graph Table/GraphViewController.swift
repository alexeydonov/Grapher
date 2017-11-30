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
    
    var graph: Graph?
    
    // MARK: Implementation
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet weak var colorSlider: UISlider!
    
    @IBAction func colorChanged(_ sender: UISlider) {
        colorView.backgroundColor = UIColor(hue: CGFloat(sender.value), saturation: 1.0, brightness: 0.5, alpha: 1)
    }
    
    @IBAction private func save() {
        guard let text = nameTextField.text, !text.isEmpty else {
            nameTextField.becomeFirstResponder()
            return
        }
        
        delegate?.graphViewControllerDidRequestSave(self)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let graph = graph {
            title = graph.name
            colorSlider.value = graph.color
            colorView.backgroundColor = UIColor(hue: CGFloat(graph.color), saturation: 1.0, brightness: 0.5, alpha: 1.0)
        }
        else {
            title = "New Graph"
            colorView.backgroundColor = UIColor(hue: 0.5, saturation: 1, brightness: 0.5, alpha: 1.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
}

extension GraphViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save()
        
        return false
    }
}



