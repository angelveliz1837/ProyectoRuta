//
//  SociosViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 12/12/24.
//

import UIKit

class SociosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var listaSocioTableView: UITableView!
    
    // Arrays para almacenar los socios y los filtrados
    var arraySocio = [Socio]()
    var filteredSocios = [Socio]()
    
    // Barra de búsqueda
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
        fetchData()
    }
    
    // Configuración de la tabla
    func configureTableView() {
        listaSocioTableView.delegate = self
        listaSocioTableView.dataSource = self
        listaSocioTableView.register(UINib(nibName: "ListaSocioTableViewCell", bundle: nil), forCellReuseIdentifier: "ListaSocioTableViewCell")
        listaSocioTableView.rowHeight = 150
        listaSocioTableView.showsVerticalScrollIndicator = false
        listaSocioTableView.separatorStyle = .none
    }
    
    // Configuración del SearchController
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self  // Asignamos el delegado para actualizar los resultados
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar por nombre"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // Función para obtener los datos de la API
    func fetchData() {
        let webService = "http://reqres.in/api/users"
        guard let url = URL(string: webService) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            // Verificación de la respuesta
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                print("Error general: \(String(describing: error?.localizedDescription))")
                return
            }
            
            // Procesamiento de los datos
            do {
                guard let dataJSON = data else { return }
                
                // Decodificamos la respuesta completa (APIResponse) que contiene los datos de los socios
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: dataJSON)
                
                // Asignamos los datos de los socios a nuestro array
                self?.arraySocio = apiResponse.data
                self?.filteredSocios = apiResponse.data  // Inicializamos los datos filtrados con todos los socios
                
                DispatchQueue.main.async {
                    self?.listaSocioTableView.reloadData() // Recargamos la tabla
                }
            } catch {
                print("Error al parsear datos: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // Función de filtrado por nombre
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredSocios = arraySocio  // Si no hay texto, mostramos todos los socios
        } else {
            filteredSocios = arraySocio.filter { socio in
                // Aquí se realiza la comparación con el nombre del socio
                return socio.first_name.lowercased().contains(searchText.lowercased())
            }
        }
        listaSocioTableView.reloadData()  // Recargamos la tabla con los resultados filtrados
    }
    
    // UITableViewDelegate y UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSocios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listaSocioTableView.dequeueReusableCell(withIdentifier: "ListaSocioTableViewCell", for: indexPath) as? ListaSocioTableViewCell
        let list = filteredSocios[indexPath.row]  // Obtener el socio filtrado
        cell?.configureView(viewList: list)  // Configurar la celda con los datos del socio
        return cell ?? UITableViewCell()
    }
}

// Extensión para implementar el SearchResultsUpdating (delegado del UISearchController)
extension SociosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Filtramos los socios cuando el texto en la barra de búsqueda cambia
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
        }
    }
}
