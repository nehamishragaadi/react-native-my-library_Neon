//  ShowImageViewController.swift
//  Neon-Ios
//  Created by Temp on 22/08/19.
//  Copyright © 2019 Girnar. All rights reserved.

import UIKit
import Photos

class ShowImageViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var selectTagButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    //Class instance private property
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    private var image: UIImage?
    
    //Class Instance property
    var navigateIndex = 0

    //MARK: - ViewLife cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAllTheThings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.imageCollection.layoutIfNeeded()
            self.imageCollection.scrollToItem(at: IndexPath(item:  self.navigateIndex, section: 0), at: .right, animated: false)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Class private methods
    private func setupAllTheThings() {
        self.bottomView.layer.borderWidth = 1
        self.bottomView.layer.borderColor = UIColor.lightGray.cgColor
        let rightButtonItem = UIBarButtonItem.init(
            title: "Edit",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
    
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        self.openCropViewController()
    }
    
    private func saveImageInCustomGalleryFolderAfterUpdate(image: UIImage, cropViewController: CropViewController, cell: imgCollectionViewCell) {
        SaveImageInGallery.sharedInstance.saveImage(image: image, albumName: "TestingNeon111") { (filePath, error) in
            if error != nil {
                print(error as Any)
                return
            }
            let fileInfo = NeonImagesHandler.singleonInstance.imagesCollection[self.imageCollection.indexPathsForVisibleItems.first!.row]
            
            fileInfo.setFilePath(filePath: filePath!)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            if cropViewController.croppingStyle != .circular {
                cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                       toView: cell.imageView,
                                                       toFrame: CGRect.zero,
                                                       setup: {},
                                                       completion: {
                                                        DispatchQueue.main.async {
                                                            cell.imageView.isHidden = false
                                                            self.imageCollection.reloadItems(at: [self.imageCollection.indexPathsForVisibleItems.first!])
                                                        }
                })
            }
            
        }
    }
    
    private func openCropViewController() {
        if imageCollection.indexPathsForVisibleItems.count > 0 {
            croppedAngle = 0
            self.navigateIndex = imageCollection.indexPathsForVisibleItems.first!.row
            let cell = imageCollection.cellForItem(at: imageCollection.indexPathsForVisibleItems.first!)  as! imgCollectionViewCell
            let cropViewController = CropViewController(croppingStyle: self.croppingStyle, image: cell.imageView.image!)
            cropViewController.delegate = self
            let viewFrame = view.convert(cell.imageView.frame, to: navigationController!.view)
            
            cropViewController.presentAnimatedFrom(self,
                                                   fromImage: cell.imageView.image,
                                                   fromView: nil,
                                                   fromFrame: viewFrame,
                                                   angle: self.croppedAngle,
                                                   toImageFrame: self.croppedRect,
                                                   setup: { cell.imageView.isHidden = true },
                                                   completion: nil)
        }
    }
    
    //MARK: - IBAction methods
    @IBAction func showImageTagControllerAction(_ sender: Any) {
        if imageCollection.indexPathsForVisibleItems.count > 0 {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectImageTagController") as! SelectImageTagController
            
            viewController.completionHandler = {                self.selectTagButton.setTitle(NeonImagesHandler.singleonInstance.imagesCollection[self.imageCollection.indexPathsForVisibleItems.first!.row].getFileTag()?.getTagName(), for: .normal)
            }
            
            //Finding unassigned tag in FileInfo Array
            for item in NeonImagesHandler.singleonInstance.imageTagArray {
                for fileInfo in NeonImagesHandler.singleonInstance.imagesCollection {
                    if fileInfo.getFileTag()?.getTagName() != item.getTagName() {
                        item.setIsSelected(isSelected: false)
                        
                    } else {
                        item.setIsSelected(isSelected: true)
                        break
                    }
                }
            }
            viewController.fileInfo = NeonImagesHandler.singleonInstance.imagesCollection[self.imageCollection.indexPathsForVisibleItems.first!.row]
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
}

//MARK: - CollectionView
extension ShowImageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Setting data on cell
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "imgCollectionViewCell", for: indexPath as IndexPath) as! imgCollectionViewCell
        cell.backgroundColor = UIColor.black
        let fileInfo = NeonImagesHandler.singleonInstance.imagesCollection[indexPath.row]
        
        DispatchQueue.main.async {
            if let image = NeonImagesHandler.singleonInstance.imageLocalPathSaved.object(forKey: fileInfo.getFilePath()! as NSString) {
                cell.imageView.image = image
            } else {
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(contentsOfFile: fileInfo.getFilePath()!)
                    NeonImagesHandler.singleonInstance.imageLocalPathSaved.setObject(cell.imageView.image!, forKey: fileInfo.getFilePath()! as NSString)
                }}
        }
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.contentMode = .scaleAspectFit
        if #available(iOS 11.0, *) {
            cell.imageView.accessibilityIgnoresInvertColors = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openCropViewController()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.imageCollection.frame.width, height: self.imageCollection.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NeonImagesHandler.singleonInstance.imagesCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let fileInfo = NeonImagesHandler.singleonInstance.imagesCollection[indexPath.row]
        if fileInfo.getFileTag()?.getIsSelected() == true,  let tagName = fileInfo.getFileTag()?.getTagName() {
            self.selectTagButton.setTitle(tagName, for: .normal)
        } else {
            self.selectTagButton.setTitle("Select Tag", for: .normal)
        }
    }
}

extension ShowImageViewController : CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        
        if imageCollection.indexPathsForVisibleItems.count > 0 {
            let cell = imageCollection.cellForItem(at: imageCollection.indexPathsForVisibleItems.first!)  as! imgCollectionViewCell
            
            cell.imageView.image = image
            
            self.saveImageInCustomGalleryFolderAfterUpdate(image: image, cropViewController: cropViewController, cell: cell)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        if imageCollection.indexPathsForVisibleItems.count > 0 {
            self.navigateIndex = imageCollection.indexPathsForVisibleItems.first!.row
            let cell = imageCollection.cellForItem(at: imageCollection.indexPathsForVisibleItems.first!)  as! imgCollectionViewCell
            if cropViewController.croppingStyle != .circular {
                cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                       toView: cell.imageView,
                                                       toFrame: CGRect.zero,
                                                       setup: {},
                                                       completion: {
                                                        
                                                        cell.imageView.isHidden = false
                                                        self.imageCollection.reloadItems(at: [self.imageCollection.indexPathsForVisibleItems.first!])
                                                        
                })
            }
        }
    }
}
