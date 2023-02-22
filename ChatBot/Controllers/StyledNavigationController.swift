//
//  StyledNavigationController.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/18.
//

import UIKit

class StyledNavigationController: UINavigationController {

	private func changeBackgroundColor() {
		let appearance = UINavigationBarAppearance()
		appearance.backgroundColor = .iosDefault
//		appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//		appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
//		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().compactAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}
	
	private func changeTintColor(_ color: UIColor) {
		navigationBar.tintColor = color
	}
	
	private func changeNavigationTitleStyle(color: UIColor, font: UIFont) {
		var textAttributes = navigationBar.standardAppearance.titleTextAttributes
		textAttributes[.foregroundColor] = color
		textAttributes[.font] = font
		navigationBar.titleTextAttributes = textAttributes
	}
	
	private func changeNavigationItemAndTitleStyle(color: UIColor, font: UIFont) {
		let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
		let appearance = navigationBar.standardAppearance
		//		let appearance = UINavigationBarAppearance()
		appearance.buttonAppearance.normal.titleTextAttributes = attributes
		appearance.titleTextAttributes = attributes
		self.navigationBar.standardAppearance = appearance
	}
	
	private func setupAppearance() {
		changeBackgroundColor()
//		navigationBar.addBottomBorder(with: .separator, andWidth: 0.3)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupAppearance()
	}
}
