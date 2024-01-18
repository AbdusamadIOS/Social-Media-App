//
//  SearchUserView.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 18/01/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct SearchUserView: View {
    // View Properties
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(fetchedUsers) { user in
                NavigationLink {
                    ReusableProfilContent(user: user)
                } label: {
                    Text(user.userName)
                        .font(.callout)
                        .hAligh(.leading)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search User")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            // Fetch User from Firebase
            Task {await searchUser()}
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fetchedUsers = []
            }
        })
    }
    func searchUser() async {
        do {
           let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            // UI Must be Updated on Main Thread
            await MainActor.run(body: {
                fetchedUsers = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    SearchUserView()
}
