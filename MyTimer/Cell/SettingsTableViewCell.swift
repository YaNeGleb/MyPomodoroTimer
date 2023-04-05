//
//  SettingsTableViewCell.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 24.03.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "SettingsTableViewCell"

    let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.numberOfLines = 1
        return timeLabel
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)

        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)

        let imageSize: CGFloat = size/1.5
        iconImageView.frame = CGRect(x: (size - imageSize)/2, y: (size - imageSize)/2, width: imageSize, height: imageSize)

        label.frame = CGRect(x: 25 + iconContainer.frame.size.width, y: 0, width: contentView.frame.size.width - 20 - iconContainer.frame.size.width, height: contentView.frame.size.height)
        timeLabel.frame = CGRect(x: contentView.frame.size.width - 70, y: 0, width: contentView.frame.size.width - 20 - iconContainer.frame.size.width, height: contentView.frame.size.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.image = nil
        label.text = nil
        timeLabel.text = nil
        iconContainer.backgroundColor = nil
    }

    public func configure(with model: SettingsOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
    }
}
