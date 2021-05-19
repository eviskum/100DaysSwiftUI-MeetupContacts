//
//  ContactDetails.swift
//  MeetupContacts
//
//  Created by Esben Viskum on 17/05/2021.
//

import SwiftUI
import MapKit


struct MainView: View {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
//    @Binding var showingEditScreen: Bool
    

    var body: some View {
        MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
            .edgesIgnoringSafeArea(.all)
        
    }
}


struct ContactDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditContact = false
    @EnvironmentObject private var contactList: Contacts
    var currentContact: Contact?
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false

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
            
            if currentContact!.contactLocation != nil {
                MainView(centerCoordinate: $centerCoordinate, locations: $locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails)
                    .frame(width: 300, height: 300, alignment: .center)
            }

            Button("Edit") {
                self.showingEditContact = true
            }
        }
        .navigationBarTitle("Contact Details")
        .sheet(isPresented: $showingEditContact, content: {
            AddEditContactView(currentContact: currentContact)
        })
        .onAppear(perform: {
            if currentContact!.contactLocation != nil {
                locations.removeAll()
                locations.append(currentContact!.contactLocation!)
            }
        })
    }
}

struct ContactDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailsView(currentContact: Contact(contactName: "Anders And", contactPhoto: UIImage(systemName: "star")!, contactLocation: nil))
            .environmentObject(Contacts())
    }
}
