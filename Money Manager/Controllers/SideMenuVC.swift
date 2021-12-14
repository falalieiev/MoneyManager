//
//  SideMenuVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 08.12.2021.
//

import UIKit

class SideMenuVC: UITableViewController {
    
    @IBOutlet weak var switchDarkModeStatus: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsModel.shared.theme == .dark {
            switchDarkModeStatus.isOn = true
        } else {
            switchDarkModeStatus.isOn = false
        }
    }
    
    @IBAction func darkModePressed(_ sender: UISwitch) {
        var darkMode = 0
        if sender.isOn {
            darkMode = 0
        } else {
            darkMode = 1
        }
        UserDefaultsModel.shared.theme = Theme(rawValue: darkMode) ?? .light
        self.view.window?.overrideUserInterfaceStyle = UserDefaultsModel.shared.theme.getUserInterfaceStyle()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let currentCell = tableView.cellForRow(at: indexPath)
            currentCell?.selectionStyle = .none
        }
        if indexPath.row == 1 {
            performSegue(withIdentifier: "showCategories", sender: self)
        }
    }
}
