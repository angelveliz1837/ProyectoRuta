import UIKit
import FirebaseFirestore

class ListaTrabajadorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var listaTrabajadorTableView: UITableView!

    var trabajadorData: [trabajadores] = [] // Tipo explícito
    var filteredTrabajadores: [trabajadores] = [] // Tipo explícito
    var trabajadorUpdate: trabajadores?

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchDataFromFirebase() // Cargar datos desde Firebase
        
        // Configuración de la búsqueda
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar por nombre"
        listaTrabajadorTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }

    // Configurar la tabla
    func configureTableView() {
        listaTrabajadorTableView.delegate = self
        listaTrabajadorTableView.dataSource = self
        listaTrabajadorTableView.rowHeight = 280
    }

    // Obtener datos de Firebase
    func fetchDataFromFirebase() {
        let db = Firestore.firestore()
        db.collection("trabajadores").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error al obtener documentos: \(error.localizedDescription)")
                return
            }
            
            self.trabajadorData = snapshot?.documents.map { document in
                return trabajadores(document: document)
            } ?? []
            
            self.filteredTrabajadores = self.trabajadorData
            self.listaTrabajadorTableView.reloadData()
        }
    }

    // UITableViewDataSource y UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTrabajadores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrabajadorTableViewCell", for: indexPath) as? TrabajadorTableViewCell
        let trabajador = filteredTrabajadores[indexPath.row]
        cell?.configureTrabajador(trabajador: trabajador, registroTrabajadorViewController: self)
        return cell ?? UITableViewCell()
    }

    // Función para eliminar un trabajador  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trabajadores = filteredTrabajadores[indexPath.row]
            let db = Firestore.firestore()
            
            // Eliminar trabajador de Firebase
            db.collection("trabajadores").document(trabajadores.dni ?? "").delete { error in
                if let error = error {
                    print("Error al eliminar: \(error.localizedDescription)")
                } else {
                    print("Trabajador eliminado exitosamente")
                }
            }
            
            // Eliminar de los datos locales
            self.trabajadorData.remove(at: indexPath.row)
            self.filteredTrabajadores.remove(at: indexPath.row)
            self.listaTrabajadorTableView.reloadData()
        }
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
            filteredTrabajadores = trabajadorData
        } else {
            filteredTrabajadores = trabajadorData.filter { trabajadores in
                trabajadores.nombre.lowercased().contains(searchText.lowercased())
            }
        }
        
        listaTrabajadorTableView.reloadData()
    }
}
