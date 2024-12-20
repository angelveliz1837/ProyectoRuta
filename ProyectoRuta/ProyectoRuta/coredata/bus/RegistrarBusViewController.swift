import UIKit
import FirebaseFirestore

class RegistrarBusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var placaTextField: UITextField!
    @IBOutlet weak var modeloTextField: UITextField!
    @IBOutlet weak var marcaTextField: UITextField!
    @IBOutlet weak var anioFabricacionTextField: UITextField!
    @IBOutlet weak var estadoPicker: UIPickerView!
    
    let estados = ["Inactivo", "Activo"]
    let currentYear = Calendar.current.component(.year, from: Date()) // Año actual
    var selectedEstado: String? // Variable para almacenar el estado seleccionado
    var db = Firestore.firestore() // Instancia de Firestore
    
    // Función para cargar la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración inicial del picker
        estadoPicker.delegate = self
        estadoPicker.dataSource = self
        selectedEstado = estados.first
        estadoPicker.selectRow(0, inComponent: 0, animated: false) // Seleccionar el primer valor
        
        // Aseguramos que el texto se mantenga en mayúsculas
        placaTextField.addTarget(self, action: #selector(placaTextFieldDidEndEditing), for: .editingDidEnd)
        placaTextField.addTarget(self, action: #selector(placaTextFieldDidChange), for: .editingChanged)
    }
    
    // Validación de campos antes de registrar el bus
    func validateFields() -> Bool {
        // Verificar que la placa no esté vacía y contenga caracteres válidos
        guard let placaText = placaTextField.text, !placaText.isEmpty, placaText.count == 6 else {
            showAlert(message: "La placa debe tener exactamente 6 caracteres.")
            return false
        }
        
        // Validar que el modelo y la marca solo contengan letras
        guard let modeloText = modeloTextField.text, !modeloText.isEmpty, modeloText.allSatisfy({ $0.isLetter }) else {
            showAlert(message: "El modelo debe contener solo letras.")
            return false
        }
        
        guard let marcaText = marcaTextField.text, !marcaText.isEmpty, marcaText.allSatisfy({ $0.isLetter }) else {
            showAlert(message: "La marca debe contener solo letras.")
            return false
        }
        
        // Verificar que el año de fabricación sea un número válido
        guard let anioText = anioFabricacionTextField.text, let anio = Int(anioText), anio >= 1900, anio <= currentYear else {
            showAlert(message: "El año de fabricación debe ser un número válido entre 1900 y el año actual.")
            return false
        }
        
        // Verificar que se haya seleccionado un estado
        guard let selectedEstado = selectedEstado, !selectedEstado.isEmpty else {
            showAlert(message: "Debe seleccionar un estado.")
            return false
        }
        
        return true
    }
    
    // Verificar si la placa ya existe en Firestore
    func checkPlacaExists(_ placa: String, completion: @escaping (Bool) -> Void) {
        db.collection("buses").whereField("placa", isEqualTo: placa).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error al verificar la placa: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(querySnapshot?.documents.count ?? 0 > 0)
            }
        }
    }
    
    // Formatear la placa para asegurar que sea válida
    func formatPlaca(_ placa: String) -> String {
        let placaSinEspacios = placa.uppercased().replacingOccurrences(of: " ", with: "")
        if placaSinEspacios.count == 6 {
            return placaSinEspacios
        }
        return placaSinEspacios
    }
    
    // Acción para limitar los caracteres en el campo de placa
    @objc func placaTextFieldDidChange() {
        if let text = placaTextField.text, text.count > 6 {
            placaTextField.text = String(text.prefix(6))
        }
    }
    
    // Acción para convertir la placa a mayúsculas al terminar de editar
    @objc func placaTextFieldDidEndEditing() {
        if let text = placaTextField.text {
            placaTextField.text = text.uppercased()
        }
    }
    
    // Guardar el bus en Firestore
    func saveBus() {
        guard validateFields() else {
            return // Si no pasa la validación, no continuar
        }
        
        // Formatear la placa
        guard let placaText = placaTextField.text else { return }
        let placaFormateada = formatPlaca(placaText)
        
        // Verificar si la placa ya existe en Firestore
        checkPlacaExists(placaFormateada) { (exists) in
            if exists {
                self.showAlert(message: "La placa ya está registrada. Ingresa una placa única.")
                return
            }
            
            // Crear el diccionario con los datos del bus
            let busData: [String: Any] = [
                "placa": placaFormateada,
                "modelo": self.modeloTextField.text ?? "",
                "marca": self.marcaTextField.text ?? "",
                "anioFabricacion": self.anioFabricacionTextField.text ?? "",
                "estado": self.selectedEstado ?? ""
            ]
            
            // Guardar los datos del bus en Firestore
            self.db.collection("buses").document(placaFormateada).setData(busData) { error in
                if let error = error {
                    print("Error al guardar el bus: \(error.localizedDescription)")
                    self.showAlert(message: "Error al registrar el bus: \(error.localizedDescription)")
                } else {
                    print("Bus registrado correctamente")
                    self.clearTextFields() // Limpiar campos si se guarda correctamente
                    self.showAlert(message: "Bus registrado con éxito.")
                }
            }
        }
    }
    
    // Mostrar una alerta
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // Limpiar los campos de texto
    func clearTextFields() {
        placaTextField.text = ""
        modeloTextField.text = ""
        marcaTextField.text = ""
        anioFabricacionTextField.text = ""
        estadoPicker.selectRow(0, inComponent: 0, animated: false)
        selectedEstado = estados.first
    }

    
    // Acción para registrar el bus
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        saveBus()
    }
    
    
    @IBAction func didTapTable(_ sender: UIButton) {
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Métodos del Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Solo una columna de opciones
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count // Número de filas es igual al número de estados
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row] // Devolver el estado correspondiente a la fila
    }
    
    // Actualizar la selección cuando el usuario elija un estado
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEstado = estados[row]
    }
}
