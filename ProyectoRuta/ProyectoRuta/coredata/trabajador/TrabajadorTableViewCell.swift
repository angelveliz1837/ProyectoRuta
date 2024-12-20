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
        backgroundColor = UIColor.lightGray //la celda su background tenga color
    }
    
    //funcion que se crea por defecto
    //si algo se selecciona
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //funciones
    func configureTrabajador(trabajador: trabajadores, registroTrabajadorViewController: UIViewController) {
        self.dniLabel.text = "DNI: \(trabajador.dni)"
        self.nombreLabel.text = "Nombre: \(trabajador.nombre)"
        self.apellidoPaternoLabel.text = "Apellido Paterno: \(trabajador.apellidoPaterno)"
        self.apellidoMaternoLabel.text = "Apellido Materno: \(trabajador.apellidoMaterno)"
        self.cargoLabel.text = "Cargo: \(trabajador.cargo)"
        self.licenciaLabel.text = "Licencia: \(trabajador.licencia)"
        self.registroTrabajadorViewController = registroTrabajadorViewController
    }

}
