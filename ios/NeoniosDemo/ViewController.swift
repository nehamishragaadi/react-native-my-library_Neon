
//
//  ViewController.swift
//  Neon-Ios
//
//  Created by Akhilendra Singh on 1/16/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //IBOutlets
    @IBOutlet weak var tagListView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    
    //Reference Variables
    private var locArr = [CLLocation]()
    private var imagePicker = UIImagePickerController()
    private let imageCache = NSCache<NSString, UIImage>()
    private var finalDict = [[String : Any]]()
    
    //Value type Variables
    private var selctedIndex = 0
    private var tags: String = "Mandatory Tags\n\n"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    //MARK: - ViewLife cycle methods
    var asset = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.setupAllTheThings()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("asset and singlton count on display", self.asset.count,NeonImagesHandler.singleonInstance.imagesCollection.count )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAllTheThings()
    }
    
    // MARK: - Private Class Instance methods
    private func setupAllTheThings() {
        imagePicker.delegate = self
        self.addCustomObjectInArray()
        self.setupCollectionView(isCollectionViewHidden: NeonImagesHandler.singleonInstance.imagesCollection.count <= 0)
    }
    
    private func addCustomObjectInArray() {
        self.tagListView.text = NeonImagesHandler.singleonInstance.addCustomObjectInArray()
    }
    
    private func setupCollectionView(isCollectionViewHidden: Bool) {
        
        DispatchQueue.main.async {
            self.tagListView.isHidden = !isCollectionViewHidden
            self.collectionView.isHidden = isCollectionViewHidden
            self.submitButton.isHidden = isCollectionViewHidden
            self.collectionView.reloadData()
        }
    }
    
    private func checkAllValidationOnSubmitButtonAction(message: String, arrayTagModel: [ImageTagModel], isMendatory: Bool) -> Bool {
        for tagModel in arrayTagModel {
            let arr   = NeonImagesHandler.singleonInstance.imagesCollection.filter {
                $0.getFileTag()?.getTagName() == tagModel.getTagName()
            }
            if tagModel.getNumberOfPhotos() >  arr.count {
                
                var messageUpdate = message
                if isMendatory {
                    messageUpdate = message + "\(tagModel.getTagName())"
                }
                if isMendatory == true {
                    self.showCommonAlert(title: "Message", message: messageUpdate)
                    return false
                } else {
                    return true
                }
                
            }
        }
        return true
    }
    
    private func showCommonAlert(title: String, message: String) {
        let ac = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func makeJsonToSendDataAfterAllChecks() {
        //Fetch all mendatory tag
        //check images are filled
        let mendatoryArray = NeonImagesHandler.singleonInstance.imageTagArray.filter { $0.isMandatory() == true}
        if mendatoryArray.count > 0  {
            if !self.checkAllValidationOnSubmitButtonAction(message: "Set images for Mandatory ", arrayTagModel: mendatoryArray, isMendatory: true) {
                return
            }
        }
        
        //Fetch all non-mendatory tag
        //check images are filled
        let nonMendatoryArray = NeonImagesHandler.singleonInstance.imageTagArray.filter { $0.isMandatory() == false}
        if nonMendatoryArray.count > 0 {
            if !self.checkAllValidationOnSubmitButtonAction(message: "Please delete all the images without tag or give them tag.", arrayTagModel: nonMendatoryArray, isMendatory: false) {
                return
            }
        }
        //Fetch all non-tagged images
        //check images are filled
        let arr = NeonImagesHandler.singleonInstance.getImagesCollection().filter {
            $0.getFileTag() == nil
        }
        if arr.count > 0 {
            self.showCommonAlert(title: "Message", message: "Please delete all the images without tag.")
            return
        }
        
        //When All requirements are done.
        self.showCommonAlert(title: "Message", message: "Perfect")
    }
    
    @objc private func deletePicture(sender:UIButton) {
        DispatchQueue.main.async {
            let i : Int = Int(sender.tag)
            self.asset.remove(at: i)
            NeonImagesHandler.singleonInstance.imagesCollection.remove(at: i)
            self.setupCollectionView(isCollectionViewHidden: NeonImagesHandler.singleonInstance.imagesCollection.count <= 0)
        }
        
    }
    
    private func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
        
    }
    
    //MARK: - IBAction methods
    @IBAction func cameraButtonAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func openGalleryTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            imagePicker.maximumSelectionsAllowed = 0
            imagePicker.selectedAsset = self.asset
            //NeonImagesHandler.singleonInstance.getNumberOfPhotosCollected()
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.makeJsonToSendDataAfterAllChecks()
    }
    
    // MARK: - Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showImage"){
            print("In segue")
            let showImageController = segue.destination as! ShowImageViewController
            showImageController.navigateIndex = self.selctedIndex
        }
    }
}

//MARK: - CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MyImageCell
        let fileinfo = NeonImagesHandler.singleonInstance.imagesCollection[indexPath.row]
        
        DispatchQueue.main.async {
            if let filePath = fileinfo.getFilePath(), filePath != "" {
                cell.imageView.isHidden = false
                if let image = NeonImagesHandler.singleonInstance.imageLocalPathSaved.object(forKey: filePath as NSString) {
                    cell.imageView.image = image
                } else {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(contentsOfFile: filePath)
                        NeonImagesHandler.singleonInstance.imageLocalPathSaved.setObject(cell.imageView.image!, forKey: filePath as NSString)
                    }
                }
            } else {
                cell.imageView.isHidden = true
            }
        }
        
        cell.deleteButton?.tag = indexPath.row
        cell.deleteButton?.addTarget(self, action: #selector(deletePicture(sender:)), for: .touchUpInside)
        
        guard let imageTageModel = fileinfo.getFileTag(), imageTageModel.getIsSelected() == true
            else {
                cell.tagName.text = "Select Tag"
                return cell
        }
        cell.tagName.text = imageTageModel.getTagName()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selctedIndex = indexPath.row
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("NeonImagesHandler.singleonInstance.imagesCollection.count ",NeonImagesHandler.singleonInstance.imagesCollection.count )
        
        return NeonImagesHandler.singleonInstance.imagesCollection.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow) - 10
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

//MARK: - ImagePicker
extension ViewController: OpalImagePickerControllerDelegate {
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 0
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    //    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
    //        return URL(string: "https://placeimg.com/500/500/nature")
    //    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        //NeonImagesHandler.singleonInstance.imagesCollection.removeAll()
        self.asset = assets
        
        var imagesCollectionArray = [FileInfo]()
        if assets.count > 0 {
            for i in 0...assets.count-1 {
                let asset = assets[i]
                manager.requestImageData(for: asset, options: options,
                                         resultHandler: { (imagedata, dataUTI, orientation, info) in
                                            if let info = info {
                                                if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
                                                    if let filePath = info[NSString(string: "PHImageFileURLKey")] as? URL {
                                                        print(filePath)
                                                        let absoluteString = filePath.absoluteString
                                                        //FileInfo()
                                                        let fileInfo = FileInfo()
                                                        //Set File path
                                                        fileInfo.setFilePath(filePath: absoluteString.replacingOccurrences(of: "file:///", with: ""))
                                                        
                                                        //Set File Name
                                                        fileInfo.setFileName(fileName: filePath.lastPathComponent)
                                                        //Set Source
                                                        fileInfo.setSource(source: SOURCE.PHONE_GALLERY)
                                                        
                                                        //Set Date TIme
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                                        fileInfo.setDateTimeTaken(dateTimeTaken: self.convertDateToString(date: asset.creationDate!))
                                                        
                                                        //Set Time Stamp
                                                        fileInfo.setTimestamp(timestamp: self.convertDateToString(date: asset.creationDate!))
                                                        
                                                        //Set Latitude and Longitude
                                                        if let locationInfo = asset.location {
                                                            fileInfo.setLatitude(latitude: String(locationInfo.coordinate.latitude))
                                                            fileInfo.setLongitude(longitude: String(locationInfo.coordinate.longitude))
                                                        }
                                                        //Save FileInfo in array
                                                        //                                                        NeonImagesHandler.singleonInstance.imagesCollection.append(fileInfo)
                                                        let taggedImageObject   = NeonImagesHandler.singleonInstance.imagesCollection.filter {
                                                            $0.getFilePath() == fileInfo.getFilePath()
                                                        }
                                                        
                                                        if taggedImageObject.count > 0 {
                                                            imagesCollectionArray.append(taggedImageObject[0])
                                                        } else {
                                                            imagesCollectionArray.append(fileInfo)
                                                        }
                                                        
                                                        //                                                        NeonImagesHandler.singleonInstance.imagesCollection = imagesCollectionArray
                                                        if i == assets.count - 1 {
                                                            
                                                            NeonImagesHandler.singleonInstance.imagesCollection = imagesCollectionArray
                                                            DispatchQueue.main.async {
                                                                self.setupCollectionView(isCollectionViewHidden: NeonImagesHandler.singleonInstance.imagesCollection.count <= 0)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                })
            }
            
            
        } else {
            DispatchQueue.main.async {
                NeonImagesHandler.singleonInstance.imagesCollection.removeAll()
                self.setupCollectionView(isCollectionViewHidden: NeonImagesHandler.singleonInstance.imagesCollection.count <= 0)
            }
        }
    }
}

extension ViewController: CameraViewControllerProtocol {
    //Images are getting from camera.
    func receiveFileInfoFromCameraAndSetupView(imageArray: [FileInfo]) {
        self.setupCollectionView(isCollectionViewHidden: NeonImagesHandler.singleonInstance.imagesCollection.count <= 0)
        
    }
    func setImageLoc(location: [CLLocation]){
        self.locArr = location
    }
}

//MARK: - UIImage
extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
