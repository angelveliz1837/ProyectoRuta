import UIKit
import FirebaseFirestore

class EditarBusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var placaEditTextField: UITextField!
    @IBOutlet weak var modeloEditTextField: UITextField!
    @IBOutlet weak var marcaEditTextField: UITextField!
    @IBOutlet weak var anioFabricacionEditTextField: UITextField!
    @IBOutlet weak var estadoEditPicker: UIPickerView!
    
    // Variables
    var busUpdate: buses? // Objeto para el bus a editar
    var buses: [Bus] = [] // Lista de buses para validaciones
    
    // Datos del Picker
    let estados = ["Activo", "Inactivo"]
    let currentYear = Calendar.current.component(.year, from: Date()) // Año actual
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField() // Llamamos a la función para configurar los campos de texto
        estadoEditPicker.delegate = self // Asignamos el delegado del picker
        estadoEditPicker.dataSource = self // Asignamos la fuente de datos del picker
        
        // Deshabilitar el campo placa para que no pueda ser editado
        // placaEditTextField.isEnabled = false
    }
    
    // FUNCIONES
    func configureTextField() {
        guard let bus = busUpdate else {
            print("No se asignó ningún bus para editar.")
            return
        }
        placaEditTextField.text = bus.placa // Asignamos la placa (no se puede modificar)
        modeloEditTextField.text = bus.modelo
        marcaEditTextField.text = bus.marca
        anioFabricacionEditTextField.text = bus.anioFabricacion // Se espera que sea String
        
        // Configuramos el estado del picker con el valor correspondiente
        if let index = estados.firstIndex(of: bus.estado) {
            estadoEditPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    // Función para validar año de fabricación
    func validateAnioFabricacion(_ anio: String) -> Bool {
        if let anioInt = Int(anio) {
            return anioInt >= 1900 && anioInt <= currentYear
        }
        return false
    }
    
    // Función para validar que los campos no estén vacíos
    func validateFields() -> Bool {
        guard let placaText = placaEditTextField.text, !placaText.isEmpty else {
            showAlert(message: "La placa no puede estar vacía.")
            return false
        }
        
        guard let modeloText = modeloEditTextField.text, !modeloText.isEmpty else {
            showAlert(message: "El modelo no puede estar vacío.")
            return false
        }
        
        guard let marcaText = marcaEditTextField.text, !marcaText.isEmpty else {
            showAlert(message: "La marca no puede estar vacía.")
            return false
        }
        
        guard let anioText = anioFabricacionEditTextField.text, !anioText.isEmpty else {
            showAlert(message: "El año de fabricación no puede estar vacío.")
            return false
        }
        
        return true
    }
    
    // Función para validar la placa
    func validatePlaca(_ placa: String) -> Bool {
        // Verificar que la placa solo tenga caracteres alfanuméricos y guiones
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
        return placa.rangeOfCharacter(from: allowedCharacterSet) == nil
    }
    
    // Función para actualizar el bus en Firestore
    func editarBus() {
        // Validar los campos antes de guardar
        guard validateFields() else { return }

        // Validar el año de fabricación
        guard let anioText = anioFabricacionEditTextField.text, validateAnioFabricacion(anioText) else {
            showAlert(message: "El año de fabricación debe ser un número entre 1900 y el año actual.")
            return
        }

        // Validar la placa
        guard var placaText = placaEditTextField.text, !placaText.isEmpty else {
            showAlert(message: "La placa no puede estar vacía.")
            return
        }
        
        // Validar la placa
//        guard validatePlaca(placaText) else {
//            showAlert(message: "La placa \(placaText) contiene caracteres no válidos.")
//            return
//        }
        
        // Formatear la placa para quitar el guion
        placaText = formatPlaca(placaText) // Elimina el guion

        // Validar el modelo (solo letras, sin números)
        guard let modeloText = modeloEditTextField.text, !modeloText.isEmpty, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: modeloText.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "El modelo no puede contener números.")
            return
        }

        // Validar la marca (solo letras, sin números)
        guard let marcaText = marcaEditTextField.text, !marcaText.isEmpty, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: marcaText.replacingOccurrences(of: " ", with: ""))) else {
            showAlert(message: "La marca no puede contener números.")
            return
        }

        // Recuperar los valores
        let modelo = modeloEditTextField.text ?? ""
        let marca = marcaEditTextField.text ?? ""
        let anioFabricacion = anioFabricacionEditTextField.text ?? ""
        let estado = estados[estadoEditPicker.selectedRow(inComponent: 0)]

        // Verificar si el documento existe antes de intentar actualizarlo
        let db = Firestore.firestore()
        let busDocRef = db.collection("buses").document(placaText)

        busDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error al obtener el documento: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                // El documento existe, proceder con la actualización
                busDocRef.updateData([
                    "placa": placaText, // La placa sin guion
                    "modelo": modelo,
                    "marca": marca,
                    "anioFabricacion": anioFabricacion,
                    "estado": estado
                ]) { error in
                    if let error = error {
                        print("Error al actualizar el bus: \(error.localizedDescription)")
                    } else {
                        print("Bus actualizado con éxito.")
                        self.navigationController?.popViewController(animated: true) // Regresar a la lista
                    }
                }
            } else {
                print("El documento con la placa \(placaText) no existe.")
                self.showAlert(message: "El bus con la placa \(placaText) no se encuentra registrado.")
            }
        }
    }

    // Función para formatear la placa a un formato correcto
    func formatPlaca(_ placa: String) -> String {
        // Aquí se elimina el guion y los espacios
        return placa.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }

    // Función para mostrar alertas
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Acción de botón para guardar cambios
    @IBAction func didTapUpdate(_ sender: UIButton) {
        editarBus() // Llamar la función para actualizar el bus
    }
    
    
    // UIPickerView DataSource y Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Solo una columna
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Aquí puedes manejar la selección del estado si es necesario
    }
}
