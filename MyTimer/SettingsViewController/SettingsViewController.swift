//
//  SettingsViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 24.03.2023.
//

import UIKit


protocol MyDelegate {
    func didGetValue(value: String)
}

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    let isOn: Bool
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    let switch1Key = "Switch1"
    let switch2Key = "Switch2"
    let userdefaults = UserDefaults.standard
    let savedTheme = UserDefaults.standard.bool(forKey: "isDarkTheme")
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        configure()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        
        if savedTheme {
            overrideUserInterfaceStyle = .dark
               }
    }
    
    //MARK: - Configure switch
    func switchValueChanged(isOn: Bool, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
              if isOn {
//                overrideUserInterfaceStyle = .dark
                userdefaults.set(true, forKey: "isDarkTheme")
                userdefaults.set(isOn, forKey: switch1Key)
                  updateTheme()

              } else {
                  userdefaults.removeObject(forKey: switch1Key)
//                  overrideUserInterfaceStyle = .light
                  userdefaults.set(false, forKey: "isDarkTheme")
                  updateTheme()

              }
          case 1:
              if isOn {
                  userdefaults.set(isOn, forKey: switch2Key)
              } else {
                  userdefaults.removeObject(forKey: switch2Key)
              }
          default:
              break
          }
      }
    
    //MARK: - Update theme
    func updateTheme() {
        let isDarkModeEnabled = userdefaults.bool(forKey: "isDarkTheme")
        if isDarkModeEnabled {
            if #available(iOS 13.0, *) {
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        } else {
            if #available(iOS 13.0, *) {
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK: - Configure custom cell
    func configure() {
        models = [
            Section(title: "Информация", options: [
                .staticCell(model: SettingsOption(title: "О нас", icon: UIImage(systemName: "info"), iconBackgroundColor: .gray, handler: {})),
                .staticCell(model: SettingsOption(title: "Как это устроено", icon: UIImage(systemName: "questionmark"), iconBackgroundColor: .gray, handler: {}))
            ]),
            Section(title: "Таймер", options: [
                .staticCell(model: SettingsOption(title: "Рабочий интервал", icon: UIImage(systemName: "timer"), iconBackgroundColor: .systemOrange) {}),
                .staticCell(model: SettingsOption(title: "Короткий перерыв", icon: UIImage(systemName: "timer"), iconBackgroundColor: .systemPurple) {}),
                .staticCell(model: SettingsOption(title: "Большой перерыв", icon: UIImage(systemName: "timer"), iconBackgroundColor: .systemGreen) {})
            ]),
            Section(title: "Общее", options: [
                .switchCell(model: SettingsSwitchOption(title: "Темный режим", icon: UIImage(systemName: "moonphase.first.quarter.inverse"), iconBackgroundColor: .black, handler: {}, isOn: false)),
                .switchCell(model: SettingsSwitchOption(title: "Dumayu2", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink, handler: {}, isOn: false))
            ])
        ]
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model {
        case .staticCell(let settingsOption):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            
            switch (indexPath.section, indexPath.row) {
            case (1, 0):
                if let selectedValue = userdefaults.string(forKey: "selectedValue") {
                    cell.timeLabel.text = selectedValue + " мин"
                }
            case (1, 1):
                if let selectedValue = userdefaults.string(forKey: "breakSelectedValue") {
                    cell.timeLabel.text = selectedValue + " мин"
                }
            case (1, 2):
                if let selectedValue = userdefaults.string(forKey: "longBreakSelectedValue") {
                    cell.timeLabel.text = selectedValue + " мин"
                }
            default:
                break
            }
            
            cell.selectionStyle = .none
            cell.configure(with: settingsOption)
            return cell
            
        case .switchCell(let settingsSwitchOption):
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            cell.configure(with: settingsSwitchOption)
            
            switch indexPath.row {
            case 0:
                cell.mySwitch.isOn = userdefaults.bool(forKey: switch1Key)
            case 1:
                cell.mySwitch.isOn = userdefaults.bool(forKey: switch2Key)
            default:
                break
            }
            return cell
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = models[indexPath.section].options[indexPath.row]
        
        switch selectedOption {
        
        case .staticCell(let model):
            model.handler()
            switch indexPath {
                
            case IndexPath(row: 0, section: 1):
                let selectTimeViewController = storyboard?.instantiateViewController(withIdentifier: "SelectTimeViewController") as! FocusTimeViewController
                selectTimeViewController.value = "\(indexPath.row + 10)"
                selectTimeViewController.delegate = navigationController?.viewControllers.first as? TimerViewController
                navigationController?.pushViewController(selectTimeViewController, animated: true)
                
            case IndexPath(row: 1, section: 1):
                let breakViewController = storyboard?.instantiateViewController(withIdentifier: "BreakViewController") as! BreakViewController
                breakViewController.value = "\(indexPath.row + 10)"
                breakViewController.delegate = navigationController?.viewControllers.first as? TimerViewController
                navigationController?.pushViewController(breakViewController, animated: true)
                
            case IndexPath(row: 2, section: 1):
                let longBreakViewController = storyboard?.instantiateViewController(withIdentifier: "LongBreakViewController") as! LongBreakViewController
                longBreakViewController.value = "\(indexPath.row + 10)"
                longBreakViewController.delegate = navigationController?.viewControllers.first as? TimerViewController
                navigationController?.pushViewController(longBreakViewController, animated: true)
                
            case IndexPath(row: 0, section: 0):
                let informationViewController = storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
                navigationController?.pushViewController(informationViewController, animated: true)
                
            case IndexPath(row: 1, section: 0):
                let howItWorkViewController = storyboard?.instantiateViewController(withIdentifier: "HowItWorkViewController") as! HowItWorkViewController
                navigationController?.pushViewController(howItWorkViewController, animated: true)
                
            default:
                break
            }
            
        case .switchCell(let model):
            model.handler()
        }
    }
}
