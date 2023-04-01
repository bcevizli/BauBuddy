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
    var button: UIButton!
    let qrCodeImageView = UIImageView(image: UIImage(named: "qrLogo"))
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        createTableView()
        searchBar()
        loginButton()
        qrScan()
    }
    
    private func qrScan() {
        // Add the QR code image view to the view
        view.addSubview(qrCodeImageView)
        
        // Add a tap gesture recognizer to the QR code image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openQRScanner))
        qrCodeImageView.addGestureRecognizer(tapGesture)
        qrCodeImageView.isUserInteractionEnabled = true
        qrCodeImageView.layer.cornerRadius = 20
        qrCodeImageView.clipsToBounds = true
        qrCodeImageView.sizeToFit()
        qrCodeImageView.isHidden = true
        
        // Position the QR code image view in the bottom right corner of the view
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            qrCodeImageView.widthAnchor.constraint(equalToConstant: 74),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: 74),
            qrCodeImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26),
            qrCodeImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    @objc func openQRScanner() {
        let qrScannerVC = QRScannerViewController()
        qrScannerVC.modalPresentationStyle = .fullScreen
        present(qrScannerVC, animated: true, completion: nil)
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
        
        button.addTarget(self, action: #selector(didLoginTapped), for: .touchUpInside)
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
        button.removeFromSuperview()
        qrCodeImageView.isHidden = false
    }
    private func createTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        view.addSubview(tableView)
        
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refreshData() {
           
           // Reload the table view and end refreshing
           tableView.reloadData()
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


