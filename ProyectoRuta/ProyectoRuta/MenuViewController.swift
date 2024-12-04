//
//  MenuViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapCerrar(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
