//
//  StepperTableViewCell.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 24.03.2023.
//

import UIKit

    // Протокол делегата для уведомления о переключении UISwitch в ячейке таблицы
    protocol CustomCellDelegate {
        func switchValueChanged(isOn: Bool, indexPath: IndexPath)
    }

    class SwitchTableViewCell: UITableViewCell {
        
        static let identifier = "SwitchTableViewCell"
        
        // Контейнер для иконки
        let iconContainer: UIView = {
            let view = UIView()
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            return view
        }()
        
        // Иконка
        private let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        // Надпись
        private let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            return label
        }()
        
        // Переключатель
        let mySwitch: UISwitch = {
            let switchLocal = UISwitch()
            switchLocal.onTintColor = .darkGray
            return switchLocal
        }()
        
        // Делегат ячейки
        var delegate: CustomCellDelegate?
        // Индекс ячейки
        var indexPath: IndexPath?
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(label)
            contentView.addSubview(iconContainer)
            contentView.addSubview(mySwitch)
            iconContainer.addSubview(iconImageView)
            
            mySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            
            contentView.clipsToBounds = true
            accessoryType = .none
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        // Размещение внутренних элементов ячейки
        override func layoutSubviews() {
            super.layoutSubviews()
            let size: CGFloat = contentView.frame.size.height - 12
            iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
            
            let imageSize: CGFloat = size/1.5
            iconImageView.frame = CGRect(x: (size - imageSize)/2, y: (size - imageSize) / 2, width: imageSize, height: imageSize)
            
            mySwitch.sizeToFit()
            mySwitch.frame = CGRect(x: contentView.frame.size.width - mySwitch.frame.size.width - 20, y: (contentView.frame.size.height - mySwitch.frame.size.height)/2 , width: mySwitch.frame.size.width, height: mySwitch.frame.size.height)
            
            label.frame = CGRect(x: 40 + iconContainer.frame.size.width,
                                 y: 0,
                                 width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
                                 height: contentView.frame.size.height)
            
        }
        
        // Очистка ячейки перед повторным использованием
        override func prepareForReuse() {
            super.prepareForReuse()
            iconImageView.image = nil
            label.text = nil
            iconContainer.backgroundColor = nil
        }
        
        // Конфигурирование ячейки
        public func configure(with model: SettingsSwitchOption) {
            label.text = model.title
            iconImageView.image = model.icon
            iconContainer.backgroundColor = model.iconBackgroundColor
            mySwitch.isOn = model.isOn
            
        }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchValueChanged(isOn: mySwitch.isOn, indexPath: indexPath!)
        }

    }


   

