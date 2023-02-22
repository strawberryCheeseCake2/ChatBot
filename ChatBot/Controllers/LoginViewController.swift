//
//  LoginViewController.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/19.
//

import UIKit
import SnapKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
	let googleSignInButton = GIDSignInButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.addSubview(googleSignInButton)
		
		googleSignInButton.addTarget(self, action: #selector(handleGoogleSignInButtonPressed), for: .touchUpInside)
		setupLayout()
	}
	
	@objc
	func handleGoogleSignInButtonPressed() {
		
		GIDSignIn.sharedInstance.signIn(withPresenting: self) { response, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			
			guard let auth = response?.user, let idToken = response?.user.idToken else {
				return
			}
			
			
			
			let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: auth.accessToken.tokenString)
			
			Auth.auth().signIn(with: credential) { response, error in
				guard error == nil else {
					print(error!)
					return
				}
				
				(
					UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
				)?.showVC(loggedIn: true)
			}
			
		} // GIDSignIn.sharedInstance.signIn
		
	}
	
	private func setupLayout() {
		googleSignInButton.snp.makeConstraints{ make in
			make.center.equalToSuperview()
		}
	}
	
}
