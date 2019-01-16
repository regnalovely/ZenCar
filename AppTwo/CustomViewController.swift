//
//  CustomViewController.swift
//  AppFive
//
//  Created by etudiant on 04/12/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate {
    func cellHeader(index:Int)
    func deleteSection(id:Int)
}

class CustomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView:UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let reuseIdentifier = "customCell"
    
    let requeteSQL:RequeteSQL = RequeteSQL()
    var listeStationnement = [Stationnement]()
    var sectionID:Int!
    var delegate:HeaderViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        
        tableView.frame = view.frame
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        listeStationnement = requeteSQL.getStationnements()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = placeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [place])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeStationnement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = listeStationnement[indexPath.row].nom
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected : \(indexPath.row) for stationnement: \(listeStationnement[indexPath.row].nom)")
    }
    
    @objc func reload(){
        listeStationnement = requeteSQL.getStationnements()
        self.tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
