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
        // Aseguramos que el campo de contraseña oculte el texto como asteriscos
        contraseniaTextField.isSecureTextEntry = true
    }
    
    // Función para mostrar alertas
        func mostrarAlerta(mensaje: String) {
            let alerta =    UIAlertController(title: "Error",
                            message: mensaje, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alerta, animated: true, completion: nil)
        }
        
    // Función para manejar el botón "Ingresar"
    func handleIngresar() {
        guard   let correo      = correoTextField.text, !correo.isEmpty,
                let contrasenia = contraseniaTextField.text, !contrasenia.isEmpty
        else {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }
        
        // Verificar credenciales guardadas en UserDefaults
        let savedCorreo         = UserDefaults.standard.string(forKey: "correo")
        let savedContrasenia    = UserDefaults.standard.string(forKey: "contrasenia")
        
        if correo != savedCorreo || contrasenia != savedContrasenia {
            mostrarAlerta(mensaje: "Credenciales incorrectas.")
            return
        }
        
        clearTextField()
    }
    
    func clearTextField() {
        correoTextField.text = ""
        contraseniaTextField.text = ""
        correoTextField.becomeFirstResponder() //focus
    }
    
    // Acción del botón "Ingresar"
    @IBAction func didTapIngresar(_ sender: UIButton) {
        handleIngresar()
    }
    
    // Acción del botón "Ir a Registrar"
    @IBAction func didTapIrRegistrar(_ sender: UIButton) {
        print("Navegando a la pantalla de registro")
    }
}
