//
//  CurrencySearchVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 04.12.2021.
//

import UIKit

class CurrencySearchVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate: SearchCurrencyDelegate?
    let currencyModel = CurrencyModel()
    var data: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        data = currencyModel.currencyArray
    }
    
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currency", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currencyIndex = currencyModel.currencyArray.firstIndex(of: data[indexPath.row]) {
            delegate?.getCurrency(currencyIndex)
        }
        navigationController?.popViewController(animated: true)
    }
}

    //MARK: - UISearchBar

extension CurrencySearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        data = searchText.isEmpty ? currencyModel.currencyArray : currencyModel.currencyArray.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
}
