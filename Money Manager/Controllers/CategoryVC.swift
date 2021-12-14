//
//  CategoryVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 09.12.2021.
//

import UIKit
import RealmSwift

protocol CategoriesDelegate {
    func getCategoryInfo(category: Category)
}

class CategoryVC: UIViewController {
    
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var categories: Results<Category>!
    var delegate: CategoriesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let realm = RealmService.shared.realm
        categories = realm.objects(Category.self)
    }
    
    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
}

    //MARK: - UITableView

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type.selectedSegmentIndex == 0 {
            return categories.filter("type == %@", 0).count
        } else {
            return categories.filter("type == %@", 1).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getCategoryInfo(category: categories.filter("type == %@", type.selectedSegmentIndex)[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trashAction = UIContextualAction(style: .destructive, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            RealmService.shared.delete(self.categories.filter("type == %@", self.type.selectedSegmentIndex)[indexPath.row])
            tableView.reloadData()
            success(true)
        })
        trashAction.backgroundColor = .red
        trashAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
}
