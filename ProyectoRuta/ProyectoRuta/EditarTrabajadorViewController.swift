import UIKit
import CoreData

class EditarTrabajadorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dniEditTextField: UITextField!
    @IBOutlet weak var nombreEditTextField: UITextField!
    @IBOutlet weak var apellidoPaternoEditTextField: UITextField!
    @IBOutlet weak var apellidoMaternoEditTextField: UITextField!
    @IBOutlet weak var cargoEditPicker: UIPickerView!
    @IBOutlet weak var licenciaEditTextField: UITextField!
    
    // Variables
    var trabajadorUpdate: Trabajador?
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
        if let index = cargoOptions.firstIndex(of: trabajador.cargo ?? "") {
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
        guard let dni = dniEditTextField.text, dni.count == 8, dni.allSatisfy({ $0.isNumber }) else {
            showAlert(message: "Error: DNI debe tener exactamente 8 números.")
            return false
        }
        if trabajadores.contains(where: { $0.dni == dni && $0 != trabajadorUpdate }) {
            showAlert(message: "Error: El DNI ya existe en la lista.")
            return false
        }
        
        // Validar nombre
        guard let nombre = nombreEditTextField.text, !nombre.isEmpty, nombre.allSatisfy({ !$0.isNumber }) else {
            showAlert(message: "Error: El nombre no puede contener números.")
            return false
        }
        
        // Validar apellido paterno
        guard let apellidoPaterno = apellidoPaternoEditTextField.text, !apellidoPaterno.isEmpty, apellidoPaterno.allSatisfy({ !$0.isNumber }) else {
            showAlert(message: "Error: El apellido paterno no puede contener números.")
            return false
        }
        
        // Validar apellido materno
        guard let apellidoMaterno = apellidoMaternoEditTextField.text, !apellidoMaterno.isEmpty, apellidoMaterno.allSatisfy({ !$0.isNumber }) else {
            showAlert(message: "Error: El apellido materno no puede contener números.")
            return false
        }
        
        // Validar licencia
        let licencia = licenciaEditTextField.text ?? ""
        if !licencia.isEmpty && trabajadores.contains(where: { $0.licencia == licencia && $0 != trabajadorUpdate }) {
            showAlert(message: "Error: La licencia ya existe en la lista.")
            return false
        }
        
        // Validar cargo
        let selectedCargo = cargoOptions[cargoEditPicker.selectedRow(inComponent: 0)]
        if selectedCargo == "Chofer" && licencia.isEmpty {
            showAlert(message: "Error: El chofer debe tener una licencia.")
            return false
        }
        
        return true
    }
    
    // Actualizar trabajador
    func editarTrabajador() {
        guard validateFields() else { return }
        
        guard let trabajador = trabajadorUpdate else {
            print("Error: No se encontró el trabajador a actualizar.")
            return
        }
        
        let context = connectBD()
        
        trabajador.dni = dniEditTextField.text
        trabajador.nombre = nombreEditTextField.text
        trabajador.apellidoPaterno = apellidoPaternoEditTextField.text
        trabajador.apellidoMaterno = apellidoMaternoEditTextField.text
        trabajador.cargo = cargoOptions[cargoEditPicker.selectedRow(inComponent: 0)]
        
        // Si el cargo es "Chofer", asignar la licencia automáticamente como "QA + DNI"
        let selectedCargo = cargoOptions[cargoEditPicker.selectedRow(inComponent: 0)]
        if selectedCargo == "Chofer" {
            if let dni = dniEditTextField.text, dni.count == 8 {
                trabajador.licencia = "QA\(dni)" // Concatenar "QA" con el DNI
            }
        } else {
            trabajador.licencia = licenciaEditTextField.text?.isEmpty == true ? nil : licenciaEditTextField.text
        }
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
            print("Se actualizó al trabajador correctamente.")
        } catch let error as NSError {
            print("Error al actualizar: \(error.localizedDescription)")
        }
    }
    
    // Acción para guardar cambios
    @IBAction func didTapUpdate(_ sender: UIButton) {
        editarTrabajador()
    }
    
    // MARK: - UIPickerView DataSource y Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cargoOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cargoOptions[row]
    }
    
    // Este método maneja el cambio de selección del cargo, y si se selecciona "Chofer", asigna la licencia automáticamente
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCargo = cargoOptions[row]
        if selectedCargo == "Chofer" {
            // Si el cargo es Chofer, asignar licencia automáticamente como "QA" + DNI
            if let dni = dniEditTextField.text, dni.count == 8 {
                licenciaEditTextField.text = "QA\(dni)" // Concatenar "QA" con el DNI
            }
        } else {
            licenciaEditTextField.text = "" // Limpiar la licencia si no es Chofer
        }
    }
}
