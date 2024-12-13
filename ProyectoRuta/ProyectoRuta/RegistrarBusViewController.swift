import UIKit
import CoreData

class RegistrarBusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var placaTextField: UITextField!
    @IBOutlet weak var modeloTextField: UITextField!
    @IBOutlet weak var marcaTextField: UITextField!
    @IBOutlet weak var anioFabricacionTextField: UITextField!
    @IBOutlet weak var estadoPicker: UIPickerView!
    
    let estados = ["Inactivo", "Activo"]
    let currentYear = Calendar.current.component(.year, from: Date()) // Año actual
    
    var selectedEstado: String? // Variable para almacenar el estado seleccionado
    var placa = ""
    var modelo = ""
    var marca = ""
    var anioFabricacion = ""
    
    // Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asegurarnos de que el UIPickerView sea interactivo
        estadoPicker.isUserInteractionEnabled = true
        
        // Configuración inicial del picker
        estadoPicker.delegate = self
        estadoPicker.dataSource = self
        
        // Configuración inicial del estado
        selectedEstado = estados.first
        estadoPicker.selectRow(0, inComponent: 0, animated: false) // Seleccionar el primer valor
        
        // Limitar la cantidad de caracteres del campo de placa a 6
        placaTextField.addTarget(self, action: #selector(placaTextFieldDidChange), for: .editingChanged)
    }
    
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext // Retornamos el contexto de CoreData del AppDelegate
    }
    
    // Función para validar el año de fabricación
    func validateAnioFabricacion(_ anio: String) -> Bool {
        if let anioInt = Int(anio) {
            return anioInt >= 1900 && anioInt <= currentYear
        }
        return false
    }
    
    // Función para verificar si la placa ya existe en la base de datos
    func checkPlacaExists(_ placa: String) -> Bool {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Bus> = Bus.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "placa == %@", placa)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.count > 0 // Si la placa ya existe, devolverá true
        } catch let error as NSError {
            print("Error al verificar la placa: \(error.localizedDescription)")
            return false
        }
    }
    
    // Función para formatear la placa
    func formatPlaca(_ placa: String) -> String {
        // Eliminar espacios, convertir a mayúsculas y mantener solo caracteres alfanuméricos
        let placaSinEspacios = placa.uppercased().replacingOccurrences(of: " ", with: "")
        
        // Verificar que la placa tenga exactamente 6 caracteres
        if placaSinEspacios.count == 6 {
            // Asegurarse de que el formato sea "L-N-L-N-N-N"
            let letra1 = placaSinEspacios.prefix(1)
            let letra2 = placaSinEspacios.prefix(2).suffix(1)
            let letra3 = placaSinEspacios.prefix(3).suffix(1)
            let numeros = placaSinEspacios.suffix(3)
            
            // Verificamos que la placa siga el formato L-N-L-N-N-N
            if letra1.rangeOfCharacter(from: .letters) != nil &&
                letra2.rangeOfCharacter(from: .alphanumerics) != nil &&
                letra3.rangeOfCharacter(from: .letters) != nil &&
                numeros.rangeOfCharacter(from: .decimalDigits) != nil {
                
                // Formato final: "A1A-100"
                return "\(letra1)\(letra2)\(letra3)-\(numeros)"
            }
        }
        
        // Si la placa no es válida, devolverla tal como está, sin formatear
        return placaSinEspacios
    }
    
    // Función para limitar los caracteres del campo de placa a 6
    @objc func placaTextFieldDidChange() {
        if let text = placaTextField.text, text.count > 6 {
            placaTextField.text = String(text.prefix(6)) // Limitar a 6 caracteres
        }
    }
    
    // Función para guardar el bus
    func saveBus() {
        // Validar que todos los campos estén llenos
        guard let placaText = placaTextField.text, !placaText.isEmpty,
              let modeloText = modeloTextField.text, !modeloText.isEmpty,
              let marcaText = marcaTextField.text, !marcaText.isEmpty,
              let anioText = anioFabricacionTextField.text, !anioText.isEmpty else {
            showAlert(message: "Por favor, completa todos los campos antes de registrar el bus.")
            return
        }
        
        // Formatear la placa antes de guardarla
        let placaFormateada = formatPlaca(placaText)
        
        // Verificar que la placa no esté repetida
        if checkPlacaExists(placaFormateada) {
            showAlert(message: "La placa ya está registrada. Por favor ingresa una placa única.")
            return
        }
        
        // Función para validar los datos ingresados
        func validateFields() -> Bool {
            // Validación de la Placa (ahora permite letras, números y guiones)
            guard let placaText = placaTextField.text, !placaText.isEmpty, placaText.rangeOfCharacter(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))) != nil else {
                showAlert(message: "La placa está vacía o contiene caracteres no válidos.")
                return false
            }
            
            // Validación del modelo (solo letras, sin números)
            guard let modeloText = modeloTextField.text, !modeloText.isEmpty, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: modeloText.replacingOccurrences(of: " ", with: ""))) else {
                showAlert(message: "El modelo no puede estar vacío y no debe contener números.")
                return false
            }
            
            // Validación de la marca (solo letras, sin números)
            guard let marcaText = marcaTextField.text, !marcaText.isEmpty, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: marcaText.replacingOccurrences(of: " ", with: ""))) else {
                showAlert(message: "La marca no puede estar vacía y no debe contener números.")
                return false
            }
            
            // Validar el año de fabricación
            guard validateAnioFabricacion(anioFabricacionTextField.text ?? "") else {
                showAlert(message: "El año de fabricación debe ser un número entre 1900 y el año actual.")
                return false
            }
            
            // Validación del estado seleccionado
            guard let selectedEstado = selectedEstado, !selectedEstado.isEmpty else {
                showAlert(message: "Debe seleccionar un estado.")
                return false
            }
            
            return true
        }
        
        guard validateFields() else { return } // Validar los campos antes de guardar
        
        // Conectarse a la base de datos y guardar el bus
        let context = connectBD() // Contexto para conectarnos a la base de datos
        let entityBus = NSEntityDescription.insertNewObject(forEntityName: "Bus", into: context) as! Bus // Insertamos objetos en la base de datos Bus
        entityBus.placa = placaFormateada // Asignamos la placa formateada
        entityBus.modelo = modeloTextField.text
        entityBus.marca = marcaTextField.text
        entityBus.anioFabricacion = anioFabricacionTextField.text
        entityBus.estado = selectedEstado
        // Capturador de errores
        do {
            try context.save() // Guardamos en la base de datos
            clearTextField() // Limpiamos los campos de texto
            print("Se guardó el bus") // Imprimimos mensaje en consola
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }

    // Función para mostrar un mensaje de alerta
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // Función para limpiar los campos de texto
    func clearTextField() {
        placaTextField.text = ""
        modeloTextField.text = ""
        marcaTextField.text = ""
        anioFabricacionTextField.text = ""
        selectedEstado = estados.first // Resetear al primer valor
        estadoPicker.selectRow(0, inComponent: 0, animated: false) // Reiniciar el Picker
        placaTextField.becomeFirstResponder() // Focus en el campo de placa
    }
    
    // Acción para registrar un bus
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        saveBus() // Llamamos a la función para guardar
    }
    
    @IBAction func didTapTable(_ sender: UIButton) {
        print("Dirigirnos a la siguiente vista de la tabla")
    }
    
    // MARK: - UIPickerViewDelegate y UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Solo una columna para el estado
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEstado = estados[row]
    }
}
