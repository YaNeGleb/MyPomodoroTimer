//
//  SelectTimeViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 24.03.2023.
//

import UIKit

class FocusTimeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var value: String?
    // Значения времени для таблицы
    var values = ["1 минута", "2 минуты", "15 минут", "20 минут", "25 минут", "30 минут", "45 минут", "50 минут", "60 минут"]
    // Делегат таймера
    var delegate: TimerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Focus"
        
        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

// Расширение, которое реализует протоколы UITableViewDelegate и UITableViewDataSource
extension FocusTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Установка текста ячейки
        cell.textLabel?.text = values[indexPath.row]
        
        // Установка accessory type для выбранной ячейки
        if indexPath.row == UserDefaults.standard.integer(forKey: "focusMark") {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Получаем выбранную ячейку
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        // Получаем данные из ячейки
        let selectedValue = values[indexPath.row]
        let components = selectedValue.split(separator: " ")
        let result = String(components[0])
        
        //Передаем данные в TimerViewContoller
        if let delegate = delegate {
            delegate.setStaticTimeForTimer(value: result)
        }
        
        // Устанавливаем accessory type для выбранной ячейки
        selectedCell?.accessoryType = .checkmark
        
        // Сохраняем значение в UserDefaults
        UserDefaults.standard.set(indexPath.row, forKey: "focusMark")
        UserDefaults.standard.set(result, forKey: "selectedValue")
        
        // Убираем accessory type у остальных ячеек
        for cell in tableView.visibleCells {
            if cell != selectedCell {
                cell.accessoryType = .none
            }
        }
        
        // Pop back to root view controller
        navigationController?.popToRootViewController(animated: true)
    }
}



