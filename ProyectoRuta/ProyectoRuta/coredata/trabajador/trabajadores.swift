//
//  Trabajador.swift
//  ProyectoRuta
//
//  Created by DAMII on 19/12/24.
//
import Foundation
import FirebaseFirestore

struct trabajadores {
    var dni: String
    var nombre: String
    var apellidoPaterno: String
    var apellidoMaterno: String
    var cargo: String
    var licencia: String

    // Inicializador desde un documento de Firebase
    init(document: QueryDocumentSnapshot) {
        let data = document.data()
        self.dni = data["dni"] as? String ?? ""
        self.nombre = data["nombre"] as? String ?? ""
        self.apellidoPaterno = data["apellidoPaterno"] as? String ?? ""
        self.apellidoMaterno = data["apellidoMaterno"] as? String ?? ""
        self.cargo = data["cargo"] as? String ?? ""
        self.licencia = data["licencia"] as? String ?? ""
    }
}
