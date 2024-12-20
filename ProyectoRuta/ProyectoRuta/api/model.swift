//
//  model.swift
//  ProyectoRuta
//
//  Created by DAMII on 12/12/24.
//

import Foundation

//Campos del SERVICIO WEB DE LA API DE SOCIOS
// Modelo para los datos de un solo socio
struct Socio: Codable {
    let id: Int
    let first_name: String
    let last_name: String
    let email: String
    let avatar: String
}

// Modelo para la respuesta completa de la API (con paginación y datos de soporte)
struct APIResponse: Codable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [Socio]  // Lista de socios
    let support: Support // Información de soporte
}

// Modelo para la información de soporte
struct Support: Codable {
    let url: String
    let text: String
}
