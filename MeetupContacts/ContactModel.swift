//
//  ContactModel.swift
//  MeetupContacts
//
//  Created by Esben Viskum on 17/05/2021.
//

import Foundation
import SwiftUI

class Contact: ObservableObject, Codable, Comparable {
    
    var contactName: String?
    var contactPhoto: UIImage?
    
    var wrappedContactName: String {
        contactName ?? ""
    }
    
    enum CodingKeys: CodingKey {
        case contactName, contactPhoto
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(contactName, forKey: .contactName)
        try container.encode(convertImageToBase64(contactPhoto!), forKey: .contactPhoto)
    }

    init() {}
//    init(contactName: String, contactPhoto: UIImage) {
//        self.contactName = contactName
//        self.contactPhoto = contactPhoto
//    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contactName = try container.decode(String.self, forKey: .contactName)
        let contactPhotoBase64 = try container.decode(String.self, forKey: .contactPhoto)
        self.contactPhoto = convertBase64ToImage(contactPhotoBase64)
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData: NSData = image.jpegData(compressionQuality: 0.8)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

        return strBase64
    }
    
    func convertBase64ToImage(_ imageBase64: String) -> UIImage {
        let dataDecoded: NSData  = NSData(base64Encoded: imageBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!

        return decodedimage
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.wrappedContactName == rhs.wrappedContactName
    }

    static func < (lhs: Contact, rhs: Contact) -> Bool {
        lhs.wrappedContactName < rhs.wrappedContactName
    }

}

struct Contacts: Codable {
    var list = [Contact]()
    
}
