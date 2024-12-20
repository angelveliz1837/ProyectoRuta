import UIKit
import CoreData
import FirebaseFirestore

class EditarTrabajadorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dniEditTextField: UITextField!
    @IBOutlet weak var nombreEditTextField: UITextField!
    @IBOutlet weak var apellidoPaternoEditTextField: UITextField!
    @IBOutlet weak var apellidoMaternoEditTextField: UITextField!
    @IBOutlet weak var cargoEditPicker: UIPickerView!
    @IBOutlet weak var licenciaEditTextField: UITextField!
    
    // Variables
    var trabajadorUpdate: trabajadores?
    var cargoOptions = ["Chofer", "Monitor"] // Opciones de cargo
    var trabajadores: [Trabajador] = [] // Lista de trabajadores para validaciones
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField() // Configuramos los campos de texto con los datos existentes
        configurePickerView() // Configuramos el UIPickerView
        loadTrabajadores() // Cargamos los trabajadores existentes
    }
    
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    // Configurar los campos de texto con los datos del trabajador
    func configureTextField() {
        guard let trabajador = trabajadorUpdate else {
            print("No se asignó ningún trabajador para editar.")
            return
        }
        dniEditTextField.text = trabajador.dni
        nombreEditTextField.text = trabajador.nombre
        apellidoPaternoEditTextField.text = trabajador.apellidoPaterno
        apellidoMaternoEditTextField.text = trabajador.apellidoMaterno
        licenciaEditTextField.text = trabajador.licencia
        if let index = cargoOptions.firstIndex(of: trabajador.cargo ) {
            cargoEditPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    // Configurar el UIPickerView
    func configurePickerView() {
        cargoEditPicker.delegate = self
        cargoEditPicker.dataSource = self
    }
    
    // Cargar la lista de trabajadores para validaciones
    func loadTrabajadores() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Trabajador> = Trabajador.fetchRequest()
        do {
            trabajadores = try context.fetch(fetchRequest)
        } catch {
            print("Error al cargar trabajadores: \(error.localizedDescription)")
        }
    }
    
    // Función para mostrar alertas
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Validaciones antes de actualizar
    func validateFields() -> Bool {
        // Validar DNI
        guard let dni = dniEditTextField.text, dni.count == 8, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: dni)) else {
            showAlert(message: "El DNI debe tener exactamente 8 números y solo contener dígitos.")
            return false
        }

        // Validar nombre: no debe contener números
        guard let nombre = nombreEditTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: nombre.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "El nombre no puede contener números.")
            return false
        }

        // Validar apellido paterno: no debe contener números
        guard let apellidoPaterno = apellidoPaternoEditTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: apellidoPaterno.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "El apellido paterno no puede contener números.")
            return false
        }

        // Validar apellido materno: no debe contener números
        guard let apellidoMaterno = apellidoMaternoEditTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: apellidoMaterno.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "El apellido materno no puede contener números.")
            return false
        }

        // Si el cargo es Chofer, la licencia es obligatoria
        let selectedCargo = cargoOptions[cargoEditPicker.selectedRow(inComponent: 0)]
        if selectedCargo == "Chofer", let licencia = licenciaEditTextField.text, licencia.isEmpty {
            showAlert(message: "La licencia es obligatoria para el cargo de Chofer.")
            return false
        }


        return true
    }
    
    // Función para actualizar los datos en Firebase
    func updateTrabajador() {
        // Validar los campos antes de proceder
        guard validateFields() else { return }

        // Recuperar los valores
        let dni = dniEditTextField.text ?? ""
        let nombre = nombreEditTextField.text ?? ""
        let apellidoPaterno = apellidoPaternoEditTextField.text ?? ""
        let apellidoMaterno = apellidoMaternoEditTextField.text ?? ""
        let cargo = cargoOptions[cargoEditPicker.selectedRow(inComponent: 0)]
        let licencia = licenciaEditTextField.text ?? ""

        // Actualizar los datos en Firebase
        let db = Firestore.firestore()

        db.collection("trabajadores").document(dni).updateData([
            "dni": dni,
            "nombre": nombre,
            "apellidoPaterno": apellidoPaterno,
            "apellidoMaterno": apellidoMaterno,
            "cargo": cargo,
            "licencia": licencia
            ]){ error in
                if let error = error {
                    // Si hay un error, mostramos el mensaje en consola
                    print("Error al actualizar el trabajador: \(error.localizedDescription)")
                } else {
                    // Si la actualización es exitosa, mostramos un mensaje y regresamos a la lista
                    print("Trabajador actualizado con éxito.")
                    self.clearFields() // Limpiar los campos después de la actualización
                    self.navigationController?.popViewController(animated: true) // Regresar a la lista
                }
            }
    }

    
    // Limpiar los campos
    func clearFields() {
        dniEditTextField.text = ""
        nombreEditTextField.text = ""
        apellidoPaternoEditTextField.text = ""
        apellidoMaternoEditTextField.text = ""
        licenciaEditTextField.text = ""
        cargoEditPicker.selectRow(0, inComponent: 0, animated: false) // Reiniciar el Picker
    }
    
    // Acción de botón para guardar cambios
    @IBAction func didTapUpdateTrabajador(_ sender: UIButton) {
        updateTrabajador() // Llamar la función para actualizar el trabajador
    }
    
    // UIPickerView DataSource y Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Solo una columna
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cargoOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cargoOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Aquí puedes manejar la selección del cargo si es necesario
    }
}
