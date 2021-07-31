//
//  GoogleSignInManager.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/31.
//

import Foundation
import FirebaseAuth
import JGProgressHUD
import GoogleSignIn
import Firebase

class GoogleSignInManager {
    
    static let shared = GoogleSignInManager.init()
    
    func startSignInWithGoogleFlow() {
        
        let topVC = UIApplication.shared.windows.first?.visibleViewController
        let hud = JGProgressHUD()
        hud.textLabel.text = "Loading"
        hud.tintColor = .black
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: topVC!) { user, error in
            
            if let error = error {
                Log.error("구글 로그인 취소", error)
                return
            }
            
            hud.show(in: (topVC?.view)!, animated: true)
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    Log.error("Google sign in error", error)
                    return
                }
                // User is signed in
                UserDefaults.standard.set(true, forKey: "user")
                Log.info("구글 로그인 성공")
                hud.dismiss()
                topVC?.viewWillAppear(true)
            }
        }
    }
}
