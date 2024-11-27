//
//  RegistrarBusViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import CoreData
//clase padre RegistroBusViewController
class RegistrarBusViewController: UIViewController {
    
    @IBOutlet weak var placaTextField: UITextField!
    @IBOutlet weak var modeloTextField: UITextField!
    @IBOutlet weak var marcaTextField: UITextField!
    @IBOutlet weak var anioFabricacionTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    
    var placa = ""
    var modelo = ""
    var marca = ""
    var anioFabricacion = ""
    var estado = ""

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
    func saveBus(){
        let context = connectBD()//contexto para conectarnos a la base de datos
        let entityBus = NSEntityDescription.insertNewObject(forEntityName: "Bus", into: context) as! Bus //insertamos objetos en la base de datos Bus
        entityBus.placa = placaTextField.text //le asignamos valor placa lo que vamos escribiendo
        entityBus.modelo = modeloTextField.text
        entityBus.marca = marcaTextField.text
        entityBus.anioFabricacion = anioFabricacionTextField.text
        entityBus.estado = estadoTextField.text

        //capturador de error
        do{
            try context.save() //guardamos la informacion
            clearTextField()
            print("Se guardo el bus")//imprimir en consola
        } catch let error as NSError{
            //aca va el error
            //podriamos poner una vista en especifica pero por el momento solo imprimimos por consola
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    //funcion para mostrar
    func showBus(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest: NSFetchRequest<Bus> = Bus.fetchRequest() //objeto para visualizar la informacion en el cual debe ser de tipo NSFetchRequest de la base de datos Bus
            //en un capturador de error
        do{
            let result = try context.fetch(fetchRequest) //objeto que llama al contexto para mostrar la informacion
            
            print("Registro: \(result.count)")
            //recorremos el resultado y dentro capturamos los valores
            for responseCoreData in result as [NSManagedObject]{
                let placa = responseCoreData.value(forKey: "placa")//capturamos dni
                let modelo = responseCoreData.value(forKey: "modelo")
                let marca = responseCoreData.value(forKey: "marca")
                let anioFabricacion = responseCoreData.value(forKey: "anioFabricacion")
                let estado = responseCoreData.value(forKey: "estado")
                print("Placa: \(placa ?? "")\nModelo: \(modelo ?? "")\nMarca: \(marca ?? "")\nAnio Fabricacion: \(anioFabricacion ?? "")\nEstado: \(estado ?? "")") //imprimimos
            }
        } catch let error as NSError{
            //Podriamos poner una vista en especifica pero por el momento solo imprimos consola
            print("Error al mostrar: \(error.localizedDescription)")
        }
    }
    
    //funcion para borrar
    func deleteBus(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bus")//hacemos la consulta a la base de datos Trabajador
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)//vamos a eliminar de forma masiva los datos
        //en un capturador de error
        do{
            try context.execute(delete)//ejecutamos el contexto de la consulta a la base de datos
            clearTextField()//llamamos a la funcion para limpiar los campos
            print("Buses Borrados")//imprimimos consola
        } catch let error as NSError{
            //podriamos poner una vista en especifica pero por el momento solo imprimimos por consola
            print("Error al borrar: \(error.localizedDescription)")
        }
    }
    
    func clearTextField(){
        placaTextField.text = ""
        modeloTextField.text = ""
        marcaTextField.text = ""
        anioFabricacionTextField.text = ""
        estadoTextField.text = ""
        placaTextField.becomeFirstResponder() //focus al placa
    }
    
    
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        saveBus() //llamamos a la funcion de guardar
    }
    
    
    @IBAction func didTapTable(_ sender: UIButton) {
        print("Dirigirnos a la siguiente vista de la tabla")
    }
    
}
