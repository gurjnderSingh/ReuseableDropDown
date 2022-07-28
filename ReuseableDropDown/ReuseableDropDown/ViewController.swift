//
//  ViewController.swift
//  ReuseableDropDown
//
//  Created by Gurjinder Singh on 28/07/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnShowDropDown: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnShowDropDown.setTitle("Choose City", for: .normal)
        btnShowDropDown.delegate = self
        btnShowDropDown.layer.cornerRadius = 10
        view.backgroundColor = .white
    }


    @IBAction func tapDropDown() {}
}

extension ViewController: DropDownDelegate {
    func didTapCell(value: String) {
        btnShowDropDown.setTitle(value, for: .normal)
    }
}

