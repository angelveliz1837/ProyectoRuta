import UIKit
import CoreData

class ListaTrabajadorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // UI components
    @IBOutlet weak var listaTrabajadorTableView: UITableView!
    
    // Variables
    var trabajadorData = [Trabajador]() // Array de trabajadores
    var filteredTrabajadores = [Trabajador]() // Array filtrado para búsqueda
    
    // Propiedad para el UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    // Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() // Configuración de la tabla
        showData() // Cargar datos de los trabajadores
        
        // Configuración del UISearchController
        searchController.searchResultsUpdater = self // El delegado de la actualización de resultados
        searchController.obscuresBackgroundDuringPresentation = false // No oscurecer el fondo durante la búsqueda
        searchController.searchBar.placeholder = "Buscar por nombre"
        
        // Establecer el searchBar como el header de la tabla
        listaTrabajadorTableView.tableHeaderView = searchController.searchBar
        
        // Configurar el UISearchController
        definesPresentationContext = true // Para evitar que el Search Controller se muestre cuando la vista está sobrepuesta
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listaTrabajadorTableView.reloadData() // Recargar la tabla
    }
    
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    // Función para configurar la tabla
    func configureTableView() {
        listaTrabajadorTableView.delegate = self
        listaTrabajadorTableView.dataSource = self
        listaTrabajadorTableView.rowHeight = 280
    }
    
    // Función para mostrar datos
    func showData() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Trabajador> = Trabajador.fetchRequest()
        
        do {
            trabajadorData = try context.fetch(fetchRequest)
            filteredTrabajadores = trabajadorData // Inicialmente, los datos filtrados son los mismos que los datos completos
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
        return filteredTrabajadores.count // Usamos filteredTrabajadores en lugar de trabajadorData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrabajadorTableViewCell", for: indexPath) as? TrabajadorTableViewCell
        let trabajador = filteredTrabajadores[indexPath.row]
        cell?.configureTrabajador(trabajador: trabajador, registroTrabajadorViewController: self)
        return cell ?? UITableViewCell()
    }
    
    // Función para eliminar un trabajador
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = connectBD()
        let trabajador = filteredTrabajadores[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(trabajador)
            do {
                try context.save()
                print("Se eliminó el registro")
            } catch let error as NSError {
                print("Error al eliminar el registro: \(error.localizedDescription)")
            }
        }
        
        showData()
        listaTrabajadorTableView.reloadData()
    }
    
    // Función para seleccionar un item de la celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updateView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateView" {
            if let id = listaTrabajadorTableView.indexPathForSelectedRow {
                let rowTrabajador = filteredTrabajadores[id.row]
                let router = segue.destination as? EditarTrabajadorViewController
                router?.trabajadorUpdate = rowTrabajador
            }
        }
    }
    
    // Función para manejar la búsqueda
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredTrabajadores = trabajadorData // Si el campo de búsqueda está vacío, mostramos todos los trabajadores
        } else {
            filteredTrabajadores = trabajadorData.filter { trabajador in
                trabajador.nombre?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        
        listaTrabajadorTableView.reloadData() // Recargamos la tabla con los datos filtrados
    }
}
