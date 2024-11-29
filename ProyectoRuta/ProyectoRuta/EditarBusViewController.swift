//
//  EditarBusViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import CoreData

class EditarBusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var placaEditTextField: UITextField!
    @IBOutlet weak var modeloEditTextField: UITextField!
    @IBOutlet weak var marcaEditTextField: UITextField!
    @IBOutlet weak var anioFabricacionEditTextField: UITextField!
    @IBOutlet weak var estadoEditPicker: UIPickerView!
    
    
    // Variables
    var busUpdate: Bus? // Objeto para el bus a editar
    
    // Datos del Picker
    let estados = ["Activo", "Inactivo"]
    
    let currentYear = Calendar.current.component(.year, from: Date()) // Año actual
    
    // Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField() // Llamamos a la función para configurar los campos de texto
        estadoEditPicker.delegate = self // Asignamos el delegado del picker
        estadoEditPicker.dataSource = self // Asignamos la fuente de datos del picker
        
        // Deshabilitar el campo placa para que no pueda ser editado
        placaEditTextField.isEnabled = false
    }
    
    // FUNCIONES
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate // Instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext // Retornamos el contexto de CoreData del AppDelegate
    }
    
    // Función para configurar los campos de texto
    func configureTextField() {
        placaEditTextField.text = busUpdate?.placa // Asignamos la placa (no se puede modificar)
        modeloEditTextField.text = busUpdate?.modelo
        marcaEditTextField.text = busUpdate?.marca
        // Ahora asignamos anioFabricacion como String
        anioFabricacionEditTextField.text = busUpdate?.anioFabricacion // Se espera que sea String
        
        // Configuramos el estado del picker con el valor correspondiente
        if let estado = busUpdate?.estado, let index = estados.firstIndex(of: estado) {
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
    
    // Función para actualizar el bus
    func editarBus() {
        // Validar el año de fabricación
        guard let anioText = anioFabricacionEditTextField.text, validateAnioFabricacion(anioText) else {
            showAlert(message: "El año de fabricación debe ser un número entre 1900 y el año actual.")
            return
        }
        
        let context = connectBD() // Contexto para conectarnos a la base de datos
        busUpdate?.setValue(placaEditTextField.text, forKey: "placa")
        busUpdate?.setValue(modeloEditTextField.text, forKey: "modelo")
        busUpdate?.setValue(marcaEditTextField.text, forKey: "marca")
        
        // Asignamos el valor del campo "anioFabricacion" como String (no necesitamos convertirlo)
        busUpdate?.setValue(anioFabricacionEditTextField.text, forKey: "anioFabricacion")
        
        // Obtenemos el estado seleccionado en el picker
        let estadoSeleccionado = estados[estadoEditPicker.selectedRow(inComponent: 0)]
        busUpdate?.setValue(estadoSeleccionado, forKey: "estado")
        
        // Capturador de errores
        do {
            try context.save() // Guardamos en base de datos
            navigationController?.popViewController(animated: true) // Retornamos a la pantalla anterior
            print("Se actualizó el bus") // Imprimimos
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
        editarBus() // Llamamos a la función para editar el bus
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
        // No es necesario hacer nada aquí, ya que el valor se guarda cuando se actualiza el bus.
    }
}
