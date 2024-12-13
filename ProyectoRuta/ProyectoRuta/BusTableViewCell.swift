//
//  BusTableViewCell.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit

class BusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placaLabel: UILabel!
    @IBOutlet weak var modeloLabel: UILabel!
    @IBOutlet weak var marcaLabel: UILabel!
    @IBOutlet weak var anioFabricacionLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    
    //variables
    var bus: Bus?//de tipo trabajador de la base de datos
    var registroBusViewController: UIViewController? //de tipo viewController ya que se llamara del ViewController en donde esta el TableView padre
    
    //funcion que se crea por defecto
    //es para inicializar valores
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none //ninguna seleccion de color
        backgroundColor = UIColor.lightGray //la celda su background no tenga color
    }
    
    //funcion que se crea por defecto
    //si algo se selecciona
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //funciones
    func configureBus(bus: Bus, registroBusViewController: UIViewController){
        self.placaLabel.text = "Placa: \(bus.placa ?? "")"
        self.modeloLabel.text = "Modelo: \(bus.modelo ?? "")" //le pasamos el nombre
        self.marcaLabel.text = "Marca: \(bus.marca ?? "")"
        self.anioFabricacionLabel.text = "Anio Fabricacion: \(bus.anioFabricacion ?? "")"
        self.estadoLabel.text = "Estado: \(bus.estado ?? "")"
        self.bus = bus //le pasamos el bus
        self.registroBusViewController = registroBusViewController //le pasamos al mismo viewController
    }

}
