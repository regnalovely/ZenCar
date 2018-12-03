//
//  StationTableViewController.swift
//  AppFive
//
//  Created by etudiant on 27/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

class CustomListeViewController: UITableViewController {
    
    let requeteSQL:RequeteSQL = RequeteSQL()
    var listeStationnement = [Stationnement]()
    var taille:CGFloat = 50
    
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
        return listeStationnement.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: taille))
        headerView.sectionID = listeStationnement[section].id
        headerView.delegate = self
        headerView.secIndex = section
        headerView.button.setTitle(listeStationnement[section].nom, for: .normal)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return taille
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
        var text:String = ""
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            text = String(listeStationnement[indexPath.section].latitude)
            break
        case 2:
            text = String(listeStationnement[indexPath.section].longitude)
            break
        case 3:
            text = listeStationnement[indexPath.section].date
            break
        default:
            break
        }
        
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listeStationnement[indexPath.section].isExpandable {
            return taille
        } else {
            return 0
        }
    }
    
    func getInfoView(section:Int) -> UITableViewCell {
        let infoView = InfoView(style: .default, reuseIdentifier: "infoCell-+")
        infoView.delegate = self
        infoView.sectionID = section
        return infoView
    }
}

extension CustomListeViewController: HeaderDelegate, InfoDelegate {
    func cellHeader(index: Int) {
        listeStationnement[index].isExpandable = !listeStationnement[index].isExpandable
        tableView.reloadSections([index], with: .automatic)
    }
    
    func deleteSection(id:Int){
        let stationnement = requeteSQL.getStationnement(id: id)
        requeteSQL.supprimerStationnement(stationnement: stationnement)
    }
}
