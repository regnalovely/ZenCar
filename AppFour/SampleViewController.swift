//
//  ViewController.swift
//  AppFour
//
//  Created by etudiant on 21/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var data = [DataModal(headerName: "programming mobile", subType: ["Java", "Swift", "C++"], isExpandable: false),
                DataModal(headerName: "programming web", subType: ["PHP", "JavaScript", "HTML", "CSS"], isExpandable: false),
                DataModal(headerName: "programming console", subType: ["Bash", "PowerShell", "Ruby"], isExpandable: false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
    }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.delegate = self
            headerView.secIndex = section
            headerView.button.setTitle(data[section].headerName, for: .normal)
            return headerView
        }
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if(data[section].isExpandable){
                return data[section].subType.count
            } else {
                return 0
            }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data[indexPath.section].isExpandable {
            return 40
        } else {
            return 0
        }
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cells")
            cell?.textLabel?.text = data[indexPath.section].subType[indexPath.row]
            return cell!
        }
}

extension SampleViewController: HeaderDelegate {
    func cellHeader(index: Int) {
        data[index].isExpandable = !data[index].isExpandable
        tableView.reloadSections([index], with: .automatic)
    }
}
