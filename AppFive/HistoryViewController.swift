//
//  StationTableViewController.swift
//  AppFive
//
//  Created by etudiant on 27/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    let requeteSQL:RequeteSQL = RequeteSQL()
    var listeStationnement = [Stationnement]()
    var i:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "load"), object: nil)
        load()
    }
    
    @objc func reload(){
        listeStationnement = requeteSQL.getStationnements()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return listeStationnement.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.sectionID = listeStationnement[section].id
        headerView.delegate = self
        headerView.secIndex = section
        headerView.button.setTitle(listeStationnement[section].nom, for: .normal)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(listeStationnement[section].isExpandable){
            return 4
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        var nom:String = ""
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            nom = listeStationnement[indexPath.section].date
            break
        default:
            break
        }
        
        cell.textLabel?.text = nom
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listeStationnement[indexPath.section].isExpandable {
            return 50
        } else {
            return 0
        }
    }
    
    func reloadMapView(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
}

extension HistoryViewController: HeaderDelegate {
    func cellHeader(index: Int) {
        listeStationnement[index].isExpandable = !listeStationnement[index].isExpandable
        tableView.reloadSections([index], with: .automatic)
    }
    
    func deleteSection(id:Int){
        let stationnement = requeteSQL.getStationnement(id: id)
        requeteSQL.supprimerStationnement(stationnement: stationnement)
    }
}
