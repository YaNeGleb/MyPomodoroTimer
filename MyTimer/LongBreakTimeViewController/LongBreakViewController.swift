//
//  LongBreakViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 27.03.2023.
//

import UIKit

class LongBreakViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var value: String?
    var values = ["20 минут", "30 минут", "40 минут"]
    var delegate: TimerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // Set view title
        title = "Long Break"
    }
}

// MARK: - Table view delegate and data source

extension LongBreakViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    // Configure each cell in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = values[indexPath.row]
        
        // Set checkmark accessory type if this cell was previously selected
        if indexPath.row == UserDefaults.standard.integer(forKey: "longBreakMark") {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // Handle cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get the selected cell
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        // Get the selected value
        let selectedValue = values[indexPath.row]
        let components = selectedValue.split(separator: " ")
        let result = String(components[0])
        
        // Call delegate method to update long break time
        if let delegate = delegate {
            delegate.setLongBreakTime(value: result)
        }
        
        // Pop back to previous view controller
        navigationController?.popViewController(animated: true)
        
        // Set checkmark accessory type for selected cell
        selectedCell?.accessoryType = .checkmark
        
        // Save the selected value in user defaults
        UserDefaults.standard.set(indexPath.row, forKey: "longBreakMark")
        UserDefaults.standard.set(result, forKey: "longBreakSelectedValue")
        
        // Remove checkmark accessory type from all other cells
        for cell in tableView.visibleCells {
            if cell != selectedCell {
                cell.accessoryType = .none
            }
        }
        
        // Pop back to root view controller
        navigationController?.popToRootViewController(animated: true)
    }
}
