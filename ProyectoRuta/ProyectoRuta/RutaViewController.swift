//
//  RutaViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit

class RutaViewController: UIViewController {
    
    @IBOutlet weak var horaDatePicker: UIDatePicker!
    @IBOutlet weak var observacionTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var resultObservacionTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    

    @IBOutlet weak var resultadohoraDatePicker: UIDatePicker!
    
    var hora: Date = Date()
    var observacion: String = ""
    var resulthora: Date = Date()
    var resultobservacion: String = ""
    
    
    override func viewDidLoad() {
        updateButton.isEnabled = false
        super.viewDidLoad()
    }
    
    func enviar(){
        hora = horaDatePicker.date
        observacion = observacionTextField.text ?? ""
        resultadohoraDatePicker.date = hora
        resultObservacionTextView.text = observacion
    }
    
    
    @IBAction func didTapEnviar(_ sender: UIButton) {
        enviar()
        enviarButton.isEnabled = false
        horaDatePicker.isUserInteractionEnabled = false
        observacionTextField.isUserInteractionEnabled = false
        updateButton.isEnabled = true
    }
    
    @IBAction func didTapActualizar(_ sender: UIButton) {
        horaDatePicker.isUserInteractionEnabled = false
        observacionTextField.isUserInteractionEnabled = false
        resulthora = resultadohoraDatePicker.date
        resultobservacion = resultObservacionTextView.text ?? ""
        horaDatePicker.date = resulthora
        observacionTextField.text = resultobservacion
    }
    
}
