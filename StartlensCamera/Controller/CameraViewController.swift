//
//  CameraViewController.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/26.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import VideoToolbox


class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var picturePreview: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var numberTitle: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var circularProgress: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    
    var postExhibit: PostExhibit?
    var token = String()
    var captureSession = AVCaptureSession()
    var mainCamera: AVCaptureDevice?
    var innerCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else {
            // if cannot get a token, move to login screen
            let logInViewController = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
            present(logInViewController, animated: true, completion: nil)
            return
        }
        token = savedToken

        setupUI()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        circularProgress.isHidden = true
        sendButton.setTitle("sendText".localized, for: .normal)
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 30.0
        numberTitle.text = "numberTitleText".localized
        number.text = "0"
    }
    
    // Camera image quality settings
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        if postExhibit?.imageFile.count != 0 {
            postData()
        } else {
            errorMessage.text = "noPictureErrorText".localized
        }
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        // Output ROW data
        let pixelFormatType = kCVPixelFormatType_32BGRA
        guard (self.photoOutput?.availablePhotoPixelFormatTypes.contains(pixelFormatType))! else {return}
        let settings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String : pixelFormatType])
          
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        // handle a taken picture
        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    // Capture device settings
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        // Get camera devices that meet the property conditions
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        // Set camera position at activating
        currentDevice = mainCamera
    }
    
    // Input and Output settings
    func setupInputOutput() {
        do {
            // Initialize input device data
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            // photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    // Preview layer settings
    func setupPreviewLayer() {
        // Initialize preview layer
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = self.drawView.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 2)
    }
    
    func postData() {
        startPost()

        let exhibitUrl = Constants.baseURL + Constants.exhibitURL
        // Parameter setting
        let data = try! postExhibit?.asDictionary()
        print("data: \(data!)")
        // TODO: 辞書形式の変更
        // {"exhibit": {"lang": "", "name": "", "description": "", imageFile: []}}
        let parameters = ["exhibit": data as Any] as [String : Any]

        let headers: HTTPHeaders = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        // Post Picture data
        AF.request(exhibitUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in

            switch response.result {
            case .success:
                self.finishPost()
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.finishPost()
                print(error)
                DispatchQueue.main.async {
                    self.errorMessage.text = "pictureErrorText".localized
                }
            }
        }
    }
    
    func startPost() {
        circularProgress.isHidden = false
        circularProgress.startAnimating()
        sendButton.isEnabled = false
        cameraButton.isEnabled = false
    }
    
    func finishPost() {
        circularProgress.isHidden = true
        circularProgress.stopAnimating()
        sendButton.isEnabled = true
        cameraButton.isEnabled = true
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    // delegate method that called when picture is taken
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("avcapturePhotoCaptureDelegate is called")
        if let imageData = photo.pixelBuffer {
            // Set picture preview
            let uiImage = UIImage(pixelBuffer: imageData)?.rotatedBy(degree: 90)
            picturePreview.image = uiImage
            // Save base64 encoded image to post API server
            let jpgImage = (uiImage?.jpegData(compressionQuality: 0.8)!)! as NSData
            let base64String = jpgImage.base64EncodedString()
            // print("base64String: \(base64String)")
            postExhibit?.setImageFile(image: "data:image/jpeg;base64," + base64String)
            print("postExhibit: \(postExhibit)")
            number.text = String(postExhibit!.imageFile.count)
        }
    }
}

extension UIImage {
    // Convert from type of CVPixelBuffer to UIImage through CGImage in order to render a picture
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    // Rotate UIImage by designated degree
    func rotatedBy(degree: CGFloat) -> UIImage {
        let radian = -degree * CGFloat.pi / 180
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: self.size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
    }
}
