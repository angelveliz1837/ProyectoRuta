//
//  BusTableViewCell.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import FirebaseFirestore

class BusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placaLabel: UILabel!
    @IBOutlet weak var modeloLabel: UILabel!
    @IBOutlet weak var marcaLabel: UILabel!
    @IBOutlet weak var anioFabricacionLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    
    // Variables
    var bus: buses? // Usamos la estructura 'buses' que definiste
    var registroBusViewController: UIViewController? // El ViewController que invoca esta celda
    
    // Inicialización de la celda
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none // No cambia el color de la celda al seleccionarse
        backgroundColor = UIColor.lightGray // Establecer el color de fondo
    }
    
    // Si algo se selecciona
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Configuración de la celda con los datos del bus
    func configureBus(bus: buses, registroBusViewController: UIViewController) {
        self.placaLabel.text = "Placa: \(bus.placa)"
        self.modeloLabel.text = "Modelo: \(bus.modelo)"
        self.marcaLabel.text = "Marca: \(bus.marca)"
        self.anioFabricacionLabel.text = "Año de Fabricación: \(bus.anioFabricacion)"
        
        // Verificamos si el estado tiene elementos para mostrarlo correctamente
        if let estado = bus.estado.first {
            self.estadoLabel.text = "Estado: \(estado)"
        } else {
            self.estadoLabel.text = "Estado: No disponible"
        }
        
        self.bus = bus // Asignamos el bus a la variable
        self.registroBusViewController = registroBusViewController // Asignamos el ViewController
    }
}
