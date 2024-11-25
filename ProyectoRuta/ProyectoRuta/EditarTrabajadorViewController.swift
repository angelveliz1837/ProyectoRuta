//
//  EditarTrabajadorViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 25/11/24.
//

import UIKit
import CoreData

class EditarTrabajadorViewController: UIViewController {
    // componentes de la UI
    @IBOutlet weak var dniEditTextField: UITextField!
    @IBOutlet weak var nombreEditTextField: UITextField!
    @IBOutlet weak var apellidoPaternoEditTextField: UITextField!
    @IBOutlet weak var apellidoMaternoEditTextField: UITextField!
    @IBOutlet weak var cargoEditTextField: UITextField!
    @IBOutlet weak var licenciaEditTextField: UITextField!
    
    //variables
    var trabajadorUpdate: Trabajador? //creamos el objeto de item Trabajador de la base de datos
    
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
        dniEditTextField.text = trabajadorUpdate?.dni
        nombreEditTextField.text = trabajadorUpdate?.nombre
        apellidoPaternoEditTextField.text = trabajadorUpdate?.apellidoPaterno
        apellidoMaternoEditTextField.text = trabajadorUpdate?.apellidoMaterno
        cargoEditTextField.text = trabajadorUpdate?.cargo
        licenciaEditTextField.text = trabajadorUpdate?.licencia
    }
    
    //funcion para actualizar trabajador
    func editarTrabajador(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        trabajadorUpdate?.setValue(dniEditTextField, forKey: "dni")
        trabajadorUpdate?.setValue(nombreEditTextField, forKey: "nombre")
        trabajadorUpdate?.setValue(apellidoPaternoEditTextField, forKey: "apellidoPaterno")
        trabajadorUpdate?.setValue(apellidoMaternoEditTextField, forKey: "apellidoMaterno")
        trabajadorUpdate?.setValue(cargoEditTextField, forKey: "cargo")
        trabajadorUpdate?.setValue(licenciaEditTextField, forKey: "licencia")
        //capturador de errores
        do{
            try context.save() //guardamos en base de datos
            navigationController?.popViewController(animated: true)//retornamos a la pantalla anterior
            print("Se actualizo al usuario trabajador") //imprimimos
        } catch let error as NSError{
            //aca va el error
            //podriamos poner una vista en especifico pero por el momento solo imprimimos por consola
            print("Error al actualizar: \(error.localizedDescription)")
        }
    }
    

    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        editarTrabajador()//llamamos a la funcion para editar trabajador
    }
    
}
