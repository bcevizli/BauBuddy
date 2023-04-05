//
//  HomeViewController.swift
//  VeroCaseStudy
//
//  Created by Adem Burak Cevizli on 30.03.2023.
//

import UIKit
import Alamofire
import AVFoundation

class HomeViewController: UIViewController {
    
    let tableView = UITableView()
    var tasksArray = [Items]()
    var viewModel: HomeViewModel!
    var searchBar = UISearchBar()
    var button: UIButton!
    let qrCodeImageView = UIImageView()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "BauBuddy"
        loginButton()
    }
    
    private func configureQrScanUI() {
        // Add the QR code image view to the view
        view.addSubview(qrCodeImageView)
        
        // Add a tap gesture recognizer to the QR code image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openQRScanner))
        qrCodeImageView.addGestureRecognizer(tapGesture)
        qrCodeImageView.isUserInteractionEnabled = true
        qrCodeImageView.alpha = 0.8
        qrCodeImageView.layer.cornerRadius = 15
        qrCodeImageView.clipsToBounds = true
        qrCodeImageView.sizeToFit()
        qrCodeImageView.image = UIImage(named: "qrLogo")
        
        // Position the QR code image view in the bottom right corner of the view
        qrCodeImageView.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -26, right: -26), size: CGSize(width: 74, height: 74))
    }
    @objc func openQRScanner() {
        let qrScannerVC = QRScannerViewController()
        qrScannerVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(qrScannerVC, animated: true)
    }
    
    private func loginButton() {
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        
        button.anchorWithCenter(centerX: view.centerXAnchor, centerY: view.centerYAnchor, size: CGSize(width: 120, height: 50))
        
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    @objc private func didTapLogin() {
        button.removeFromSuperview()
        configureSearchBarUI()
        createTableView()
        configureQrScanUI()
        viewModel.login {
            self.viewModel.loadJsonData { items in
                if let itemObjects = RealmManager().fetch() {
                    if itemObjects.count == items.count {
                        self.tasksArray = itemObjects
                    } else {
                        items.forEach { item in
                            RealmManager().save(on: item)
                        }
                        self.tasksArray = items
                    }
                }
            }
        }
        
        if self.tasksArray.isEmpty {
            if let itemObjects = RealmManager().fetch() {
                self.tasksArray = itemObjects
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func createTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        view.addSubview(tableView)
        
        tableView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, padding: UIEdgeInsets(top: 2, left: 10, bottom: 0, right: -10))
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refreshData() {
        // Reload the table view and end refreshing
        self.viewModel.loadJsonData { items in
            self.tasksArray = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        refreshControl.endRefreshing()
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
    func configureSearchBarUI() {
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, size: CGSize(width: 0, height: 100))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        searchBar.placeholder = "Search"
        searchBar.scopeButtonTitles = ["Task", "Title", "Description"]
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            didTapLogin()
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


