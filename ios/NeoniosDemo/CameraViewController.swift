//
//  CameraViewController.swift
//  Neon-Ios
//
//  Created by Akhilendra Singh on 1/17/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import AssetsLibrary
import Photos

protocol CameraViewControllerProtocol : class {
    func receiveFileInfoFromCameraAndSetupView(imageArray: [FileInfo])
    func setImageLoc(location: [CLLocation])
    
}

class CameraViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
   
    //IBOutlets
    @IBOutlet weak var currentImageClicked: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var preview: UIView!
    
    //Camera Variables
    private var currentSettings: AVCapturePhotoSettings? = nil
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var deviceInput: AVCaptureDeviceInput?
    private var captureSession: AVCaptureSession!
    private var currentCamera: AVCaptureDevice!
    private var input: AVCaptureInput!
    
    //Location
    private var loc_Array: [CLLocation] = [CLLocation]()
    private var locManager = CLLocationManager()
    private var currentLocation: CLLocation!
    
    //Class Instance methods
    private var cameraPosition: CameraFacing = .back
    private var currentFlashMode: FlashMode!
    
    //Delegate instance
    weak var delegate: CameraViewControllerProtocol?
    
    //Value type variables
    var isFlashOnOff = false
    var localIdentifierName = ""
    var tagIndex = 0;
    
    
    //MARK: - ViewLife cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tagTextView.text = NeonImagesHandler.singleonInstance.imageTagArray[0].getTagName()
        self.setupCamera(position: .back)
        self.checkIndex()
        
    }
    
    //MARK: - Private methods
    private func setupCamera(position: AVCaptureDevice.Position){
        // Setup your camera here...
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let device: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                                    for: .video, position: position) else { return }
        currentCamera = device
        currentFlashMode = .auto
        
        do {
            input = try AVCaptureDeviceInput(device: device)
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        stillImageOutput = AVCapturePhotoOutput()
        if captureSession.canAddInput(input ) && captureSession.canAddOutput(stillImageOutput) {
            captureSession.addInput(input )
            captureSession.addOutput(stillImageOutput)
            setupLivePreview()
        }
        
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        preview.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.preview.bounds
        }
    }
    
    private func saveCapturedImageLocation(fielInfo: FileInfo) {
        locManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
            currentLocation = locManager.location
        }
        self.loc_Array.append(currentLocation)
    }
    
    private func checkIndex(){
        if tagIndex == 0 {
            previousButton.isHidden = true
        }
        else if tagIndex > 0 && tagIndex < NeonImagesHandler.singleonInstance.imageTagArray.count-1 {
            previousButton.isHidden = false
            nextButton.isHidden = false
        }
        else if tagIndex == NeonImagesHandler.singleonInstance.imageTagArray.count-1 {
            nextButton.isHidden = true
        }
    }
    
    //MARK: - IBAction methods
    @IBAction func takePhoto(_ sender: Any) {
        currentSettings = getSettings(camera: currentCamera,isFlashOnOff : isFlashOnOff)
        stillImageOutput.capturePhoto(with: currentSettings!, delegate: self)
    }
    
    @IBAction func tapOnCameraSwitch(_ sender: UITapGestureRecognizer) {
        switch self.cameraPosition {
        case .front:
            self.cameraPosition = .back
            self.setupCamera(position: .back)
        case .back:
            self.cameraPosition = .front
            self.setupCamera(position: .front)
        }
    }
    
    @IBAction func tapFlashOnOff(_ sender: UITapGestureRecognizer) {
        isFlashOnOff = isFlashOnOff ? false:true
    }
    
    @IBAction func tapToDone(_ sender: Any) {
        delegate?.receiveFileInfoFromCameraAndSetupView(imageArray: NeonImagesHandler.singleonInstance.imagesCollection)
        delegate?.setImageLoc(location: self.loc_Array)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        if tagIndex > 0 {
            tagIndex = tagIndex - 1;
            self.tagTextView.text = NeonImagesHandler.singleonInstance.imageTagArray[tagIndex].getTagName()
        }
        self.checkIndex()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if tagIndex < NeonImagesHandler.singleonInstance.imageTagArray.count - 1 {
            tagIndex = tagIndex + 1;
            self.tagTextView.text = NeonImagesHandler.singleonInstance.imageTagArray[tagIndex].getTagName()
        }
        self.checkIndex()
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        /*
         Steps
         1. Capture image from camera.
         2. Create App name folder in the photo gallery.
         3. Save image in app folder
         4. Get save image path from PHAssets
         */
        
        let tagModel : ImageTagModel = NeonImagesHandler.singleonInstance.imageTagArray[self.tagIndex]
        let arr   = NeonImagesHandler.singleonInstance.imagesCollection.filter {
            $0.getFileTag()?.getTagName() == tagModel.getTagName()
        }

        if tagModel.getNumberOfPhotos() > arr.count || NeonImagesHandler.singleonInstance.imageTagArray[self.tagIndex].getNumberOfPhotos() == 0  {
            
            guard let imageData = photo.fileDataRepresentation()
                else { return }
            
            let image = UIImage(data: imageData)
            currentImageClicked.image = image
            
            SaveImageInGallery.sharedInstance.saveImage(image: image!, albumName: "TestingNeon111") { (filePath, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                let fileInfo = FileInfo()
                
                
                fileInfo.setFilePath(filePath: filePath!)
                fileInfo.setSource(source: SOURCE.PHONE_CAMERA)
                
                tagModel.setIsSelected(isSelected: true)
                
                fileInfo.setFileTag(fileTag: tagModel)
                NeonImagesHandler.singleonInstance.imagesCollection.append(fileInfo)
                
                let arr2   = NeonImagesHandler.singleonInstance.imagesCollection.filter {
                    $0.getFileTag()?.getTagName() == tagModel.getTagName()
                }
                
                if self.tagIndex < NeonImagesHandler.singleonInstance.imageTagArray.count - 1 || tagModel.getNumberOfPhotos() > arr2.count{
                    
                    if tagModel.getNumberOfPhotos() == arr2.count {
                        self.tagIndex = self.tagIndex + 1;
                    }
                    let tagModel: ImageTagModel = NeonImagesHandler.singleonInstance.imageTagArray[self.tagIndex]
                    self.tagTextView.text = tagModel.getTagName();
                    self.checkIndex()
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.receiveFileInfoFromCameraAndSetupView(imageArray: NeonImagesHandler.singleonInstance.imagesCollection)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            if tagModel.getNumberOfPhotos() == arr.count {
                let alert = UIAlertController(title: "Alert", message: "Your limit is exceeded.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive) { (action) in
                    DispatchQueue.main.async {
                        
                        print("present DISMISS")
                        
                        if self.tagIndex < NeonImagesHandler.singleonInstance.imageTagArray.count - 1 {
                            self.tagIndex = self.tagIndex + 1;
                            let tagModel: ImageTagModel = NeonImagesHandler.singleonInstance.imageTagArray[self.tagIndex]
                            self.tagTextView.text = tagModel.getTagName();
                            self.checkIndex()
                        
                        } else if self.tagIndex == NeonImagesHandler.singleonInstance.imageTagArray.count - 1 && self.nextButton.isHidden {
                            DispatchQueue.main.async {
                                self.delegate?.receiveFileInfoFromCameraAndSetupView(imageArray: NeonImagesHandler.singleonInstance.imagesCollection)
                                self.navigationController?.popViewController(animated: true)
                                return
                            }
                        }
                    }
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
    }
    
    func getSettings(camera: AVCaptureDevice, isFlashOnOff: Bool) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        
        if camera.hasFlash {
            /*switch flashMode {
             case .auto: settings.flashMode = .auto
             case .on: settings.flashMode = .on
             default: settings.flashMode = .off
             }*/
            if(isFlashOnOff){
                settings.flashMode = .on
            }
            else{
                settings.flashMode = .off
            }
        }
        return settings
    }
    
    func addVideoInput(position: AVCaptureDevice.Position) {
        guard let device: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                                    for: .video, position: position) else { return }
        if let currentInput = self.deviceInput {
            self.captureSession.removeInput(currentInput)
            self.deviceInput = nil
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if self.captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
                self.deviceInput = input
            }
        } catch {
            print(error)
        }
    }
}
