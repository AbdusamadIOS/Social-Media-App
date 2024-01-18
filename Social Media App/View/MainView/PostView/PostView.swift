//
//  PostView.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 17/01/24.
//

import SwiftUI

struct PostView: View {
    @State private var recentsPosts: [Post] = []
    @State private var createNewPost: Bool = false
    var body: some View {
        NavigationStack {
            ReusablePostsView(posts: $recentsPosts)
                .hAligh(.center).vAligh(.center)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        createNewPost.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(.black, in: Circle())
                    }
                    .padding(15)
                }
                .navigationTitle("Post's")
            }
            .fullScreenCover(isPresented: $createNewPost) {
                CreateNewPost { post in
                    // Adding Created post at the Top of the Recent Posts
                    recentsPosts.insert(post, at: 0)
            }
        }
    }
}

#Preview {
    PostView()
}
