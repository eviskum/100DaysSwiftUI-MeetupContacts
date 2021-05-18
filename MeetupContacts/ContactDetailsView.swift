//
//  ContactDetails.swift
//  MeetupContacts
//
//  Created by Esben Viskum on 17/05/2021.
//

import SwiftUI

struct ContactDetails: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var image: UIImage?
    @State private var name: String = ""
    @State private var showingPickerImage = false
    @Binding var contactList: Contacts
    var currentContact: Contact?
//    var contactIdx: Int?

    var body: some View {
        GeometryReader { geo in
            Form {
                VStack {
                    Image(uiImage: image ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .scaledToFit()
                        .padding()
//                            .frame(width: geo.size.width)
                        .onTapGesture {
                            self.showingPickerImage = true
                        }
                        .sheet(isPresented: $showingPickerImage) {
                            ImagePicker(image: self.$image)
                        }

                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("Name:")
                            TextField("Firstname Lastname", text: $name)
                        }
                    }
  
                    Button("Save") {
                        saveContact()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!inputValidated())
                    
                }
            }
            .navigationBarTitle("Add Contact")
//            .navigationBarTitle(currentContact != nil ? "Edit Contact" : "Add Contact")
            .onAppear() {
                if currentContact != nil {
                    image = currentContact!.contactPhoto
                    name = currentContact!.contactName ?? ""
                }
            }
        }
    }
}

extension ContactDetails {
    func  saveContact() {
        let newContact = Contact(contactName: self.name, contactPhoto: self.image!)
//        if contactIdx == nil {
            contactList.list.append(newContact)
            print("Add contact. Rows: \(contactList.list.count)")
//        } else {
//            contactList.list[contactIdx!] = newContact
//            print("Modify contact")
//        }
        contactList.list.sort()
    }
    
    func inputValidated() -> Bool {
        if name.isEmpty || image == nil { return false }
        return true
    }
}

