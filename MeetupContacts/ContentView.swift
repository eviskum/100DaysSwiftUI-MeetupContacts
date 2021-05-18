//
//  ContentView.swift
//  MeetupContacts
//
//  Created by Esben Viskum on 17/05/2021.
//

import SwiftUI

func saveToDisk(data: Contacts) {
    FileManager.default.writeData(file: "ContactList3", data: data)
}

func readFromDisk() -> Contacts {
    var list: Contacts?
    list = FileManager.default.readData(file: "ContactList3")
    return list ?? Contacts()
}

struct ContentView: View {
    @EnvironmentObject private var contactList: Contacts
    @State private var inputImage: UIImage?
    @State private var showingAddContact = false
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(contactList.list, id:\.contactID) { contact in
                    NavigationLink(destination: ContactDetailsView(currentContact: contact)) {
                        Image(uiImage: contact.contactPhoto!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)

                        Text("\(contact.wrappedContactName)")
                    }
                }
                .onDelete(perform: deleteContacts)
            }
            .navigationBarTitle("Meetup Contacts")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingAddContact.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            })
            .sheet(isPresented: $showingAddContact, content: {
                AddEditContactView()
            })

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    func deleteContacts(at offsets: IndexSet) {
        contactList.list.remove(atOffsets: offsets)
        saveToDisk(data: contactList)
    }
}
