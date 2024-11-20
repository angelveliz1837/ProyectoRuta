//
//  RegistroViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 20/11/24.
//

import UIKit

class RegistroViewController: UIViewController {
    
    
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseniaTextField: UITextField!
    
    var correo: String = ""
    var contrasenia: String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getData(){
        correo = correoTextField.text ?? ""
        contrasenia = contraseniaTextField.text ?? ""
        goToResultScreen()
    }
    
    //Funcion para enviar datos a otra vista
    func goToResultScreen(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PaseUsuarioViewController") as? PaseUsuarioViewController
        viewController?.correoResult = correo
        viewController?.contraseniaResult = contrasenia
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    
    func gotoVolver(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
        
    }
    
    
    @IBAction func didTapGuardar(_ sender: UIButton) {
        getData()
    }
    

    @IBAction func didTapVolver(_ sender: UIButton) {
        gotoVolver()
    }
    

}
