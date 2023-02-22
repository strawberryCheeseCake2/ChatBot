//
//  StyledTabBarController.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/18.
//

import UIKit

class StyledTabBarController: UITabBarController {
	// init to configure tabbar height with custom tabbar
//	init() {
//		   super.init(nibName: nil, bundle: nil)
//		   object_setClass(self.tabBar, CustomTabBar.self)
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
	
	private func preventBeingWhiteWhenScrolling() {
		let appearance = tabBar.standardAppearance
		appearance.configureWithOpaqueBackground()
		
//		appearance.shadowColor = .clear //removing navigationbar 1 px bottom border.
		appearance.backgroundColor = .iosDefault
		UITabBar.appearance().standardAppearance = appearance
		UITabBar.appearance().scrollEdgeAppearance = appearance
	}
	
	private func changeTintColor(selected: UIColor, unselected: UIColor) {
		self.tabBar.tintColor = selected
		self.tabBar.unselectedItemTintColor = unselected
	}
	
	
	private func setupAppearance() {
		changeTintColor(selected: .systemBlue, unselected: .systemBackground)
		
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupAppearance()
		preventBeingWhiteWhenScrolling()
		tabBar.backgroundColor = .iosDefault
		// Do any additional setup after loading the view.
	}
	

}


class CustomTabBar : UITabBar {
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		super.sizeThatFits(size)
		var sizeThatFits = super.sizeThatFits(size)
		sizeThatFits.height = 90
		return sizeThatFits
	}
}
