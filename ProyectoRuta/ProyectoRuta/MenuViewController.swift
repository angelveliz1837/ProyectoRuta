//
//  MenuViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 20/11/24.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func goToTrabajador(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegistroTrabajadorViewController") as? RegistroTrabajadorViewController
        viewController?.modalTransitionStyle = .coverVertical
        viewController?.modalPresentationStyle = .overCurrentContext
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    
    func goToBus(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegistroBusViewController") as? RegistroBusViewController
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    
    func gotoParadero(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegistroParaderoViewController") as? RegistroParaderoViewController
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    
    func gotoCerrar(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    

    @IBAction func didTapTrabajador(_ sender: UIButton) {
        goToTrabajador()
    }
    
    @IBAction func didTapBus(_ sender: UIButton) {
        goToBus()
    }
    
    @IBAction func didTapParadero(_ sender: UIButton) {
        gotoParadero()
    }
    
    
    @IBAction func didTapReporte(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapRuta(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapCerrar(_ sender: UIButton) {
        gotoCerrar()
    }
    
}
