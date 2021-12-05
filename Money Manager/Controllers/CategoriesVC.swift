//
//  CategoriesVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 05.12.2021.
//

import UIKit
import RealmSwift

class CategoriesVC: UITableViewController {

    @IBOutlet weak var type: UISegmentedControl!
    var categories: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = RealmService.shared.realm
        categories = realm.objects(Category.self)
    }

    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type.selectedSegmentIndex == 0 {
           return categories.filter("type == %@", 0).count
        } else {
            return categories.filter("type == %@", 1).count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categories", for: indexPath)
        var content = cell.defaultContentConfiguration()

        if type.selectedSegmentIndex == 0 {
            content.text = categories.filter("type == %@", 0)[indexPath.row].name
        } else {
            content.text = categories.filter("type == %@", 1)[indexPath.row].name
        }
        cell.contentConfiguration = content
        return cell
    }
}
