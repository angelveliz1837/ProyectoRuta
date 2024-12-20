//
//  LoginViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseniaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuración inicial
        contraseniaTextField.isSecureTextEntry = true
        contraseniaTextField.autocapitalizationType = .none  // Asegúrate de que no se capitalice la contraseña
        contraseniaTextField.textContentType = .password    // Especifica que es un campo de contraseña
        
        // Verificar si el usuario ya está logueado al inicio
        verificarUsuarioLogueado()
    }
    
    // Verificar si el usuario ya está logueado (Firebase o UserDefaults)
    func verificarUsuarioLogueado() {
        if let user = Auth.auth().currentUser {
            // El usuario ya está logueado con Firebase
            irAlMenuPrincipal()
        } else {
            // Verificar con UserDefaults si hay credenciales guardadas
            if let email = UserDefaults.standard.string(forKey: "email"),
               let password = UserDefaults.standard.string(forKey: "password") {
                irAlMenuPrincipal()
            }
        }
    }
    
    // Navegar al menú principal
    func irAlMenuPrincipal() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
            // Si tu vista está dentro de un UINavigationController
            if let navigationController = self.navigationController {
                navigationController.pushViewController(menuViewController, animated: true)
            } else {
                // Si no estás usando un UINavigationController, presenta el controlador normalmente
                self.present(menuViewController, animated: true, completion: nil)
            }
        } else {
            print("Error: No se pudo encontrar el controlador MenuViewController")
        }
    }
    
    // Mostrar alerta con mensaje
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
    
    // Manejo de credenciales almacenadas en UserDefaults
    func manejarCredenciales(email: String, password: String) -> Bool {
        if let savedCorreo = UserDefaults.standard.string(forKey: "email"),
           let savedContrasenia = UserDefaults.standard.string(forKey: "password"),
           email == savedCorreo && password == savedContrasenia {
            return true
        }
        return false
    }
    
    // Intentar iniciar sesión con Firebase
    func loginConFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error al iniciar sesión en Firebase: \(error.localizedDescription)")
                self.mostrarAlerta(mensaje: "Credenciales incorrectas.")
            } else {
                // Redirigir al menú solo una vez
                self.irAlMenuPrincipal()
            }
        }
    }
    
    // Manejar el botón "Ingresar"
    func handleIngresar() {
        guard let email = correoTextField.text, !email.isEmpty,
              let password = contraseniaTextField.text, !password.isEmpty else {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }
        
        // Validar credenciales con UserDefaults
        if manejarCredenciales(email: email, password: password) {
            irAlMenuPrincipal()
            return
        }
        
        // Intentar iniciar sesión con Firebase
        loginConFirebase(email: email, password: password)
    }
    
    // Registrar usuario con Firebase
    func registerUser() {
        guard let email = correoTextField.text, !email.isEmpty,
              let password = contraseniaTextField.text, !password.isEmpty else {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error al registrar usuario: \(error.localizedDescription)")
                self.mostrarAlerta(mensaje: "Error al registrar usuario.")
            } else {
                print("Usuario registrado con éxito.")
                self.irAlMenuPrincipal()
            }
        }
    }
    
    // Limpiar campos de texto
    func clearTextField() {
        correoTextField.text = ""
        contraseniaTextField.text = ""
        correoTextField.becomeFirstResponder()
    }
    
    // Acciones de botones
    @IBAction func didTapIngresar(_ sender: UIButton) {
        handleIngresar()
    }
    
    @IBAction func didTapIrRegistrar(_ sender: UIButton) {
        print("Navegando a la pantalla de registro")
    }
    
    @IBAction func didTapRegistro(_ sender: UIButton) {
        registerUser()
    }
}
