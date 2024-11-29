//
//  RegistrarTrabajadorViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import CoreData
//clase padre RegistroTrabajadorViewController
class RegistrarTrabajadorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoPaternoTextField: UITextField!
    @IBOutlet weak var apellidoMaternoTextField: UITextField!
    @IBOutlet weak var cargoPicker: UIPickerView!
    @IBOutlet weak var licenciaTextField: UITextField!
    
    
    let cargos = ["Chofer", "Monitor"] // Opciones para el cargo
    var selectedCargo: String? // Variable para almacenar el cargo seleccionado
    
    var dni = ""
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
    var cargo = ""
    var licencia = ""

    //carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()

    //         // Asegurarnos de que el UIPickerView sea interactivo
         cargoPicker.isUserInteractionEnabled = true
        
        // Configurar UIPickerView para el campo "cargo"
        cargoPicker.delegate = self
        cargoPicker.dataSource = self
        
        // Configuración inicial del cargo
        selectedCargo = cargos.first
        cargoPicker.selectRow(0, inComponent: 0, animated: false) // Seleccionar el primer valor
    }
    
    //Funciones
    //funcion para la conexion a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate //instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext //retornamos el contexto de CoreData del AppDelegate
    }
    
    //función para validar los datos ingresados
    func validateFields() -> Bool {
        guard let dniText = dniTextField.text, dniText.count == 8, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: dniText)) else {
            print("El DNI debe tener exactamente 8 números")
            return false
        }
        
        guard let nombreText = nombreTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: nombreText.replacingOccurrences(of: " ", with: ""))) else {
            print("El nombre no puede contener números")
            return false
        }
        
        guard let apellidoPText = apellidoPaternoTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: apellidoPText.replacingOccurrences(of: " ", with: ""))) else {
            print("El apellido paterno no puede contener números")
            return false
        }
        
        guard let apellidoMText = apellidoMaternoTextField.text, CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: apellidoMText.replacingOccurrences(of: " ", with: ""))) else {
            print("El apellido materno no puede contener números")
            return false
        }
        
        if selectedCargo == "Chofer", let licenciaText = licenciaTextField.text, licenciaText.isEmpty {
            print("La licencia es obligatoria para el cargo de Chofer")
            return false
        }
        
        return true
    }
    
    //función para guardar
    func saveTrabajador() {
        guard validateFields() else { return } // Validar los campos antes de guardar
        
        let context = connectBD() //contexto para conectarnos a la base de datos
        let entityTrabajador = NSEntityDescription.insertNewObject(forEntityName: "Trabajador", into: context) as! Trabajador //insertamos objetos en la base de datos Trabajador
        entityTrabajador.dni = dniTextField.text //le asignamos valor al dni lo que vamos escribiendo
        entityTrabajador.nombre = nombreTextField.text
        entityTrabajador.apellidoPaterno = apellidoPaternoTextField.text
        entityTrabajador.apellidoMaterno = apellidoMaternoTextField.text
        entityTrabajador.cargo = selectedCargo
        entityTrabajador.licencia = licenciaTextField.text
        
        //capturador de error
        do {
            try context.save() //guardamos la información
            clearTextField()
            print("Se guardó a la persona") //imprimir en consola
        } catch let error as NSError {
            //aca va el error
            //podríamos poner una vista en especifica pero por el momento solo imprimimos por consola
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    //función para mostrar
    func showTrabajador() {
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest: NSFetchRequest<Trabajador> = Trabajador.fetchRequest() //objeto para visualizar la información en el cual debe ser de tipo NSFetchRequest de la base de datos Trabajador
            //en un capturador de error
        do {
            let result = try context.fetch(fetchRequest) //objeto que llama al contexto para mostrar la información
            
            print("Registro: \(result.count)")
            //recorremos el resultado y dentro capturamos los valores
            for responseCoreData in result as [NSManagedObject] {
                let dni = responseCoreData.value(forKey: "dni") //capturamos dni
                let nombre = responseCoreData.value(forKey: "nombre")
                let apellidoPaterno = responseCoreData.value(forKey: "apellidoPaterno")
                let apellidoMaterno = responseCoreData.value(forKey: "apellidoMaterno")
                let cargo = responseCoreData.value(forKey: "cargo")
                let licencia = responseCoreData.value(forKey: "licencia")
                print("DNI: \(dni ?? "")\nNombre: \(nombre ?? "")\nApellido Paterno: \(apellidoPaterno ?? "")\nApellido Materno: \(apellidoMaterno ?? "")\nCargo: \(cargo ?? "")\nLicencia: \(licencia ?? "")") //imprimimos
            }
        } catch let error as NSError {
            //Podríamos poner una vista en especifica pero por el momento solo imprimimos consola
            print("Error al mostrar: \(error.localizedDescription)")
        }
    }
    
    //función para borrar
    func deleteTrabajador() {
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Trabajador") //hacemos la consulta a la base de datos Trabajador
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest) //vamos a eliminar de forma masiva los datos
        //en un capturador de error
        do {
            try context.execute(delete) //ejecutamos el contexto de la consulta a la base de datos
            clearTextField() //llamamos a la función para limpiar los campos
            print("Trabajadores Borrados") //imprimimos consola
        } catch let error as NSError {
            //podríamos poner una vista en específica pero por el momento solo imprimimos por consola
            print("Error al borrar: \(error.localizedDescription)")
        }
    }
    
    func clearTextField() {
        dniTextField.text = ""
        nombreTextField.text = ""
        apellidoPaternoTextField.text = ""
        apellidoMaternoTextField.text = ""
        selectedCargo = cargos.first // Resetear al primer valor
        cargoPicker.selectRow(0, inComponent: 0, animated: false) // Reiniciar el Picker
        licenciaTextField.text = ""
        dniTextField.becomeFirstResponder() //focus al dni
    }
    
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        saveTrabajador() //llamamos a la función de guardar
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
    }
}
