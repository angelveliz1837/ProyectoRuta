//
//  ListaParaderoViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 11/12/24.
//

import UIKit
import CoreData // importamos CoreData para la persistencia en IOS

//clase padre
class ListaParaderoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //componentes de la UI
    @IBOutlet weak var listaParaderoTableView: UITableView!
    
    //variables
    var paraderoData = [Paradero]() //array de tipo paradero para mostrar a los paraderos
    
    //carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() //llamamos a la funcion de configuracion de la tabla
        showData() //llamamos a la funcion para mostrar los datos del paradero
    }
    
    //cuando esta apunto de aparecer la vista
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listaParaderoTableView.reloadData()//actualizamos la tabla
    }
    
    //FUNCIONES
    //funcion para la conexion a la base de datos
    func connectBD() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate //instanciamos y llamamos al AppDelegate
        return delegate.persistentContainer.viewContext //retornamos el contexto de CoreData del AppDelegate
    }
    
    //funcion para configurar la tabla
    func configureTableView(){
        listaParaderoTableView.delegate = self //delegate
        listaParaderoTableView.dataSource = self //dataSource
        listaParaderoTableView.rowHeight = 300 //tamanio de la celda
    }

    //funcion para mostrar datos
    func showData(){
        let context = connectBD() //contexto para conectarnos a la base de datos
        let fetchRequest: NSFetchRequest<Paradero> = Paradero.fetchRequest()//objeto para visualizar la informacion en el cual debe ser de tipo NSFetchRequest de la base de datos Bus
            // en un capturador de error
        do{
            paraderoData = try context.fetch(fetchRequest)//objeto que llama al contexto para mostrar la informacion
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
        return paraderoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //llamamos a la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParaderoTableViewCell", for: indexPath) as? ParaderoTableViewCell
        let paradero = paraderoData[indexPath.row] //pasamos lo que hay en el arreglo de la lista
        cell?.configureParadero(paradero: paradero, registroParaderoViewController: self) //llamamos a la configuracion de la celda para que se muestren los datos
        return cell ?? UITableViewCell()//retornamos la celda
    }
    
    //para poder eliminar dentro del tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = connectBD() //contexto para conectarnos a la base de datos
        let paradero = paraderoData[indexPath.row]
        //para elegir el swipe de elimianr
        if editingStyle == .delete{
            context.delete(paradero)//eliminamos a la persona de la base de datos
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
        listaParaderoTableView.reloadData() //actualizar la tabla
    }

    //para seleccionar un item de la celda del tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //le pasamos el identificador updateBView
        performSegue(withIdentifier: "updatePView", sender: self)
    }
    
    //llamamos a la funcion del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //igualamos el segue con el identificador updateView
        if segue.identifier == "updatePView" {
            //validamos que el id sea el correcto de la celda de la tabla
            if let id = listaParaderoTableView.indexPathForSelectedRow{
                let rowParadero = paraderoData[id.row] //le pasamos el id de la celda de la tabla a la variable rowBus
                let router = segue.destination as? EditarParaderoViewController //creamos el objeto destino de la clase final
                router?.paraderoUpdate = rowParadero //le enviamos el id hacia el otro viewController
            }
        }
    }
}
