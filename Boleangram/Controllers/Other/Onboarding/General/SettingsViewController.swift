//
//  SettingsViewController.swift
//  Boleangram
//
//  Created by Enzo Gammino on 11/01/2022.
//

import UIKit


struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

/// View Controller to show user settings
final class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero,
                                style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
     
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        let section = [
            SettingCellModel(title:"Se déconnecter") { [weak self] in
                self?.didTapLogOut()
            }
        ]
        data.append(section)
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Se déconnecter",
                                            message: "Êtes vous sûr de vouloir vous déconnecter ?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Déconnexion", style: .destructive, handler: { _ in
            
            AuthManager.shared.logOut(completion: { succes in
                DispatchQueue.main.async {
                    if succes {
        //                back to LoginViewController
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
        //                Error occurred
                        fatalError("Impossible de déconnecter l'utilisateur")
                    }
                }
                
            })
            
        }))

        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.section][indexPath.row].handler()
    }
}
