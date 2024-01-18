//
//  ReusableProfilContent.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 16/01/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfilContent: View {
    var user: User
    @State private var fatchedPosts: [Post] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators: false ) {
            LazyVStack {
                HStack(spacing: 12) {
                    WebImage(url: user.userProfileURL).placeholder() {
                        // MARK: Placeholder Image
                        Image("nullProfil")
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.userName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(3)
                        // MARK: Displaying Bio Link, If Given While Singning Up Profile Page
                        if let bioLink = URL(string: user.userBioLink) {
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .tint(.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAligh(.leading)
                }
                
                Text("Posts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .hAligh(.leading)
                    .padding(.vertical, 15)
                
                ReusablePostsView(basedOutID: true, uid: user.userUID, posts: $fatchedPosts)
            }
            .padding(15)
        }
    }
}

//#Preview {
//    ReusableProfilContent()
//}
