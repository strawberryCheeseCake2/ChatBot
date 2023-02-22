//
//  SettingsViewController.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/19.
//

import UIKit
import FirebaseAuth
import SnapKit
class SettingsViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		let button = UIButton()
		button.setTitle("Sign Out", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.addTarget(self, action: #selector(onSignOutPressed), for: .touchUpInside)
		view.addSubview(button)

		button.snp.makeConstraints{
			$0.center.equalToSuperview()
		}
	}
	
	@objc
	func onSignOutPressed() {
		print("pressed")
		do {
			try Auth.auth().signOut()
			(
				UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
			)?.showVC(loggedIn: false)
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
		}
		
	}
	
	/*
	 // MARK: - Navigation
	 
	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	 // Get the new view controller using segue.destination.
	 // Pass the selected object to the new view controller.
	 }
	 */
	
}
