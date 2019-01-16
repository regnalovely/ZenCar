//
//  ListeViewController.swift
//  AppFive
//
//  Created by etudiant on 03/12/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

struct Headline {
    var nomStationnement:String
    var dateStationnement:String
    var isFavoris:Bool
}

class HeadlineTableViewCell: UITableViewCell {
    @IBOutlet weak var nomStationnement: UILabel!
    @IBOutlet weak var dateStationnement: UILabel!
    @IBOutlet weak var favorisIcone: UIImageView!
}

class ListeViewController: UITableViewController {
    

    
    let reuseIdentifier = "historyCell"
    let size:CGFloat = 50
    let requeteSQL:RequeteSQL = RequeteSQL()
    var listeStationnement = [Stationnement]()
    var currentItem:String!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HeadlineTableViewCell
        let stationnement = listeStationnement[indexPath.row]
        cell.nomStationnement.text = stationnement.nom
        cell.dateStationnement.text = stationnement.date
        if stationnement.isFavorite {
            cell.favorisIcone.isHidden = false
        } else {
            cell.favorisIcone.isHidden = true
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            let cell = sender as? UITableViewCell
            currentItem = (cell?.textLabel?.text)!
            let controller = segue.destination as? DetailsViewController
            controller?.name = currentItem
            //print("--- prepareSegue \(currentName)")
        }
    }
}
