//
//  ParaderoTableViewCell.swift
//  ProyectoRuta
//
//  Created by DAMII on 11/12/24.
//

import UIKit

class ParaderoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numeroParaderoLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var nombreParaderoLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    
    //variables
    var paradero: Paradero?//de tipo paradero de la base de datos
    var registroParaderoViewController: UIViewController? //de tipo viewController ya que se llamara del ViewController en donde esta el TableView padre
    
    //es para inicializar valores
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none //ninguna seleccion de color
        backgroundColor = UIColor.lightGray //la celda su background no tenga color
    }
    
    //si algo se selecciona
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //funciones
    func configureParadero(paradero: Paradero, registroParaderoViewController: UIViewController){
        self.numeroParaderoLabel.text = "Numero de Paradero: \(paradero.numeroParadero ?? "")"
        self.direccionLabel.text = "Direccion: \(paradero.direccion ?? "")"
        self.nombreParaderoLabel.text = "Nombre Paradero: \(paradero.nombreParadero ?? "")"
        self.estadoLabel.text = "Estado: \(paradero.estado ?? "")"
        self.paradero = paradero //le pasamos el paradero
        self.registroParaderoViewController = registroParaderoViewController //le pasamos al mismo viewController
    }
}
