//
//  InformationViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 29.03.2023.
//

import UIKit

class InformationViewController: UIViewController {
    
    private let scrollView = UIScrollView()
        private let imageView = UIImageView()
        private let infoLabel = UILabel()
        private let projectNameLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isScrollEnabled = true // Включаем прокрутку
        view.addSubview(scrollView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = CGPoint(x: scrollView.bounds.width / 2, y: imageView.bounds.height / 2)
        scrollView.addSubview(imageView)

        
        projectNameLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + 10, width: scrollView.frame.width, height: 50)
        projectNameLabel.textAlignment = .center
        projectNameLabel.text = "MyTimer"
        projectNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        scrollView.addSubview(projectNameLabel)


        infoLabel.frame = CGRect(x: 20, y: projectNameLabel.frame.maxY + 10, width: scrollView.frame.width - 40, height: 0)
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 19)
        infoLabel.text = "      MyTimer - это совсем небольшое, но эффективное приложение, которое поможет вам справиться с задачами, подготовиться к школе или просто сохранять концентрацию, не отвлекаясь в течение определенного времени. MyTimer делит ваш рабочий процесс на части с определенными перерывами, тем самым позволяя вам легко сохранять концентрацию. Научно доказано, что этот метод эффективен для повышения концентрации и мотивации, а также для снижения уровня стресса. Использование таймера Помодоро может значительно повысить вашу производительность.\n\nПреимущества этой техники\n• Повышение концентрации и мотивации\n• Повышение продуктивности\n• Меньше стресса и больше здоровья\n• Снижение отвлекающих факторов"
        infoLabel.sizeToFit()
        infoLabel.frame.origin.y = projectNameLabel.frame.maxY + 10
        scrollView.addSubview(infoLabel)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoLabel.frame.maxY + 10)


        if let url = URL(string: "https://picsum.photos/id/1003/400/300") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        imageView.image = image
                        imageView.contentMode = .scaleToFill
                        imageView.layer.cornerRadius = 50
                        imageView.layer.masksToBounds = true
                    }
                }
            }
            task.resume()
        }
    }
}
    
