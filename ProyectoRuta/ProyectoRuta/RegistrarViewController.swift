import UIKit

class RegistrarViewController: UIViewController {

    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseniaTextField: UITextField!
    @IBOutlet weak var repetircontraseniaTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Valida que la contraseña cumpla con los requisitos de seguridad.
    func validarContrasenia(_ contrasenia: String) -> Bool {
        let patron = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let regex = NSPredicate(format: "SELF MATCHES %@", patron)
        return regex.evaluate(with: contrasenia)
    }
    
    /// Valida que el correo tenga el formato correcto.
    func validarCorreo(_ correo: String) -> Bool {
        let patron = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let regex = NSPredicate(format: "SELF MATCHES %@", patron)
        return regex.evaluate(with: correo)
    }

    /// Muestra una alerta con un mensaje.
    func mostrarAlerta(mensaje: String, accion: ((UIAlertAction) -> Void)? = nil) {
        let alerta = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: accion))
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        guard let correo = correoTextField.text, !correo.isEmpty,
              let contrasenia = contraseniaTextField.text, !contrasenia.isEmpty,
              let repetirContrasenia = repetircontraseniaTextField.text, !repetirContrasenia.isEmpty else {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }

        // Validar formato de correo
        if !validarCorreo(correo) {
            mostrarAlerta(mensaje: "El correo electrónico no tiene un formato válido.")
            return
        }

        // Validar contraseña
        if !validarContrasenia(contrasenia) {
            mostrarAlerta(mensaje: "La contraseña debe tener al menos una mayúscula, una minúscula, un número y un carácter especial.")
            return
        }

        // Verificar que las contraseñas coincidan
        if contrasenia != repetirContrasenia {
            mostrarAlerta(mensaje: "Las contraseñas no coinciden.")
            return
        }

        // Guardar credenciales
        UserDefaults.standard.set(correo, forKey: "correo")
        UserDefaults.standard.set(contrasenia, forKey: "contrasenia")
        UserDefaults.standard.synchronize()

        mostrarAlerta(mensaje: "Registro exitoso. Ahora puedes iniciar sesión.") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
}
