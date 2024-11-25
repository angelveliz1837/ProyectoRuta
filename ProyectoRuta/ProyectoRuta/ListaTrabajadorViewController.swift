//
//  ListaTrabajadorViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 25/11/24.
//

import UIKit // importamos UI
import CoreData // importamos CoreData para la persistencia en IOS

//clase padre
class ListaTrabajadorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //componentes de la UI
    @IBOutlet weak var listaTrabajadorTableView: UITableView!
    
    //variables
    var trabajadorData = [Trabajador]() //array de tipo trabajador para mostrar a los trabajadores
    
    //carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() //llamamos a la funcion de configuracion de la tabla
        showData() //llamamos a la funcion para mostrar los datos del trabajador
    }
    
    //cuando esta apunto de aparecer la vista
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listaTrabajadorTableView.reloadData()//actualizamos la tabla
    }
    
    //FUNCIONES
    //funcion para la conexion a la base de datos
    func connectBD() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate //instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext //retornamos el contexto de CoreData del AppDelegate
    }
    
    //funcion para configurar la tabla
    func configureTableView(){
        listaTrabajadorTableView.delegate = self //delegate
        listaTrabajadorTableView.dataSource = self //dataSource
        listaTrabajadorTableView.rowHeight = 60 //tamanio de la celda
    }
    
    //funcion para mostrar datos
    func showData(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest: NSFetchRequest<Trabajador> = Trabajador.fetchRequest()//objeto para visualizar la informacion en el cual debe ser de tipo NSFetchRequest de la base de datos Trabajador
            // en un capturador de error
        do{
            trabajadorData = try context.fetch(fetchRequest)//objeto que llama al contexto para mostrar la informacion
            print("Se mostraron los datos en la tabla")//imprimir
        } catch let error as NSError{
            //aca va el error
            //podriamos poner una vista en especifica pero por el momento solos imprimimos por consola
            print("Error al mostrar: \(error.localizedDescription)")
        }
    }
    
    //UITableViewDelegate - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        //retornamos un porque solo hay un table view
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //retornamos la cantidad del arreglo de la lista
        return trabajadorData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //llamamos a la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let trabajador = trabajadorData[indexPath.row] //pasamos lo que hay en el arreglo de la lista
        cell.textLabel?.text = "DNI: \(trabajador.dni ?? "")"//le pasamos el dni
        cell.textLabel?.text = "Nombre: \(trabajador.nombre ?? "")"
        cell.textLabel?.text = "Apellido Paterno: \(trabajador.apellidoPaterno ?? "")"
        cell.textLabel?.text = "Apellido Materno: \(trabajador.apellidoMaterno ?? "")"
        cell.textLabel?.text = "Cargo: \(trabajador.cargo ?? "")"
        cell.textLabel?.text = "Licencia: \(trabajador.licencia ?? "")"
        cell.selectionStyle = .none //ningun estilo
        return cell //retornamos la celda
    }
    
    //para poder eliminar dentro del tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = connectBD() //contexto para conectarnos a la base de datos
        let trabajador = trabajadorData[indexPath.row]
        //para elegir el swipe de elimianr
        if editingStyle == .delete{
            context.delete(trabajador)//eliminamos a la persona de la base de datos
            //en un capturador de error
            do{
                try context.save()//guardamos
                print("Se elimino el registrar") //imprimir
            } catch let error as NSError{
                //aca va el error
                //podriamos poner una vista en especifica pero por el momento solo imprimimos por consola
                print("Error al eliminar el registro: \(error.localizedDescription)")
            }
        }
        showData() //llamar a la funcion para mostrar a las personas
        listaTrabajadorTableView.reloadData() //actualizar la tabla
    }
    
    //para seleccionar un item de la celda del tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //le pasamos el identificador updateView
        performSegue(withIdentifier: "updateView", sender: self)
    }
    
    //llamamos a la funcion del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //igualamos el segue con el identificador updateView
        if segue.identifier == "updateView" {
            //validamos que el id sea el correcto de la celda de la tabla
            if let id = listaTrabajadorTableView.indexPathForSelectedRow{
                let rowTrabajador = trabajadorData[id.row] //le pasamos el id de la celda de la tabla a la variable rowTrabajador
                let router = segue.destination as? EditarTrabajadorViewController //creamos el objeto destino de la clase final
                router?.trabajadorUpdate = rowTrabajador //le enviamos el id hacia el otro viewController
            }
        }
    }


}
