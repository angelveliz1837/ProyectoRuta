import UIKit
import CoreData

class RegistrarParaderoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var numeroParaderoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var nombreParaderoTextField: UITextField!
    @IBOutlet weak var estadoPicker: UIPickerView!
    
    let estados = ["Activo", "Inactivo"]
    
    var selectedEstado: String? // Variable para almacenar el estado seleccionado
    var numeroParadero = ""
    var direccion = ""
    var nombreParadero = ""
    
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
        
        // Deshabilitar la edición del campo nombreParadero
        nombreParaderoTextField.isUserInteractionEnabled = false
        
        // Añadir el observer para detectar cambios en el número de paradero
        numeroParaderoTextField.addTarget(self, action: #selector(numeroParaderoChanged), for: .editingChanged)
    }
    
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext // Retornamos el contexto de CoreData del AppDelegate
    }
    
    // Función para guardar el paradero
    func saveParadero() {
        // Validar que todos los campos estén llenos
        guard let numeroParaderoText = numeroParaderoTextField.text, !numeroParaderoText.isEmpty,
              let direccionText = direccionTextField.text, !direccionText.isEmpty,
              let nombreText = nombreParaderoTextField.text, !nombreText.isEmpty else {
            showAlert(message: "Por favor, completa todos los campos antes de registrar el paradero.")
            return
        }
        
        // Validación de los campos antes de guardar
        guard validateFields() else { return }
        
        // Verificar si el número de paradero ya existe
        if isNumeroParaderoExistente(numeroParaderoText) {
            showAlert(message: "El número de paradero \(numeroParaderoText) ya está registrado.")
            return
        }
        
        // Conectarse a la base de datos y guardar el paradero
        let context = connectBD() // Contexto para conectarnos a la base de datos
        let entityParadero = NSEntityDescription.insertNewObject(forEntityName: "Paradero", into: context) as! Paradero // Insertamos objetos en la base de datos Paradero
        entityParadero.numeroParadero = numeroParaderoText // Le asignamos valor al número de paradero
        entityParadero.direccion = direccionText // Asignar la dirección
        entityParadero.nombreParadero = nombreText // Asignar el nombre del paradero
        entityParadero.estado = selectedEstado // Asignar el estado
        // Capturador de errores
        do {
            try context.save() // Guardamos en la base de datos
            clearTextField() // Limpiamos los campos de texto
            print("Se guardó el Paradero") // Imprimimos mensaje en consola
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    // Función para verificar si el número de paradero ya existe
    func isNumeroParaderoExistente(_ numero: String) -> Bool {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Paradero> = Paradero.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "numeroParadero == %@", numero)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty // Si ya existe, retornamos true
        } catch let error as NSError {
            print("Error al verificar el número de paradero: \(error.localizedDescription)")
            return false
        }
    }
    
    // Función para validar los campos
    func validateFields() -> Bool {
        // Validación del número de paradero (solo números)
        guard let numeroParaderoText = numeroParaderoTextField.text, !numeroParaderoText.isEmpty,
              numeroParaderoText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            showAlert(message: "El número de paradero solo puede contener números.") // Mostrar alerta
            return false
        }
        
        // Validación de la dirección (puede contener letras y números)
        guard let direccionText = direccionTextField.text, !direccionText.isEmpty else {
            showAlert(message: "La dirección no puede estar vacía.") // Mostrar alerta
            return false
        }
        
        // Validación del nombre de paradero (puede contener letras y números)
        guard let nombreParaderoText = nombreParaderoTextField.text, !nombreParaderoText.isEmpty else {
            showAlert(message: "El nombre del paradero no puede estar vacío.") // Mostrar alerta
            return false
        }
        
        // Validación del estado seleccionado
        guard let selectedEstado = selectedEstado, !selectedEstado.isEmpty else {
            showAlert(message: "Debe seleccionar un estado.") // Mostrar alerta
            return false
        }
        
        return true
    }
    
    // Función para mostrar un mensaje de alerta
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // Función para borrar todos los paraderos
    func deleteParadero() {
        let context = connectBD() // Contexto para conectarnos a la base de datos
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paradero") // Hacemos la consulta a la base de datos Paradero
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest) // Vamos a eliminar de forma masiva los datos
        // En un capturador de error
        do {
            try context.execute(delete) // Ejecutamos la eliminación
            clearTextField() // Limpiamos los campos de texto
            print("Paraderos borrados") // Imprimimos en consola
        } catch let error as NSError {
            print("Error al borrar: \(error.localizedDescription)")
        }
    }
    
    // Función para limpiar los campos de texto
    func clearTextField() {
        numeroParaderoTextField.text = ""
        direccionTextField.text = ""
        nombreParaderoTextField.text = ""
        selectedEstado = estados.first // Resetear al primer valor
        estadoPicker.selectRow(0, inComponent: 0, animated: false) // Reiniciar el Picker
        numeroParaderoTextField.becomeFirstResponder() // Focus en el campo de número de paradero
    }
    
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        saveParadero()
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
    
    // Accion para actualizar nombreParadero
    @objc func numeroParaderoChanged() {
        if let numeroParaderoText = numeroParaderoTextField.text {
            nombreParaderoTextField.text = "Paradero \(numeroParaderoText)"
        }
    }
}
