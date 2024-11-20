//
//  PaseTrabajadorViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 20/11/24.
//

import UIKit

class PaseTrabajadorViewController: UIViewController {
    
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var apellidoPaternoLabel: UILabel!
    @IBOutlet weak var apellidoMaternoLabel: UILabel!
    @IBOutlet weak var cargoLabel: UILabel!
    @IBOutlet weak var licenciaLabel: UILabel!
    
    var dniResult: String = ""
    var nombreResult: String = ""
    var apellidoPaternoResult: String = ""
    var apellidoMaternoResult: String = ""
    var cargoResult: String = ""
    var licenciaResult: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getResultTrabajador()
    }
    
    func getResultTrabajador(){
        dniLabel.text = dniResult
        nombreLabel.text = nombreResult
        apellidoPaternoLabel.text = apellidoPaternoResult
        apellidoMaternoLabel.text = apellidoMaternoResult
        cargoLabel.text = cargoResult
        licenciaLabel.text = licenciaResult
        
    }
    

}
