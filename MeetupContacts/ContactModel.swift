//
//  ContactModel.swift
//  MeetupContacts
//
//  Created by Esben Viskum on 17/05/2021.
//

import Foundation
import SwiftUI

class Contact: ObservableObject, Codable, Comparable {
    
    var contactID: UUID?
    @Published var contactName: String?
    @Published var contactPhoto: UIImage?
    
    var wrappedContactName: String {
        contactName ?? ""
    }
    
    enum CodingKeys: CodingKey {
        case contactID, contactName, contactPhoto
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(contactID, forKey: .contactID)
        try container.encode(contactName, forKey: .contactName)
        try container.encode(convertImageToBase64(contactPhoto!), forKey: .contactPhoto)
    }

    init() {}
    
    init(contactName: String, contactPhoto: UIImage) {
        self.contactID = UUID()
        self.contactName = contactName
        self.contactPhoto = contactPhoto
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contactID = try container.decode(UUID.self, forKey: .contactID)
        contactName = try container.decode(String.self, forKey: .contactName)
        let contactPhotoBase64 = try container.decode(String.self, forKey: .contactPhoto)
        self.contactPhoto = convertBase64ToImage(contactPhotoBase64)
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 1.0)!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//        print(strBase64)

        return strBase64
    }
    
    func convertBase64ToImage(_ imageBase64: String) -> UIImage {
//        print(imageBase64)
        let imageData = Data(base64Encoded: imageBase64, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: imageData)!
        print("Image decoded")
        
        return decodedimage
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.wrappedContactName == rhs.wrappedContactName
    }

    static func < (lhs: Contact, rhs: Contact) -> Bool {
        lhs.wrappedContactName < rhs.wrappedContactName
    }

}

class Contacts: ObservableObject, Codable {
    @Published var list = [Contact]()
    
    enum  CodingKeys: CodingKey {
        case list
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try container.decode([Contact].self, forKey: .list)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(list, forKey: .list)
    }
}
