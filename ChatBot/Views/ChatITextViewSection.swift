//
//  ChatITextField.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/19.
//

import UIKit
import SnapKit

class ChatTextViewSection: UIView {
	
	let container: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .equalSpacing
		stackView.alignment = .bottom
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()
	
	let chatTextViewContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.clipsToBounds = true
		view.layer.cornerRadius = 16
		
		return view
	}()
	
	let chatTextView: UITextView = {
		let textView = UITextView()
		textView.text = "Messages"
		textView.textColor = .placeholderText
		textView.isScrollEnabled = false
		return textView
	}()
	
	let sendButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .systemBlue
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium, scale: .default)
		button.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: imageConfig), for: .normal)
		button.tintColor = .white
		button.clipsToBounds = true
		button.layer.cornerRadius = 16
		button.isHidden = true
		return button
	}()
	
	override init(frame: CGRect) {
		super .init(frame: frame)
		backgroundColor = .iosDefault
		addTopBorder(with: .separator, andWidth: 0.3)
		
		configureContentHuggingPriority()
		addSubviews()
		setupLayout()
	}
	
	func configureContentHuggingPriority() {
		container.setContentHuggingPriority(.defaultLow, for: .vertical)
		chatTextViewContainer.setContentHuggingPriority(.defaultLow, for: .vertical)
		chatTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
		self.setContentHuggingPriority(.defaultLow, for: .vertical)
	}
	
	private func addSubviews() {
		addSubview(container)
		container.addArrangedSubview(chatTextViewContainer)
		container.addArrangedSubview(sendButton)
		
		chatTextViewContainer.addSubview(chatTextView)
	}
	
	private func setupLayout() {
		container.snp.makeConstraints{ make in
			make.top.equalToSuperview().offset(8)
			make.left.equalToSuperview().offset(16)
			make.bottom.equalToSuperview().offset(-8)
			make.right.equalToSuperview().offset(-16)
		}
		
		chatTextViewContainer.snp.makeConstraints{ make in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.width.greaterThanOrEqualToSuperview().multipliedBy(0.88)
		}
		
		chatTextView.snp.makeConstraints{ make in
			
			make.right.equalToSuperview().offset(-8)
			make.left.equalToSuperview().offset(8)
			make.height.equalToSuperview()
		}
		
		sendButton.snp.makeConstraints{ make in
//			make.height.equalToSuperview()
//			make.width.equalTo(sendButton.snp.height)
			make.height.equalTo(32)
			make.width.equalTo(32)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
