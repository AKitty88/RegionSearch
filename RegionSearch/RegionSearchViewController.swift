//
//  RegionSearchViewController.swift
//  RegionSearch
//
//  Created by Kitti Almasy on 28/7/22.
//

import UIKit

class RegionSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var tableview: UITableView!
    private var regionList = [String]()
    private var searchResults = [String]()
    var indexPathsForSelectedRow: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        setSearchResults()
        setupNavigationBar()
        setupSearchController()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: nil,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func setSearchResults() {
        regionList = unsortedRegions.sorted()
        searchResults = regionList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let regionCell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "regionCell",
            for: indexPath
        )

        regionCell.textLabel?.text = searchResults[indexPath.row]
        return regionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            indexPathsForSelectedRow = indexPath
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath)
    }
    
    func deselectRow(at indexPath: IndexPath) {
        if let cell = tableview.cellForRow(at: indexPath) {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.accessoryType = .none
        }
    }
    
    func deselectSelectedRow() {
        guard let indexPath = indexPathsForSelectedRow else { return }
        deselectRow(at: indexPath)
        indexPathsForSelectedRow = nil
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        deselectSelectedRow()
        
        guard let text: String = searchController.searchBar.text,
              searchController.searchBar.text != "" else {
            tableview.reloadData()
            return
        }
        
        searchResults = regionList
            .map{$0.lowercased()}
            .filter{$0.contains(text.lowercased())}
            .map{($0.first?.uppercased() ?? "") + $0.lowercased().dropFirst()}
        
        tableview.reloadData()
    }
}
