//
//  BreakViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 27.03.2023.
//

import UIKit

class BreakViewController: UIViewController {
    
    // Связь с интерфейсом
    @IBOutlet weak var tableView: UITableView!
    
    // Значение выбранного времени перерыва
    var value: String?
    
    // Доступные варианты времени для перерыва
    var values = ["1 минутa","5 минут", "10 минут"]
    
    // Связь с контроллером таймера
    var delegate: TimerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Устанавливаем заголовок для экрана
        title = "Break"
        
        // Настраиваем таблицу
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension BreakViewController: UITableViewDelegate, UITableViewDataSource {
        
    // Количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        values.count
    }
    
    // Конфигурация ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = values[indexPath.row]
        
        // Устанавливаем галочку для выбранного элемента
        if indexPath.row == UserDefaults.standard.integer(forKey: "breakMark") {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // Обработка нажатия на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Получаем выбранную ячейку
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        // Получаем данные из ячейки
        let selectedValue = values[indexPath.row]
        let components = selectedValue.split(separator: " ")
        let result = String(components[0])
        
        // Устанавливаем выбранное значение времени для перерыва
        if let delegate = delegate {
            delegate.setBreakTime(value: result)
        }
        navigationController?.popViewController(animated: true)

        // Устанавливаем галочку для выбранной ячейки
        selectedCell?.accessoryType = .checkmark

        // Сохраняем значение в UserDefaults
        UserDefaults.standard.set(indexPath.row, forKey: "breakMark")
        UserDefaults.standard.set(result, forKey: "breakSelectedValue")

        // Убираем галочку у остальных ячеек
        for cell in tableView.visibleCells {
            if cell != selectedCell {
                cell.accessoryType = .none
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
}

