//
//  ChatRoomTableViewCell.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/18.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
	static let id = "ChatRommTableViewCell"
	
	private let colors: [UIColor] = [.iosDefault!, .systemBlue, .systemTeal, .purple]
	
	let container: UIStackView = {
		let stackView = UIStackView()
		stackView.backgroundColor = .clear
		stackView.alignment = .leading
		stackView.distribution = .fill
		stackView.axis = .horizontal
		stackView.spacing = 16
		stackView.setContentHuggingPriority(.required, for: .horizontal)
		return stackView
	}()
	
	lazy var profileImage: UIView = {
		let view = UIView()
		view.backgroundColor = .systemFill
		view.clipsToBounds = true
		view.layer.cornerRadius = 30

		return view
	}()
	
	let profileImageLabel: UILabel = {
		let label = UILabel()
		label.text = "Bot"
		label.textColor = .white
		label.font = .systemFont(ofSize: 16, weight: .medium)
		return label
	}()
	
	let vStack: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		stackView.backgroundColor = .clear
		stackView.setContentHuggingPriority(.required, for: .vertical)
		return stackView
	}()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Default Username"
		label.textColor = .black
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		return label
	}()
	
	let latestChatLabel: UILabel = {
		let label = UILabel()
		label.text = "Default Latest Chat"
		label.textColor = .gray
		label.font = .systemFont(ofSize: 16, weight: .medium)
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super .init(style: style, reuseIdentifier: reuseIdentifier)
//		backgroundColor = .systemTeal
		addBottomBorder(with: .separator, andWidth: 0.3)
		addSubviews()
		setupLayout()
	}
	
	func configureContents(username: String, latestChat: String) {
		usernameLabel.text = username
		latestChatLabel.text = latestChat
		profileImageLabel.text = String(username.prefix(1))
//		profileImage.backgroundColor = colors.randomElement()
	}
	
	private func addSubviews() {
		addSubview(container)
		container.addArrangedSubview(profileImage)
		container.addArrangedSubview(vStack)
		
		vStack.addArrangedSubview(usernameLabel)
		vStack.addArrangedSubview(latestChatLabel)
		
		profileImage.addSubview(profileImageLabel)
	}
	
	private func setupLayout() {
		container.snp.makeConstraints{ make in
			make.top.equalToSuperview().offset(16)
			make.left.equalToSuperview().offset(16)
//			make.right.equalToSuperview().offset(-16)
			make.bottom.equalToSuperview().offset(-16)
		}
		

		
		vStack.snp.makeConstraints{ make in
//			make.height.equalToSuperview()
		}
		
		profileImage.snp.makeConstraints{ make in
			make.height.equalToSuperview()
			make.width.equalTo(profileImage.snp.height)
			make.left.equalToSuperview()
		}
		
		profileImageLabel.snp.makeConstraints{ make in
			make.center.equalToSuperview()
		}
		
		latestChatLabel.snp.makeConstraints { make in
			make.width.lessThanOrEqualTo(250)
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
