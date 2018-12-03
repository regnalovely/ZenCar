//
//  ListeViewController.swift
//  AppFive
//
//  Created by etudiant on 03/12/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

class ListeViewController: UITableViewController {
    
    let requeteSQL:RequeteSQL = RequeteSQL()
    var listeStationnement = [Stationnement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        reload()
    }
    
    @objc func reload(){
        listeStationnement = requeteSQL.getStationnements()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeStationnement.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = listeStationnement[indexPath.row].nom
        return cell
    }
}

extension ListeViewController: HeaderDelegate {
    func cellHeader(index: Int) {
        listeStationnement[index].isExpandable = !listeStationnement[index].isExpandable
        tableView.reloadSections([index], with: .automatic)
    }
    
    func deleteSection(id:Int){
        let stationnement = requeteSQL.getStationnement(id: id)
        requeteSQL.supprimerStationnement(stationnement: stationnement)
    }
}
