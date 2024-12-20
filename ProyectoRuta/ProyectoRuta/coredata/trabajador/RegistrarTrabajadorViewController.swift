import UIKit
import CoreData
import FirebaseFirestore

class RegistrarTrabajadorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoPaternoTextField: UITextField!
    @IBOutlet weak var apellidoMaternoTextField: UITextField!
    @IBOutlet weak var cargoPicker: UIPickerView!
    @IBOutlet weak var licenciaTextField: UITextField!

    let cargos = ["Monitor", "Chofer"]
    var selectedCargo: String?

    var dni = ""
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
    var cargo = ""
    var licencia = ""

    // Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()

        // Asignar el delegado para el campo dniTextField
        dniTextField.delegate = self

        // Asegurarnos de que el UIPickerView sea interactivo
        cargoPicker.isUserInteractionEnabled = true

        // Configurar UIPickerView para el campo "cargo"
        cargoPicker.delegate = self
        cargoPicker.dataSource = self

        // Configuración inicial del cargo
        selectedCargo = cargos.first
        cargoPicker.selectRow(0, inComponent: 0, animated: false) // Seleccionar el primer valor
    }

    // Función delegada para limitar la longitud del texto y permitir solo números
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Solo permitir 8 caracteres y asegurarnos de que solo sean números
        if textField == dniTextField {
            // Comprobar si el texto ingresado es un número
            let characterSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false // Si el caracter no es un número, lo rechazamos
            }

            // Limitar la longitud a 8 caracteres
            let currentText = textField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            return newLength <= 8 // Solo permitir un máximo de 8 caracteres
        }

        return true // Para otros campos, no se limita la longitud
    }

    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate // Instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext // Retornamos el contexto de CoreData del AppDelegate
    }

    // Función para validar los datos ingresados
    func validateFields() -> Bool {
        // Validar DNI: debe tener exactamente 8 números
        guard let dniText = dniTextField.text, dniText.count == 8, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: dniText)) else {
            showAlert(message: "El DNI debe tener exactamente 8 números y solo contener dígitos.")
            return false
        }

        // Verificar si el DNI ya está registrado
        if isDniExistente(dniText) {
            showAlert(message: "El DNI \(dniText) ya está registrado.")
            return false
        }

        // Validar nombre: no debe contener números
        guard let nombreText = nombreTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: nombreText.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "El nombre no puede contener números.")
            return false
        }

        // Validar apellido paterno: no debe contener números
        guard let apellidoPText = apellidoPaternoTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: apellidoPText.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "El apellido paterno no puede contener números.")
            return false
        }

        // Validar apellido materno: no debe contener números
        guard let apellidoMText = apellidoMaternoTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: apellidoMText.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "El apellido materno no puede contener números.")
            return false
        }

        // Si el cargo es Chofer, la licencia es obligatoria
        if selectedCargo == "Chofer", let licenciaText = licenciaTextField.text, licenciaText.isEmpty {
            showAlert(message: "La licencia es obligatoria para el cargo de Chofer.")
            return false
        }

        return true
    }

    // Función para verificar si el DNI ya está registrado
    func isDniExistente(_ dni: String) -> Bool {
        let BD = Firestore.firestore()
        let docRef = BD.collection("trabajadores").document(dni)
        var isExisting = false

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                isExisting = true
            } else {
                isExisting = false
            }
        }
        return isExisting
    }

    // Función para guardar
    func saveTrabajador() {
        // Validar que los campos son correctos antes de proceder
        guard validateFields() else { return }

        let dni = getDni()
        let nombre = getNombre()
        let apellidoPaterno = getApellidoPaterno()
        let apellidoMaterno = getApellidoMaterno()
        let cargo = getCargo()
        let licencia = getLicencia()

        // Crea la referencia a Firestore
        let BD = Firestore.firestore()

        // Asegúrate de que el DNI sea único
        if isDniExistente(dni) {
            showAlert(message: "El DNI \(dni) ya está registrado.")
            return
        }

        // Guardar los datos en Firestore
        BD.collection("trabajadores").document(dni).setData([
            "dni": dni,
            "nombre": nombre,
            "apellidoPaterno": apellidoPaterno,
            "apellidoMaterno": apellidoMaterno,
            "cargo": cargo,
            "licencia": licencia
        ]) { error in
            if let error = error {
                self.showAlert(message: "Error al registrar el trabajador: \(error.localizedDescription)")
            } else {
                self.showAlert(message: "Trabajador registrado con éxito.")
                self.clearTextField()  // Limpiar los campos después del registro exitoso
            }
        }
    }

    func getDni()->String {
        return dniTextField.text ?? ""
    }

    func getNombre()->String {
        return nombreTextField.text ?? ""
    }

    func getApellidoPaterno()->String {
        return apellidoPaternoTextField.text ?? ""
    }

    func getApellidoMaterno()->String {
        return apellidoMaternoTextField.text ?? ""
    }

    func getCargo()->String {
        return selectedCargo ?? "Activo"
    }

    func getLicencia()->String {
        return licenciaTextField.text ?? ""
    }

    // Función para mostrar
    func showTrabajador() {
        // Aquí puedes agregar código para mostrar trabajadores si lo necesitas
    }

    // Función para borrar
    func deleteTrabajador() {
        let context = connectBD() // Contexto para conectarnos a la base de datos
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Trabajador") // Hacemos la consulta a la base de datos Trabajador
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest) // Vamos a eliminar de forma masiva los datos
        // Capturador de error
        do {
            try context.execute(delete) // Ejecutamos el contexto de la consulta a la base de datos
            clearTextField() // Llamamos a la función para limpiar los campos
            print("Trabajadores Borrados") // Imprimimos consola
        } catch let error as NSError {
            // Podríamos poner una vista en específica pero por el momento solo imprimimos por consola
            print("Error al borrar: \(error.localizedDescription)")
        }
    }

    // Función para limpiar
    func clearTextField() {
        dniTextField.text = ""
        nombreTextField.text = ""
        apellidoPaternoTextField.text = ""
        apellidoMaternoTextField.text = ""
        selectedCargo = cargos.first // Resetear al primer valor
        cargoPicker.selectRow(0, inComponent: 0, animated: false) // Reiniciar el Picker
        licenciaTextField.text = ""
        dniTextField.becomeFirstResponder() // Focus al dni
    }

    // Función para mostrar alerta
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapRegistrar(_ sender: UIButton) {
        saveTrabajador() // Llamamos a la función de guardar
    }

    @IBAction func didTapTable(_ sender: UIButton) {
        print("Dirigirnos a la siguiente vista de la tabla")
    }

    // UIPickerView DataSource y Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Solo una columna
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cargos.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cargos[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCargo = cargos[row]
        // Si el cargo es "Chofer", llenar automáticamente el campo de licencia
            if selectedCargo == "Chofer" {
                // Asegurarnos de que el campo DNI no esté vacío antes de asignar la licencia
                if let dniText = dniTextField.text, dniText.count == 8 {
                    licenciaTextField.text = "QA\(dniText)" // Concatenar "QA" con el DNI
                }
            } else {
                licenciaTextField.text = "" // Limpiar el campo de licencia si no es Chofer
            }
        }
    }
