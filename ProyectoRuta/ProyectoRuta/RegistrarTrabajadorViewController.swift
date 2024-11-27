//
//  RegistrarTrabajadorViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import CoreData
//clase padre RegistroTrabajadorViewController
class RegistrarTrabajadorViewController: UIViewController {
    
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoPaternoTextField: UITextField!
    @IBOutlet weak var apellidoMaternoTextField: UITextField!
    @IBOutlet weak var cargoTextField: UITextField!
    @IBOutlet weak var licenciaTextField: UITextField!
    
    
    var dni = ""
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
    var cargo = ""
    var licencia = ""

    //carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Funciones
    //funcion para la conexion a la base de datos
    func connectBD() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate //instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext //retornamos el contexto de CoreData del AppDelegate
    }
    
    //funcion para guardar
    func saveTrabajador(){
        let context = connectBD()//contexto para conectarnos a la base de datos
        let entityTrabajador = NSEntityDescription.insertNewObject(forEntityName: "Trabajador", into: context) as! Trabajador //insertamos objetos en la base de datos Trabajador
        entityTrabajador.dni = dniTextField.text //le asignamos valor al dni lo que vamos escribiendo
        entityTrabajador.nombre = nombreTextField.text
        entityTrabajador.apellidoPaterno = apellidoPaternoTextField.text
        entityTrabajador.apellidoMaterno = apellidoMaternoTextField.text
        entityTrabajador.cargo = cargoTextField.text
        entityTrabajador.licencia = licenciaTextField.text
        
        //capturador de error
        do{
            try context.save() //guardamos la informacion
            clearTextField()
            print("Se guardo a la persona")//imprimir en consola
        } catch let error as NSError{
            //aca va el error
            //podriamos poner una vista en especifica pero por el momento solo imprimimos por consola
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    //funcion para mostrar
    func showTrabajador(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest: NSFetchRequest<Trabajador> = Trabajador.fetchRequest() //objeto para visualizar la informacion en el cual debe ser de tipo NSFetchRequest de la base de datos Trabajador
            //en un capturador de error
        do{
            let result = try context.fetch(fetchRequest) //objeto que llama al contexto para mostrar la informacion
            
            print("Registro: \(result.count)")
            //recorremos el resultado y dentro capturamos los valores
            for responseCoreData in result as [NSManagedObject]{
                let dni = responseCoreData.value(forKey: "dni")//capturamos dni
                let nombre = responseCoreData.value(forKey: "nombre")
                let apellidoPaterno = responseCoreData.value(forKey: "apellidoPaterno")
                let apellidoMaterno = responseCoreData.value(forKey: "apellidoMaterno")
                let cargo = responseCoreData.value(forKey: "cargo")
                let licencia = responseCoreData.value(forKey: "licencia")
                print("DNI: \(dni ?? "")\nNombre: \(nombre ?? "")\nApellido Paterno: \(apellidoPaterno ?? "")\nApellido Materno: \(apellidoMaterno ?? "")\nCargo: \(cargo ?? "")\nLicencia: \(licencia ?? "")") //imprimimos
            }
        } catch let error as NSError{
            //Podriamos poner una vista en especifica pero por el momento solo imprimos consola
            print("Error al mostrar: \(error.localizedDescription)")
        }
    }
    
    //funcion para borrar
    func deleteTrabajador(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Trabajador")//hacemos la consulta a la base de datos Trabajador
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)//vamos a eliminar de forma masiva los datos
        //en un capturador de error
        do{
            try context.execute(delete)//ejecutamos el contexto de la consulta a la base de datos
            clearTextField()//llamamos a la funcion para limpiar los campos
            print("Trabajadores Borrados")//imprimimos consola
        } catch let error as NSError{
            //podriamos poner una vista en especifica pero por el momento solo imprimimos por consola
            print("Error al borrar: \(error.localizedDescription)")
        }
    }
    
    func clearTextField(){
        dniTextField.text = ""
        nombreTextField.text = ""
        apellidoPaternoTextField.text = ""
        apellidoMaternoTextField.text = ""
        cargoTextField.text = ""
        licenciaTextField.text = ""
        dniTextField.becomeFirstResponder() //focus al dni
        
    }
    
    
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        saveTrabajador() //llamamos a la funcion de guardar
    }
    

    @IBAction func didTapTable(_ sender: UIButton) {
        print("Dirigirnos a la siguiente vista de la tabla")
    }
}
