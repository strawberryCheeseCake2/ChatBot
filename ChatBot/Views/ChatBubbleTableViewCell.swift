//
//  ChatBubbleCellView.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/19.
//

import UIKit

class ChatBubbleTableViewCell: UITableViewCell {
	static let id = "ChatBubbleTableViewCell"
	
	let container: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .fill
		stackView.alignment = .center
		stackView.backgroundColor = .clear
		stackView.setContentHuggingPriority(.required, for: .vertical)
		return stackView
	}()
	
	let chatLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.text = "TEXTasdsdfTEXTasdfasdfasdfasdfTEXTasdfasdfasdfasdfTEXTasdfasdfasdfasdf"
		label.font = .systemFont(ofSize: 16)
		label.numberOfLines = 0
		return label
	}()
	
	let leftSpacer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	let rightSpacer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	let bubbleContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .systemBlue
		view.clipsToBounds = true
		view.layer.cornerRadius = 12
		
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentHuggingPriority(.required, for: .vertical)
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super .init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clear
		
		
		addSubviews()
		setupLayout()
		
	}
	
	private func addSubviews() {
		addSubview(container)
		
		container.addArrangedSubview(leftSpacer)
		container.addArrangedSubview(bubbleContainer)
		container.addArrangedSubview(rightSpacer)
		
		bubbleContainer.addSubview(chatLabel)
	}
	
	private func setupLayout() {
		container.snp.makeConstraints{ make in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.left.equalToSuperview().offset(16)
			make.right.equalToSuperview().offset(-16)
		}
		
		leftSpacer.snp.makeConstraints{ make in
			make.height.equalToSuperview()
//			make.width.greaterThanOrEqualToSuperview().multipliedBy(0.2)
		}
		
		rightSpacer.snp.makeConstraints{ make in
			make.height.equalToSuperview()
//			make.width.greaterThanOrEqualToSuperview().multipliedBy(0.2)
		}
		bubbleContainer.snp.makeConstraints{ make in
			make.top.equalToSuperview().offset(2)
			make.bottom.equalToSuperview().offset(-2)
			make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
		}
		
		chatLabel.snp.makeConstraints{ make in
			make.top.equalToSuperview().offset(4)
			make.bottom.equalToSuperview().offset(-4)
			make.left.equalToSuperview().offset(8)
			make.right.equalToSuperview().offset(-8)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}

