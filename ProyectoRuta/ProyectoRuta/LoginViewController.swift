//
//  LoginViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseniaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    

    @IBAction func didTapIngresar(_ sender: UIButton) {
        guard let correo = correoTextField.text, !correo.isEmpty,
              let contrasenia = contraseniaTextField.text, !contrasenia.isEmpty else {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }
        
        // Verificar credenciales
        let savedCorreo = UserDefaults.standard.string(forKey: "correo")
        let savedContrasenia = UserDefaults.standard.string(forKey: "contrasenia")
        
        if correo == savedCorreo && contrasenia == savedContrasenia {

        } else {
            mostrarAlerta(mensaje: "Credenciales incorrectas.")
        }
    }
    
    
    @IBAction func didTapIrRegistrar(_ sender: UIButton) {

    }
    
    
    
}
