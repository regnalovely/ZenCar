//
//  InfoView.swift
//  AppFive
//
//  Created by etudiant on 03/12/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

protocol InfoDelegate {
    func deleteSection(id:Int)
}

class InfoView : UITableViewCell {
    var sectionID:Int!
    var delegate:InfoDelegate?
    var myColor = "E86D8A"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(photo)
        self.addSubview(audio)
        self.addSubview(delete)
        
        photo.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        audio.leftAnchor.constraint(equalTo: self.photo.leftAnchor).isActive = true
        delete.leftAnchor.constraint(equalTo: self.audio.leftAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var delete:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("Supprimer", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        btn.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(onClickBtnDelete), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var photo:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("photo", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.5294117647, blue: 0.6588235294, alpha: 1)
        btn.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(prendrePhoto), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var audio:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("audio", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
        btn.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(enregistrerAudio), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func prendrePhoto(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        let listeVC = storyboard.instantiateViewController(withIdentifier: "ListeViewController") as! ListeViewController
        
        let alert = UIAlertController(title: "Stationnement", message: nil, preferredStyle: .alert)
        let actionCamera = UIAlertAction(title: "Prendre une photo", style: .default, handler: { _ -> Void in
            listeVC.present(cameraVC, animated: true, completion: nil)
        })
        alert.addAction(actionCamera)
        listeVC.present(alert, animated: true, completion: nil)
    }
    
    @objc func enregistrerAudio(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let audioVC = storyboard.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        let listeVC = storyboard.instantiateViewController(withIdentifier: "ListeViewController") as! ListeViewController
        
        let alert = UIAlertController(title: "Stationnement", message: nil, preferredStyle: .alert)
        let actionCamera = UIAlertAction(title: "Enregistrer un audio", style: .default, handler: { _ -> Void in
            listeVC.present(audioVC, animated: true, completion: nil)
        })
        alert.addAction(actionCamera)
        listeVC.present(alert, animated: true, completion: nil)
    }
    
    @objc func onClickBtnDelete(){
        print("Deleted button is clicking")
        
        if let id = sectionID {
            delegate?.deleteSection(id: id)
        }
    }
}
