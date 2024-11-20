//
//  PaseUsuarioViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 20/11/24.
//

import UIKit

class PaseUsuarioViewController: UIViewController {
    
    
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var contraseniaLabel: UILabel!
    
    //Variables
    var correoResult: String = ""
    var contraseniaResult: String = ""
    
    //Carga de memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        getResultUser()
    }
    
    //Funcion para mostrar resultado
    func getResultUser(){
        correoLabel.text = correoResult
        contraseniaLabel.text = contraseniaResult
    }
    

}
