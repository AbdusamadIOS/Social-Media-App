//
//  LoginView.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 15/01/24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseSharedSwift
import FirebaseStorage

struct LoginView: View {
    
    @State var emailId: String = ""
    @State var password: String = ""
    
    // MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    // MARK: UserDefaults
    @AppStorage("log_status") var logstatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("userUID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Lets Sing you in")
                .font(.largeTitle.bold())
                .hAligh(.leading)
            
                Text("Welcome Back, \nYou have been missed")
                .font(.title3)
                .hAligh(.leading)
            
            VStack(spacing: 12) {
                TextField("Email", text: $emailId)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    
                Button("Reset password?", action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAligh(.trailing)
                
                Button(action: loginUser) {
                    // MARK: Login Button
                    Text("Sing in")
                        .foregroundColor(.white)
                        .hAligh(.center)
                        .fillView(.black)
                    
                }
                .padding(.top, 20)
            }
            
            // MARK: Register Button
            HStack {
                Text("Don't have an account")
                    .foregroundColor(.gray)
                
                Button("Register Now") {
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
                
            }
            .font(.callout)
            .vAligh(.bottom)
        }
        .vAligh(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        
        // MARK: Register View VIA Sheets
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        // MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser() {
        isLoading = true
        closeKeyBoard()
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailId, password: password)
                print("User Found")
                try await fatchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    // MARK: If User if Found then Fetching User Data From Firestore
    func fatchUser()async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
       let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // MARK: UI Updating Must be Run On Main Thread
        await MainActor.run(body: {
            // Setting UserDefaults data and Changing App's Auth Status
            userUID = userID
            userNameStored = user.userName
            profileURL = user.userProfileURL
            logstatus = true
        })
    }
    
    func resetPassword() {
        
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailId)
                print("Link Sent")
            } catch {
                await setError(error)
            }
        }
    }
    
    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error) async {
        // MARK: UI Must be Update on main Theard
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

#Preview {
    LoginView()
}

