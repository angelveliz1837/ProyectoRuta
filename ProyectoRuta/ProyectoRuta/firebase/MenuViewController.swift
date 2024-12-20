//
//  MenuViewController.swift
//  ProyectoRuta
//
//  Created by DAMII on 27/11/24.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //funcion para obtener al usuario con una sesion abierta
    func getUser(){
        let _ = Auth.auth().currentUser?.email //libreria para hacer el llamado si hay una sesion abierta
    }
    
    
    func logOut(){
        try? Auth.auth().signOut() //llamar a la libreria para hacer el logOut
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapCerrar(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        logOut()
    }
}
