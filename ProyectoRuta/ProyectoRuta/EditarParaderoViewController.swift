import UIKit
import CoreData

class EditarParaderoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var numeroParaderoEditTextField: UITextField!
    @IBOutlet weak var direccionEditTextField: UITextField!
    @IBOutlet weak var nombreParaderoEditTextField: UITextField!
    @IBOutlet weak var estadoEditPicker: UIPickerView!
    
    // Variables
    var paraderoUpdate: Paradero? // Objeto para el paradero a editar
    
    // Datos del Picker
    let estados = ["Activo", "Inactivo"]

    // Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField() // Llamamos a la función para configurar los campos de texto
        estadoEditPicker.delegate = self // Asignamos el delegado del picker
        estadoEditPicker.dataSource = self // Asignamos la fuente de datos del picker
        
        // Deshabilitar el campo nombre de paradero para que no pueda ser editado
        nombreParaderoEditTextField.isEnabled = false
        
        // Añadir el observer para detectar cambios en el campo numeroParaderoEditTextField
        numeroParaderoEditTextField.addTarget(self, action: #selector(numeroParaderoChanged), for: .editingChanged)
    }
    
    // FUNCIONES
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate // Instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext // Retornamos el contexto de CoreData del AppDelegate
    }
    
    // Función para configurar los campos de texto
    func configureTextField() {
        numeroParaderoEditTextField.text = paraderoUpdate?.numeroParadero // Asignamos la numero de Paradero (no se puede modificar)
        direccionEditTextField.text = paraderoUpdate?.direccion
        nombreParaderoEditTextField.text = paraderoUpdate?.nombreParadero
        // Configuramos el estado del picker con el valor correspondiente
        if let estado = paraderoUpdate?.estado, let index = estados.firstIndex(of: estado) {
            estadoEditPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    // Función para validar los campos
    func validateFields() -> Bool {
        // Validar el número de paradero (solo números)
        guard let numeroParaderoText = numeroParaderoEditTextField.text, !numeroParaderoText.isEmpty,
              numeroParaderoText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            showAlert(message: "El número de paradero solo puede contener números.")
            return false
        }
        
        // Validar la dirección (no vacía)
        guard let direccionText = direccionEditTextField.text, !direccionText.isEmpty else {
            showAlert(message: "La dirección no puede estar vacía.")
            return false
        }
        
        // Validar el nombre de paradero (no vacío)
        guard let nombreParaderoText = nombreParaderoEditTextField.text, !nombreParaderoText.isEmpty else {
            showAlert(message: "El nombre del paradero no puede estar vacío.")
            return false
        }
        
        // Validar que se haya seleccionado un estado
        let selectedEstado = estados[estadoEditPicker.selectedRow(inComponent: 0)]
        if selectedEstado.isEmpty {
            showAlert(message: "Debe seleccionar un estado.")
            return false
        }
        
        return true
    }
    
    // Función para editar el paradero
    func editarParadero() {
        // Validar los campos antes de proceder
        guard validateFields() else { return }
        
        let context = connectBD() // Contexto para conectarnos a la base de datos
        paraderoUpdate?.setValue(numeroParaderoEditTextField.text, forKey: "numeroParadero")
        paraderoUpdate?.setValue(direccionEditTextField.text, forKey: "direccion")
        paraderoUpdate?.setValue(nombreParaderoEditTextField.text, forKey: "nombreParadero")
        
        // Obtenemos el estado seleccionado en el picker
        let estadoSeleccionado = estados[estadoEditPicker.selectedRow(inComponent: 0)]
        paraderoUpdate?.setValue(estadoSeleccionado, forKey: "estado")
        
        // Capturador de errores
        do {
            try context.save() // Guardamos en base de datos
            navigationController?.popViewController(animated: true) // Retornamos a la pantalla anterior
            print("Se actualizó el paradero") // Imprimimos
        } catch let error as NSError {
            // Imprimimos el error por consola
            print("Error al actualizar: \(error.localizedDescription)")
        }
    }
    
    // Función para mostrar un mensaje de alerta
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // Acción del botón de actualización
    @IBAction func didTapUpdate(_ sender: UIButton) {
        editarParadero() // Llamamos a la función para editar el paradero
    }
    
    // MARK: - UIPickerView DataSource y Delegate
    
    // Número de componentes (columnas) en el picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Solo una columna para el estado
    }
    
    // Número de filas en cada componente (uno por cada estado)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count
    }
    
    // Título de cada fila del picker (Estado)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row]
    }
    
    // Función cuando se selecciona una fila
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // No es necesario hacer nada aquí, ya que el valor se guarda cuando se actualiza el paradero.
    }
    
    // MARK: - Acción para actualizar nombreParadero
    @objc func numeroParaderoChanged() {
        // Solo se actualiza el nombreParadero si se escribe en numeroParaderoEditTextField
        if let numeroParaderoText = numeroParaderoEditTextField.text {
            nombreParaderoEditTextField.text = "Paradero \(numeroParaderoText)" // Actualizamos el nombre del paradero
        }
    }
}
