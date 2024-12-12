//
//  SociosViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 12/12/24.
//

import UIKit

class SociosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listaSocioTableView: UITableView!
    
    // Array para almacenar los socios
    var arraySocio = [Socio]()  // Ahora es un array de Socios, no de SocioResponse
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
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
    
    // Función para obtener los datos de la API
    func fetchData() {
        let webService = "http://reqres.in/api/users"
        guard let url = URL(string: webService) else {
            return
        }
        
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
                
                DispatchQueue.main.async {
                    self?.listaSocioTableView.reloadData() // Recargamos la tabla
                }
            } catch {
                print("Error al parsear datos: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // UITableViewDelegate y UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySocio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listaSocioTableView.dequeueReusableCell(withIdentifier: "ListaSocioTableViewCell", for: indexPath) as? ListaSocioTableViewCell
        let list = arraySocio[indexPath.row]  // Obtener el socio de la lista
        cell?.configureView(viewList: list)  // Configurar la celda con los datos del socio
        return cell ?? UITableViewCell()
    }
}
