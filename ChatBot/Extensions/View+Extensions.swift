//
//  View+Extensions.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/18.
//

import Foundation
import UIKit

extension UIView {
	func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
		let border = UIView()
		border.backgroundColor = color
		border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
		border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
		addSubview(border)
	}

	func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
		let border = UIView()
		border.backgroundColor = color
		border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
		border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
		addSubview(border)
	}

	func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
		let border = UIView()
		border.backgroundColor = color
		border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
		border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
		addSubview(border)
	}

	func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
		let border = UIView()
		border.backgroundColor = color
		border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
		border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
		addSubview(border)
	}
	
	func setAnchorPoint(_ point: CGPoint) {
		var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
		var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

		newPoint = newPoint.applying(transform)
		oldPoint = oldPoint.applying(transform)

		var position = layer.position

		position.x -= oldPoint.x
		position.x += newPoint.x

		position.y -= oldPoint.y
		position.y += newPoint.y

		layer.position = position
		layer.anchorPoint = point
	}
}
