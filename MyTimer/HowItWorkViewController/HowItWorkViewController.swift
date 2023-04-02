//
//  HowItWorkViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 30.03.2023.
//

import UIKit

class HowItWorkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Создаем UIScrollView
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isScrollEnabled = true // Включаем прокрутку
        view.addSubview(scrollView)
        
        let label1 = UILabel(frame: CGRect(x: 20, y: 20, width: view.bounds.width - 40, height: 100))
        label1.textAlignment = .center
        label1.text = "Как это устроено?"
        label1.font = UIFont.boldSystemFont(ofSize: 23)
        label1.numberOfLines = 1
        scrollView.addSubview(label1)
        
        // Создаем второй UILabel
        let label2 = UILabel(frame: CGRect(x: 20, y: 140, width: view.bounds.width - 40, height: 0))
        attributedText(label: label2)
        label2.numberOfLines = 0
        label2.textAlignment = .center
        label2.sizeToFit() // устанавливаем размер на основе размера текста
        
        scrollView.addSubview(label2)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: label1.frame.height + label2.frame.height + 160)
        
        
        
    }
        
        
        func attributedText(label: UILabel) {
            let stringActions = "1. Выбрать задачу\nВыберите задачу из списка дел,\nна которой вы хотите\nсосредоточиться.\n\n2. Запустить таймер\nКороткий промежуток времени в\n25 минут идеально подходит для\nтого,чтобы оставаться\nсосредоточенным\n\n3. Сосредоточьтесь на задаче\nПосле запуска зафиксируйте его.\nЭто поможет избежать\n отвлекающих факторов.\n\n4. Сделайте небольшой перерыв\nНаслаждайтесь коротким 5-\nминутным перерывом.Встаньте,\nвытяните ноги,попейте воды.\n\n5. Повторить 4 раза\n\n6. Сделайте долгий перерыв\nКаждый четвертый перерыв - это\nпродолжительный 30-минутный\nперерыв для восстановления сил."
            
            let attributedString = NSMutableAttributedString(string: stringActions)
            
            let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)]
            
            let boldWords = ["1. Выбрать задачу", "2. Запустить таймер", "3. Сосредоточьтесь на задаче", "4. Сделайте небольшой перерыв", "5. Повторить 4 раза", "6. Сделайте долгий перерыв"]
            
            for word in boldWords {
                let range = (stringActions as NSString).range(of: word)
                attributedString.addAttributes(boldFontAttribute, range: range)
            }
            
            label.attributedText = attributedString
        }
        
    }
