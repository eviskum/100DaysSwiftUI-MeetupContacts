//
//  ContactDetails.swift
//  MeetupContacts
//
//  Created by Esben Viskum on 17/05/2021.
//

import SwiftUI

struct ContactDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditContact = false
    @EnvironmentObject private var contactList: Contacts
    var currentContact: Contact?

    var body: some View {
        VStack() {
            Image(uiImage: currentContact!.contactPhoto!)
                .resizable()
                .scaledToFit()
                .padding()
                
            HStack {
                VStack(alignment: .leading, spacing: 0.0) {
                    Text("Name:")
                    Text(currentContact!.contactName ?? "")
                }
                .padding()
                
                Spacer()
            }

            Button("Edit") {
                self.showingEditContact = true
            }
        }
        .navigationBarTitle("Contact Details")
        .sheet(isPresented: $showingEditContact, content: {
            AddEditContactView(currentContact: currentContact)
        })
    }
}

struct ContactDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailsView(currentContact: Contact(contactName: "Anders And", contactPhoto: UIImage(systemName: "star")!))
            .environmentObject(Contacts())
    }
}
