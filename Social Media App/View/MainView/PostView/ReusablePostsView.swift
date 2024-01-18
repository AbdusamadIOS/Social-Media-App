//
//  ReusablePostsView.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 17/01/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ReusablePostsView: View {
    var basedOutID: Bool = false
    var uid: String = ""
    @Binding var posts: [Post]
    // View Properties
    @State private var isFatching: Bool = true
    // Pagination
    @State private var paginationDoc: QueryDocumentSnapshot?
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if isFatching {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if posts.isEmpty {
                        // No Post's Found on FireStory
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        // Displaying Post's
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            // Scroll to refresh
            // Disbaling Refresh for UID based Post's
            guard !basedOutID else { return }
            isFatching = true
            posts = []
            // Resetting Pagination Doc
            paginationDoc = nil
            await fetchPosts()
        }
        .task {
            // Fetching for one time
            guard posts.isEmpty else { return }
            await fetchPosts()
        }
    }
    // Displaying Fetched Post's
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts) { post in
            PostCardView(post: post) { updatePost in
                // Updating Post in the array
                if let index = posts.firstIndex(where: { post in
                    post.id == updatePost.id
                }) {
                    posts[index].likedIDs = updatePost.likedIDs
                    posts[index].dislikedIDs = updatePost.dislikedIDs
                }
            } onDelete: {
                // Removing Post from the array
                withAnimation(.easeInOut(duration: 0.25)) {
                    posts.removeAll{post.id == $0.id}
                    
                }
            }
            .onAppear {
                // when last post Appears Fetch new post (if there)
                if post.id == posts.last?.id && paginationDoc != nil {
                    Task {await fetchPosts()}
                }
            }
            Divider()
                .padding(.horizontal, -15)
        }
    }
    // Fetching Posts
    func fetchPosts() async {
        do {
            var query: Query!
                // Implementing Pagination
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            // - New Query For UID Based Document Fetch
            //Simply Filter the Post's Which is not belongs to this UID
            if basedOutID {
                query = query
                    .whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFatching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
