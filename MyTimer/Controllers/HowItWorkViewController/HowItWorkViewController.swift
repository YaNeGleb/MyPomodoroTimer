//
//  HowItWorkViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 30.03.2023.
//

import UIKit

class HowItWorkViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createScrollView()
        createTitleLable()
        createDescriptionLabel()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: titleLabel.frame.height + descriptionLabel.frame.height + 160)
    }
    
    // MARK: - Create Scroll

    func createScrollView() {
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
    }
    
    // MARK: - Create TitleLabel

    func createTitleLable() {
        titleLabel.frame = CGRect(x: 20, y: 20, width: view.bounds.width - 40, height: 100)
        titleLabel.textAlignment = .center
        titleLabel.text = "Как это устроено?"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        titleLabel.numberOfLines = 1
        scrollView.addSubview(titleLabel)
    }
    
    // MARK: - Create DescriptionLabel

    func createDescriptionLabel() {
        descriptionLabel.frame = CGRect(x: 20, y: 140, width: view.bounds.width - 40, height: 0)
        attributedText(for: descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.sizeToFit()
        scrollView.addSubview(descriptionLabel)
    }
    
    // MARK: - Update text for DescriptionLabel

    func attributedText(for label: UILabel) {
        let stringActions = "1. Выбрать задачу\nВыберите задачу из списка дел,\nна которой вы хотите\nсосредоточиться.\n\n2. Запустить таймер\nКороткий промежуток времени в\n25 минут идеально подходит для\nтого, чтобы оставаться\nсосредоточенным\n\n3. Сосредоточьтесь на задаче\nПосле запуска зафиксируйте его.\nЭто поможет избежать\nотвлекающих факторов.\n\n4. Сделайте небольшой перерыв\nНаслаждайтесь коротким 5-\nминутным перерывом. Встаньте,\nвытяните ноги, попейте воды.\n\n5. Повторить 4 раза\n\n6. Сделайте долгий перерыв\nКаждый четвертый перерыв - это\nпродолжительный 30-минутный\nперерыв для восстановления сил."
        
        let attributedString = NSMutableAttributedString(string: stringActions)
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 19)]
        
        let boldWords = ["1. Выбрать задачу", "2. Запустить таймер", "3. Сосредоточьтесь на задаче", "4. Сделайте небольшой перерыв", "5. Повторить 4 раза", "6. Сделайте долгий перерыв"]
        
        for word in boldWords {
            let range = (stringActions as NSString).range(of: word)
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
        label.attributedText = attributedString
    }
}
