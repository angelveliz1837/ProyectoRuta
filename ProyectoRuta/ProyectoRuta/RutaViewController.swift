import UIKit

class RutaViewController: UIViewController {
    
    @IBOutlet weak var horaDatePicker: UIDatePicker!
    @IBOutlet weak var observacionTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var resultObservacionTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var resultadohoraDatePicker: UIDatePicker!
    
    var hora: Date = Date()
    var observacion: String = ""
    var resulthora: Date = Date()
    var resultobservacion: String = ""

    // Variable para controlar si los datos han sido enviados
    var isEnviado = false
    
    // Claves para UserDefaults
    let horaKey = "hora"
    let observacionKey = "observacion"
    let resultHoraKey = "resultHora"
    let resultObservacionKey = "resultObservacion"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configurar la UI inicial
        setupInitialUI()
        // Deshabilitar el botón "Actualizar" al principio
        updateButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreValues()
    }
    
    // MARK: - Funciones de lógica

    // Configuración inicial de la interfaz de usuario.
    func setupInitialUI() {
        observacionTextField.backgroundColor        = .white
        observacionTextField.textColor              = .black
        resultObservacionTextView.backgroundColor   = .white
        resultObservacionTextView.textColor         = .black
    }

    // Restaura los valores guardados de `UserDefaults`.
    func restoreValues() {
        if let storedHora = UserDefaults.standard.object(forKey: horaKey) as? Date {
            hora = storedHora
            horaDatePicker.date = hora
            resultadohoraDatePicker.date = hora
        }
        
        if let storedObservacion = UserDefaults.standard.string(forKey: observacionKey) {
            observacion = storedObservacion
            observacionTextField.text = observacion
        }
        
        if let storedResultHora = UserDefaults.standard.object(forKey: resultHoraKey) as? Date {
            resulthora = storedResultHora
            resultadohoraDatePicker.date = resulthora
        }
        
        if let storedResultObservacion = UserDefaults.standard.string(forKey: resultObservacionKey) {
            resultobservacion = storedResultObservacion
            resultObservacionTextView.text = resultobservacion
            resultObservacionTextView.backgroundColor = .black
            resultObservacionTextView.textColor = .white
        }
    }

    // Maneja el envío de los datos y actualiza el estado.
    func enviarDatos() {
        hora = horaDatePicker.date
        observacion = observacionTextField.text ?? ""
        
        // Actualizar los resultados
        resultadohoraDatePicker.date = hora
        resultObservacionTextView.text = observacion
        
        // Actualizar UI
        observacionTextField.backgroundColor = .white
        observacionTextField.textColor = .black
        observacionTextField.text = "" // Limpiar campo de texto
        enviarButton.isEnabled = false
        updateButton.isEnabled = true
        horaDatePicker.isUserInteractionEnabled = false
        observacionTextField.isUserInteractionEnabled = false
        
        isEnviado = true
    }
    
    // Cambia el fondo de los resultados al actualizar.
    func actualizarResultados() {
        resultObservacionTextView.backgroundColor = .black
        resultObservacionTextView.textColor = .white
        resulthora = resultadohoraDatePicker.date
        resultobservacion = resultObservacionTextView.text ?? ""
    }
    
    // Guarda los valores en `UserDefaults`.
    func guardarValores() {
        UserDefaults.standard.set(horaDatePicker.date, forKey: horaKey)
        UserDefaults.standard.set(observacionTextField.text ?? "", forKey: observacionKey)
        UserDefaults.standard.set(resultadohoraDatePicker.date, forKey: resultHoraKey)
        UserDefaults.standard.set(resultObservacionTextView.text ?? "", forKey: resultObservacionKey)
        print("Datos guardados correctamente.")
    }

    // MARK: - Acciones de botones

    // Acción al presionar el botón "Enviar".
    @IBAction func didTapEnviar(_ sender: UIButton) {
        if !isEnviado {
            enviarDatos()
        }
    }
    
    // Acción al presionar el botón "Actualizar".
    @IBAction func didTapActualizar(_ sender: UIButton) {
        if isEnviado {
            actualizarResultados()
        }
    }
    
    // Acción al presionar el botón "Guardar".
    @IBAction func didTapGuardar(_ sender: UIButton) {
        guardarValores()
    }
}
