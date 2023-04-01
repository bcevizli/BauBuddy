//
//  HomeViewController.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 30.03.2023.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    let tableView = UITableView()
    
    var tasksArray = [Items]()
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log in", style: .plain, target: self, action: #selector(didLoginTapped))
        createTableView()
        searchBar()
        //        viewModel.loadJsonData { items in
        //            self.tasksArray = items
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        }
    }
    @objc private func didLoginTapped() {
        viewModel.login {
            self.viewModel.loadJsonData { items in
                self.tasksArray = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    private func createTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.updateCell(with: tasksArray[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        searchBar.scopeButtonTitles = ["Task", "Title", "Description"]
        self.tableView.tableHeaderView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            didLoginTapped()
        }
        else if searchBar.selectedScopeButtonIndex == 0 {
            tasksArray = tasksArray.filter({ items in
                return   items.task.lowercased().contains(searchText.lowercased())
            })
        }
        
        else if searchBar.selectedScopeButtonIndex == 1 {
            
            tasksArray = tasksArray.filter({ items in
                return items.title.lowercased().contains(searchText.lowercased())
            })
        }
        else {
            tasksArray = tasksArray.filter({ items in
                items.description.lowercased().contains(searchText.lowercased())
            })
        }
        
        self.tableView.reloadData()
    }
}
