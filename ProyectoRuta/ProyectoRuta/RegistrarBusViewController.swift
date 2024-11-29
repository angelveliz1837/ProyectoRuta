import UIKit
import CoreData

class RegistrarBusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var placaTextField: UITextField!
    @IBOutlet weak var modeloTextField: UITextField!
    @IBOutlet weak var marcaTextField: UITextField!
    @IBOutlet weak var anioFabricacionTextField: UITextField!
    @IBOutlet weak var estadoPicker: UIPickerView!
    
    let estados = ["Activo", "Inactivo"] // Opciones para el Picker
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
        
        // Verificar que la placa no esté repetida
        if checkPlacaExists(placaText) {
            showAlert(message: "La placa ya está registrada. Por favor ingresa una placa única.")
            return
        }
        
        // Eliminar la parte de formateo de la placa
        _ = placaText // Usamos la placa tal cual es ingresada
        
        // Función para validar los datos ingresados
        func validateFields() -> Bool {
            // Validación de la Placa (ahora permite letras, números y guiones)
            guard let placaText = placaTextField.text, !placaText.isEmpty, placaText.rangeOfCharacter(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))) != nil else {
                print("La placa está vacía o contiene caracteres no válidos.")
                return false
            }
            
            // Validación del modelo (solo letras, sin números)
            guard let modeloText = modeloTextField.text, !modeloText.isEmpty, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: modeloText.replacingOccurrences(of: " ", with: ""))) else {
                print("El modelo no puede estar vacío y no debe contener números.")
                return false
            }
            
            // Validación de la marca (solo letras, sin números)
            guard let marcaText = marcaTextField.text, !marcaText.isEmpty, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: marcaText.replacingOccurrences(of: " ", with: ""))) else {
                print("La marca no puede estar vacía y no debe contener números.")
                return false
            }
            
            // Validar el año de fabricación
            guard validateAnioFabricacion(anioFabricacionTextField.text ?? "") else {
                showAlert(message: "El año de fabricación debe ser un número entre 1900 y el año actual.")
                return false
            }
            
            // Validación del estado seleccionado
            guard let selectedEstado = selectedEstado, !selectedEstado.isEmpty else {
                print("Debe seleccionar un estado.")
                return false
            }
            
            return true
        }
        
        guard validateFields() else { return } // Validar los campos antes de guardar
        
        // Conectarse a la base de datos y guardar el bus
        let context = connectBD() // Contexto para conectarnos a la base de datos
        let entityBus = NSEntityDescription.insertNewObject(forEntityName: "Bus", into: context) as! Bus // Insertamos objetos en la base de datos Bus
        entityBus.placa = placaTextField.text // Le asignamos valor a la placa lo que vamos escribiendo
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
    
    // Función para mostrar buses
    func showBus() {
        let context = connectBD() // Contexto para conectarnos a la base de datos
        let fetchRequest: NSFetchRequest<Bus> = Bus.fetchRequest() // Solicitar todos los objetos de tipo Bus
        
        do {
            let result = try context.fetch(fetchRequest) // Ejecutar la consulta
            
            print("Registro: \(result.count)")
            
            // Recorrer el resultado y mostrar los valores
            for responseCoreData in result as [NSManagedObject] {
                let placa = responseCoreData.value(forKey: "placa") // Capturamos placa
                let modelo = responseCoreData.value(forKey: "modelo")
                let marca = responseCoreData.value(forKey: "marca")
                let anioFabricacion = responseCoreData.value(forKey: "anioFabricacion")
                let estado = responseCoreData.value(forKey: "estado")
                print("Placa: \(placa ?? "")\nModelo: \(modelo ?? "")\nMarca: \(marca ?? "")\nAño Fabricación: \(anioFabricacion ?? "")\nEstado: \(estado ?? "")")
            }
        } catch let error as NSError {
            print("Error al mostrar: \(error.localizedDescription)")
        }
    }
    
    // Función para borrar todos los buses
    func deleteBus() {
        let context = connectBD() // Contexto para conectarnos a la base de datos
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bus") // Hacemos la consulta a la base de datos Bus
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest) // Vamos a eliminar de forma masiva los datos
        
        // En un capturador de error
        do {
            try context.execute(delete) // Ejecutamos la eliminación
            clearTextField() // Limpiamos los campos de texto
            print("Buses borrados") // Imprimimos en consola
        } catch let error as NSError {
            print("Error al borrar: \(error.localizedDescription)")
        }
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
