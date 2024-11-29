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
    var isEnviado = false  // Variable para controlar si los datos han sido enviados
    
    // Claves para UserDefaults
    let horaKey = "hora"
    let observacionKey = "observacion"
    let resultHoraKey = "resultHora"
    let resultObservacionKey = "resultObservacion"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Deshabilitar el botón "Actualizar" al principio
        updateButton.isEnabled = false
        // Configurar el fondo inicial de los campos
        setupInitialUI()
    }
    
    // Configuración inicial de UI
    func setupInitialUI() {
        observacionTextField.backgroundColor = .white
        observacionTextField.textColor = .black
        resultObservacionTextView.backgroundColor = .white
        resultObservacionTextView.textColor = .black
    }
    
    // Función para manejar el envío de datos
    func enviar() {
        // Capturar los valores de los campos
        hora = horaDatePicker.date
        observacion = observacionTextField.text ?? ""
        
        // Actualizar los campos de resultado
        resultadohoraDatePicker.date = hora
        resultObservacionTextView.text = observacion
        
        // Cambiar el fondo de observacionTextField a blanco y el texto a negro
        observacionTextField.backgroundColor = .white
        observacionTextField.textColor = .black
        // Limpiar el texto de observacionTextField al enviar
        observacionTextField.text = ""
    }
    
    // Función para cambiar el fondo de resultObservacionTextView al actualizar
    func actualizar() {
        // Cambiar el fondo de resultObservacionTextView a negro y el texto a blanco
        resultObservacionTextView.backgroundColor = .black
        resultObservacionTextView.textColor = .white
        
        // Establecer el foco en resultObservacionTextView
        resultObservacionTextView.becomeFirstResponder()
        
        // Actualizar las variables de resultados
        resulthora = resultadohoraDatePicker.date
        resultobservacion = resultObservacionTextView.text ?? ""
        
        // Actualizar los valores de los campos con los resultados
        horaDatePicker.date = resulthora
        
        // Aquí no tocamos observacionTextField, porque no debe cambiar con la actualización
        observacionTextField.backgroundColor = .white
        observacionTextField.textColor = .black
    }
    
    // Acción cuando se presiona el botón "Enviar"
    @IBAction func didTapEnviar(_ sender: UIButton) {
        if !isEnviado {
            // Llamamos a la función para enviar los datos
            enviar()
            
            // Cambiar el estado de isEnviado
            isEnviado = true
            
            // Deshabilitar el botón "Enviar" después de presionar
            enviarButton.isEnabled = false
            
            // Deshabilitar la interacción con los campos
            horaDatePicker.isUserInteractionEnabled = false
            observacionTextField.isUserInteractionEnabled = false
            
            // Habilitar el botón "Actualizar"
            updateButton.isEnabled = true
        }
    }
    
    // Acción cuando se presiona el botón "Actualizar"
    @IBAction func didTapActualizar(_ sender: UIButton) {
        if isEnviado {
            // Llamamos a la función para actualizar la información
            actualizar()
        } else {
            // Si no se ha enviado la información, podemos manejar esta situación
            print("No se ha enviado la información aún.")
        }
    }
    
    // Acción cuando se presiona el botón "Guardar"
    @IBAction func didTapGuardar(_ sender: UIButton) {
        // Guardamos los valores en UserDefaults
        UserDefaults.standard.set(horaDatePicker.date, forKey: horaKey)
        UserDefaults.standard.set(observacionTextField.text ?? "", forKey: observacionKey)
        UserDefaults.standard.set(resultadohoraDatePicker.date, forKey: resultHoraKey)
        UserDefaults.standard.set(resultObservacionTextView.text ?? "", forKey: resultObservacionKey)
        
        print("Datos guardados correctamente.")
    }
    
    // Función para restaurar los valores guardados cuando la vista se vuelva a mostrar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Verificar si los datos han sido guardados previamente
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
            
            // Cambiar el fondo de resultObservacionTextView a negro y el texto a blanco
            resultObservacionTextView.backgroundColor = .black
            resultObservacionTextView.textColor = .white
        }
        
        // Habilitar el botón "Actualizar"
        updateButton.isEnabled = true
    }
    
    // Si quieres restaurar los valores cuando la vista ya haya aparecido, usa viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isEnviado {
            // Aquí podrías hacer más ajustes si fuera necesario al mostrar la vista
        }
    }
}
