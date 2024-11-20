//
//  RegistroTrabajadorViewController.swift
//  ProyectoRuta
//
//  Created by DISEÑO on 20/11/24.
//

import UIKit

class RegistroTrabajadorViewController: UIViewController {
    
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoPaternoTextField: UITextField!
    @IBOutlet weak var apellidoMaternoTextField: UITextField!
    @IBOutlet weak var cargoTextField: UITextField!
    @IBOutlet weak var licenciaTextField: UITextField!
    
    var dni = ""
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
    var cargo = ""
    var licencia = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getData(){
        dni = dniTextField.text ?? ""
        nombre = nombreTextField.text ?? ""
        apellidoPaterno = apellidoPaternoTextField.text ?? ""
        apellidoMaterno = apellidoMaternoTextField.text ?? ""
        cargo = cargoTextField.text ?? ""
        licencia = licenciaTextField.text ?? ""
        goToResultScreen()
    }
    
    func goToResultScreen(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PaseTrabajadorViewController") as? PaseTrabajadorViewController
        viewController?.dniResult = dni
        viewController?.nombreResult = nombre
        viewController?.apellidoPaternoResult = apellidoPaterno
        viewController?.apellidoMaternoResult = apellidoMaterno
        viewController?.cargoResult = cargo
        viewController?.licenciaResult = licencia
        self.present(viewController ?? ViewController(), animated: true, completion: nil)
    }
    
    
    @IBAction func didTapRegistrar(_ sender: UIButton) {
        getData()
    }
    
}
