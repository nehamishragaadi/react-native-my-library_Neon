//
//  SelectImageTagController.swift
//  Neon-Ios
//
//  Created by Deepak Sharma on 27/08/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import UIKit

class SelectImageTagController: UIViewController {

    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subView: UIView!
    
    //Class instance variables
    var completionHandler:(() -> Void)?
    var fileInfo = FileInfo()
    
    //MARK: - ViewLife cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAllTheThings()
    }
    
    // MARK: - Private Class Instance methods
    private func setupAllTheThings() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Add Tapgesture on view
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        subView.addGestureRecognizer(tap)
    }
    
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension SelectImageTagController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NeonImagesHandler.singleonInstance.imageTagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row].getTagName()
        cell.contentView.backgroundColor = (NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row].getIsSelected() == true) ? .lightGray : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                //Select Tag for file info
        let isLimitExceeded   = NeonImagesHandler.singleonInstance.imagesCollection.filter {
            $0.getFileTag()?.getTagName() == NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row].getTagName()
        }.count >= NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row].getNumberOfPhotos()
        print(NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row].getNumberOfPhotos())
        
        
        if isLimitExceeded && NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row].getNumberOfPhotos() != 0 {
            let alert = UIAlertController(title: "Alert", message: "Your limit is exceeded.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .destructive) { (action) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row].setIsSelected(isSelected: true)
            fileInfo.setFileTag(fileTag: NeonImagesHandler.singleonInstance.imageTagArray[indexPath.row])
            self.completionHandler?()
            self.dismiss(animated: true)
        }
    }
}


