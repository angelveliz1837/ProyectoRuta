//
//  TrabajadorTableViewCell.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit

class TrabajadorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var apellidoPaternoLabel: UILabel!
    @IBOutlet weak var apellidoMaternoLabel: UILabel!
    @IBOutlet weak var cargoLabel: UILabel!
    @IBOutlet weak var licenciaLabel: UILabel!
    
    //variables
    var trabajador: Trabajador?//de tipo trabajador de la base de datos
    var registroTrabajadorViewController: UIViewController? //de tipo viewController ya que se llamara del ViewController en donde esta el TableView padre
    
    //funcion que se crea por defecto
    //es para inicializar valores
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none //ninguna seleccion de color
        backgroundColor = UIColor.clear //la celda su background no tenga color
    }
    
    //funcion que se crea por defecto
    //si algo se selecciona
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //funciones
    func configureTrabajador(trabajador: Trabajador, registroTrabajadorViewController: UIViewController){
        self.dniLabel.text = "DNI: \(trabajador.dni ?? "")"
        self.nombreLabel.text = "Nombre: \(trabajador.nombre ?? "")" //le pasamos el nombre
        self.apellidoPaternoLabel.text = "Apellido Paterno: \(trabajador.apellidoPaterno ?? "")"
        self.apellidoMaternoLabel.text = "Apellido Materno: \(trabajador.apellidoMaterno ?? "")" //le pasamos el nombre
        self.cargoLabel.text = "Cargo: \(trabajador.cargo ?? "")"
        self.licenciaLabel.text = "Licencia: \(trabajador.licencia ?? "")" //le pasamos el nombre
        self.trabajador = trabajador //le pasamos el trabajador
        self.registroTrabajadorViewController = registroTrabajadorViewController //le pasamos al mismo viewController
    }
}
