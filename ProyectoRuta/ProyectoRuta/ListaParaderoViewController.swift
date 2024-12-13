import UIKit
import CoreData // Importamos CoreData

class ListaParaderoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // UI components
    @IBOutlet weak var listaParaderoTableView: UITableView!
    
    // Variables
    var paraderoData = [Paradero]() // Array de paraderos
    var filteredParaderos = [Paradero]() // Array filtrado para búsqueda
    
    // Propiedad para el UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    // Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() // Configurar la tabla
        showData() // Mostrar datos de los paraderos
        
        // Configuración del UISearchController
        searchController.searchResultsUpdater = self // El delegado para la actualización de resultados
        searchController.obscuresBackgroundDuringPresentation = false // No oscurecer el fondo
        searchController.searchBar.placeholder = "Buscar por dirección"
        
        // Establecer el searchBar como el header de la tabla
        listaParaderoTableView.tableHeaderView = searchController.searchBar
        
        // Configurar el UISearchController
        definesPresentationContext = true // Para evitar que el SearchController se muestre cuando la vista esté sobrepuesta
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listaParaderoTableView.reloadData() // Recargar la tabla
    }
    
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    // Función para configurar la tabla
    func configureTableView() {
        listaParaderoTableView.delegate = self
        listaParaderoTableView.dataSource = self
        listaParaderoTableView.rowHeight = 300
    }
    
    // Función para mostrar datos
    func showData() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Paradero> = Paradero.fetchRequest()
        
        do {
            paraderoData = try context.fetch(fetchRequest)
            filteredParaderos = paraderoData // Inicialmente, los datos filtrados son los mismos que los datos completos
            print("Se mostraron los datos en la tabla")
        } catch let error as NSError {
            print("Error al mostrar: \(error.localizedDescription)")
        }
    }
    
    // UITableViewDataSource y UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredParaderos.count // Usamos filteredParaderos en lugar de paraderoData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParaderoTableViewCell", for: indexPath) as? ParaderoTableViewCell
        let paradero = filteredParaderos[indexPath.row] // Obtenemos el paradero de los datos filtrados
        cell?.configureParadero(paradero: paradero, registroParaderoViewController: self) // Configuramos la celda
        return cell ?? UITableViewCell() // Devolvemos la celda
    }
    
    // Función para eliminar un paradero
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = connectBD()
        let paradero = filteredParaderos[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(paradero)
            do {
                try context.save()
                print("Se eliminó el registro")
            } catch let error as NSError {
                print("Error al eliminar el registro: \(error.localizedDescription)")
            }
        }
        
        showData()
        listaParaderoTableView.reloadData()
    }
    
    // Función para seleccionar un item de la celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updatePView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updatePView" {
            if let id = listaParaderoTableView.indexPathForSelectedRow {
                let rowParadero = filteredParaderos[id.row]
                let router = segue.destination as? EditarParaderoViewController
                router?.paraderoUpdate = rowParadero
            }
        }
    }
    
    // Función para manejar la búsqueda
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredParaderos = paraderoData // Si el campo de búsqueda está vacío, mostramos todos los paraderos
        } else {
            filteredParaderos = paraderoData.filter { paradero in
                paradero.direccion?.lowercased().contains(searchText.lowercased()) ?? false // Filtramos por la dirección del paradero
            }
        }
        
        listaParaderoTableView.reloadData() // Recargamos la tabla con los resultados filtrados
    }
}
