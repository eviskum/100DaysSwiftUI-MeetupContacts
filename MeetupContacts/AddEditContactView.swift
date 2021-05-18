//
//  AddEditContactView.swift
//  MeetupContacts
//
//  Created by Esben Viskum on 18/05/2021.
//

import SwiftUI

struct AddEditContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var image: UIImage?
    @State private var name: String = ""
    @State private var showingPickerImage = false
    @EnvironmentObject private var contactList: Contacts
    var currentContact: Contact?

    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Image(uiImage: image ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .scaledToFit()
                        .padding()
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
            .navigationBarTitle(currentContact != nil ? "Edit Contact" : "Add Contact")
            .onAppear() {
                if currentContact != nil {
                    image = currentContact!.contactPhoto
                    name = currentContact!.contactName ?? ""
                }
            }
        }
    }
}

extension AddEditContactView {
    func  saveContact() {
        if currentContact == nil {
            let newContact = Contact(contactName: self.name, contactPhoto: self.image!)
            contactList.list.append(newContact)
        } else {
            currentContact?.contactName = self.name
            currentContact?.contactPhoto = self.image!
        }
        contactList.list.sort()
        saveToDisk(data: contactList)
    }
    
    func inputValidated() -> Bool {
        if name.isEmpty || image == nil { return false }
        return true
    }
}
