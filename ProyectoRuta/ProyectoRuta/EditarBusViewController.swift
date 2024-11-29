//
//  EditarBusViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import CoreData

class EditarBusViewController: UIViewController {
    
    @IBOutlet weak var placaEditTextField: UITextField!
    @IBOutlet weak var modeloEditTextField: UITextField!
    @IBOutlet weak var marcaEditTextField: UITextField!
    @IBOutlet weak var anioFabricacionEditTextField: UITextField!
    @IBOutlet weak var estadoEditTextField: UITextField!
    
    //variables
    var busUpdate: Bus? //creamos el objeto de item Trabajador de la base de datos
    
    //carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField() //llamamos a la funcion para configurar los campos de texto
    }

    //FUNCIONES
    //funcion para la conexion a la base de datos
    func connectBD() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate //instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext //retornamos el contexto de CoreData del AppDelegate
    }
    
    //funcion para configurar a los campos de texto
    func configureTextField(){
        placaEditTextField.text = busUpdate?.placa
        modeloEditTextField.text = busUpdate?.modelo
        marcaEditTextField.text = busUpdate?.marca
        anioFabricacionEditTextField.text = busUpdate?.anioFabricacion
        estadoEditTextField.text = busUpdate?.estado
    }
    
    //funcion para actualizar bus
    func editarBus(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        busUpdate?.setValue(placaEditTextField.text, forKey: "placa")
        busUpdate?.setValue(modeloEditTextField.text, forKey: "modelo")
        busUpdate?.setValue(marcaEditTextField.text, forKey: "marca")
        busUpdate?.setValue(anioFabricacionEditTextField.text, forKey: "anioFabricacion")
        busUpdate?.setValue(estadoEditTextField.text, forKey: "estado")
        //capturador de errores
        do{
            try context.save() //guardamos en base de datos
            navigationController?.popViewController(animated: true)//retornamos a la pantalla anterior
            print("Se actualizo al usuario bus") //imprimimos
        } catch let error as NSError{
            //aca va el error
            //podriamos poner una vista en especifico pero por el momento solo imprimimos por consola
            print("Error al actualizar: \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        editarBus()//llamamos a la funcion para editar bus
    }
}
