//
//  NewExhibitViewController.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/25.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import UIKit
import TextFieldEffects

class NewExhibitViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var exhibitNameText: UILabel!
    @IBOutlet weak var exhibitNameInput: HoshiTextField!
    @IBOutlet weak var exhibitDescriptionText: UILabel!
    @IBOutlet weak var exhibitDescriptionView: PlaceHolderedTextView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cancelButtonText: UIBarButtonItem!
    
    var postExhibit: PostExhibit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exhibitNameInput.delegate = self
        exhibitDescriptionView.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        cancelButtonText.title = "cancelText".localized
        exhibitNameText.text = "exhibitNameText".localized
        exhibitDescriptionText.text = "exhibitDescriptionText".localized
        exhibitDescriptionView.layer.borderColor = UIColor.lightGray.cgColor
        exhibitDescriptionView.layer.borderWidth = 1.0
        cameraButton.setTitle("cameraButtonText".localized, for: .normal)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if exhibitDescriptionView.isFirstResponder {
            exhibitDescriptionView.resignFirstResponder()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        exhibitDescriptionView.layer.borderColor = ThemeColor.main.cgColor
        exhibitDescriptionView.layer.borderWidth = 2.0
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        exhibitDescriptionView.layer.borderColor = UIColor.lightGray.cgColor
        exhibitDescriptionView.layer.borderWidth = 1.0
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        guard let exhibitName = exhibitNameInput.text, !exhibitName.isEmpty else {
            errorMessage.text = "exhibitNameError".localized
            errorMessage.textColor = ThemeColor.errorString
            return
        }
        
        guard let exhibitDescription = exhibitDescriptionView.text, !exhibitDescription.isEmpty else {
            errorMessage.text = "exhibitDescriptionError".localized
            errorMessage.textColor = ThemeColor.errorString
            return
        }
        
        postExhibit = PostExhibit(lang: "ja", name: exhibitName, description: exhibitDescription)
        performSegue(withIdentifier: "camera", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "camera":
            let cameraVC = segue.destination as! CameraViewController
            cameraVC.postExhibit = postExhibit
        default:
            break
        }
    }
    
}
