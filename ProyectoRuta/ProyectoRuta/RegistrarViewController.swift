import UIKit

class RegistrarViewController: UIViewController {

    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseniaTextField: UITextField!
    @IBOutlet weak var repetircontraseniaTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Aseguramos que los campos de contraseña oculten el texto como asteriscos
        contraseniaTextField.isSecureTextEntry = true
        repetircontraseniaTextField.isSecureTextEntry = true
    }
    
// MARK: - Funciones de Validación
    // Valida que el correo tenga el formato correcto.
    func validarCorreo(_ correo: String) -> Bool {
        let patron  = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let regex   = NSPredicate(format: "SELF MATCHES %@", patron)
        return regex.evaluate(with: correo)
    }

    // Valida que la contraseña cumpla con los requisitos.
    func validarContrasenia(_ contrasenia: String) -> Bool {
        let patron  = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let regex   = NSPredicate(format: "SELF MATCHES %@", patron)
        return regex.evaluate(with: contrasenia)
    }
    
    // Valida todos los campos ingresados por el usuario.
    func validarCampos(correo: String?, contrasenia: String?, repetirContrasenia: String?) -> Bool {
        guard let correo = correo, !correo.isEmpty,
              let contrasenia = contrasenia, !contrasenia.isEmpty,
              let repetirContrasenia = repetirContrasenia, !repetirContrasenia.isEmpty
        else {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return false
        }
        
        // Validar formato de correo
        if !validarCorreo(correo) {
            mostrarAlerta(mensaje: "El correo electrónico no tiene un formato válido.")
            return false
        }

        // Validar contraseña
        if !validarContrasenia(contrasenia) {
            mostrarAlerta(mensaje: "La contraseña debe tener al menos una mayúscula, una minúscula, un número y un carácter especial.")
            return false
        }

        // Verificar que las contraseñas coincidan
        if contrasenia != repetirContrasenia {
            mostrarAlerta(mensaje: "Las contraseñas no coinciden.")
            return false
        }

        return true
    }
    
    // MARK: - Funciones Auxiliares
    // Guarda las credenciales ingresadas en UserDefaults.
    func guardarCredenciales(correo: String, contrasenia: String) {
        UserDefaults.standard.set(correo, forKey: "correo")
        UserDefaults.standard.set(contrasenia, forKey: "contrasenia")
        UserDefaults.standard.synchronize()
    }
    
    // Muestra una alerta con un mensaje.
    func mostrarAlerta(mensaje: String, accion: ((UIAlertAction) -> Void)? = nil) {
        let alerta = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: accion))
        present(alerta, animated: true, completion: nil)
    }
    
    // Limpia los campos del formulario.
    func limpiarFormulario() {
        correoTextField.text = ""
        contraseniaTextField.text = ""
        repetircontraseniaTextField.text = ""
    }
    
    // Registra al usuario si todos los datos son válidos.
    func registrarUsuario() {
        let correo = correoTextField.text
        let contrasenia = contraseniaTextField.text
        let repetirContrasenia = repetircontraseniaTextField.text
        
        if validarCampos(correo: correo, contrasenia: contrasenia, repetirContrasenia: repetirContrasenia) {
            guardarCredenciales(correo: correo!, contrasenia: contrasenia!)
            mostrarAlerta(mensaje: "Registro exitoso. Ahora puedes iniciar sesión.")
            { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Acciones
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        registrarUsuario()
    }
    
    @IBAction func didTapLimpiar(_ sender: UIButton) {
        limpiarFormulario()
    }
}
