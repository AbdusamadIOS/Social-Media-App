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
    @Binding var posts: [Post]
    // View Properties
    @State var isFatching: Bool = true
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
            isFatching = true
            posts = []
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
            Divider()
                .padding(.horizontal, -15)
        }
    }
    // Fetching Posts
    func fetchPosts() async {
        do {
            var query: Query!
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
                .limit(to: 20)
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in 
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts = fetchedPosts
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
