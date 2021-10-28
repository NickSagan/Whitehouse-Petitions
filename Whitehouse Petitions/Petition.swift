//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Nick Sagan on 28.10.2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
