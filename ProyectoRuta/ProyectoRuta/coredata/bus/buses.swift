//
//  Bus.swift
//  ProyectoRuta
//
//  Created by DAMII on 19/12/24.
//

import Foundation
import FirebaseFirestore

struct buses {
    var placa: String
    var modelo: String
    var marca: String
    var anioFabricacion: String
    var estado: String

    // Inicializador desde un documento de Firebase
    init(document: QueryDocumentSnapshot) {
        let data = document.data()
        self.placa = data["placa"] as? String ?? ""
        self.modelo = data["modelo"] as? String ?? ""
        self.marca = data["marca"] as? String ?? ""
        self.anioFabricacion = data["anioFabricacion"] as? String ?? ""
        self.estado = data["estado"] as? String ?? ""
    }
}
