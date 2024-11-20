//
//  LoginViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 20/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func goToIngresar(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    
    
    
    func goToRegistrar(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegistroViewController") as? RegistroViewController
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        goToRegistrar()
    }
    
    
    @IBAction func didTapIngresar(_ sender: UIButton) {
        goToIngresar()
    }
    
    
}
