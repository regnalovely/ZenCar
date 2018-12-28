//
//  ListeViewController.swift
//  AppFive
//
//  Created by etudiant on 03/12/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

class ListeViewController: UITableViewController {
    
    let reuseIdentifier = "historyCell"
    let size:CGFloat = 50
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
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.width, height: size))
        let button:UIButton = {
            let btn = UIButton(frame: view.frame)
            btn.setTitle(listeStationnement[section].nom, for: .normal)
            
            return btn
        }()
        
        view.addSubview(button)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return size
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return listeStationnement.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = listeStationnement[indexPath.section].nom
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = placeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [place])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoris = favorisAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, favoris])
    }
    
    func placeAction(at indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Stationner") { (action, view, completion) in
            let controller:MapViewController = MapViewController()
            controller.localisation()
            controller.isHere()
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "station")
        
        return action
    }
    
    func favorisAction(at indexPath:IndexPath) -> UIContextualAction {
        let station = listeStationnement[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favoris") { (action, view, completion) in
            station.isFavorite = !station.isFavorite
            completion(true)
        }
        
        action.image = station.isFavorite ? #imageLiteral(resourceName: "favoris") : #imageLiteral(resourceName: "star")
        
        return action
    }
    
    func deleteAction(at indexPath:IndexPath) -> UIContextualAction {
        let station = listeStationnement[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Supprimer") { (action, view, completion) in
            self.requeteSQL.supprimerStationnement(stationnement: station)
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "trash")
        
        return action
    }
}

extension ListeViewController: HeaderViewDelegate {
    func cellHeader(index: Int) {
        listeStationnement[index].isExpandable = !listeStationnement[index].isExpandable
        tableView.reloadSections([index], with: .automatic)
    }
    
    func deleteSection(id:Int){
        let stationnement = requeteSQL.getStationnement(id: id)
        requeteSQL.supprimerStationnement(stationnement: stationnement)
    }
}
