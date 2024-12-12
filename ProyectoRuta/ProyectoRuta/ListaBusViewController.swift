import UIKit
import CoreData

class ListaBusViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // UI components
    @IBOutlet weak var listaBusTableView: UITableView!
    
    // Variables
    var busData = [Bus]() // Array de buses
    var filteredBuses = [Bus]() // Array filtrado para búsqueda
    
    // Propiedad para el UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    // Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() // Configurar la tabla
        showData() // Mostrar datos de los buses
        
        // Configuración del UISearchController
        searchController.searchResultsUpdater = self // El delegado para la actualización de resultados
        searchController.obscuresBackgroundDuringPresentation = false // No oscurecer el fondo
        searchController.searchBar.placeholder = "Buscar por modelo de bus"
        
        // Establecer el searchBar como el header de la tabla
        listaBusTableView.tableHeaderView = searchController.searchBar
        
        // Configurar el UISearchController
        definesPresentationContext = true // Para evitar que el SearchController se muestre cuando la vista esté sobrepuesta
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listaBusTableView.reloadData() // Recargar la tabla
    }
    
    // Función para la conexión a la base de datos
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    // Función para configurar la tabla
    func configureTableView() {
        listaBusTableView.delegate = self
        listaBusTableView.dataSource = self
        listaBusTableView.rowHeight = 300
    }
    
    // Función para mostrar datos
    func showData() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Bus> = Bus.fetchRequest()
        
        do {
            busData = try context.fetch(fetchRequest)
            filteredBuses = busData // Inicialmente, los datos filtrados son los mismos que los datos completos
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
        return filteredBuses.count // Usamos filteredBuses en lugar de busData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusTableViewCell", for: indexPath) as? BusTableViewCell
        let bus = filteredBuses[indexPath.row] // Obtenemos el bus de los datos filtrados
        cell?.configureBus(bus: bus, registroBusViewController: self) // Configuramos la celda
        return cell ?? UITableViewCell() // Devolvemos la celda
    }
    
    // Función para eliminar un bus
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = connectBD()
        let bus = filteredBuses[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(bus)
            do {
                try context.save()
                print("Se eliminó el registro")
            } catch let error as NSError {
                print("Error al eliminar el registro: \(error.localizedDescription)")
            }
        }
        
        showData()
        listaBusTableView.reloadData()
    }
    
    // Función para seleccionar un item de la celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updateBView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateBView" {
            if let id = listaBusTableView.indexPathForSelectedRow {
                let rowBus = filteredBuses[id.row]
                let router = segue.destination as? EditarBusViewController
                router?.busUpdate = rowBus
            }
        }
    }
    
    // Función para manejar la búsqueda
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredBuses = busData // Si el campo de búsqueda está vacío, mostramos todos los buses
        } else {
            filteredBuses = busData.filter { bus in
                bus.modelo?.lowercased().contains(searchText.lowercased()) ?? false // Filtramos por el modelo del bus
            }
        }
        
        listaBusTableView.reloadData() // Recargamos la tabla con los resultados filtrados
    }
}
