//
//  OutputViewController.swift
//  segmentation_api
//
//  Created by M'haimdat omar on 21-05-2020.
//  Copyright © 2020 M'haimdat omar. All rights reserved.
//

import UIKit
import Alamofire

class OutputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var apiEntryPoint = ""
    
    var barTitle = ""
    
    lazy var outputImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var uploadBtn : MyButton = {
       let btn = MyButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonToUpload(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var cameraBtn : MyButton = {
       let btn = MyButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonToCamera(_:)), for: .touchUpInside)
        btn.setTitle("Take an image      ", for: .normal)
        let icon = UIImage(systemName: "camera")?.resized(newSize: CGSize(width: 45, height: 35))
        let finalIcon = icon?.withTintColor(#colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1))
        btn.setImage(finalIcon, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 100)
        btn.layoutIfNeeded()
        return btn
    }()
    
    lazy var dissmissButton : MyButton = {
       let btn = MyButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonToDissmiss(_:)), for: .touchUpInside)
        btn.setTitle("Dismiss", for: .normal)
        let icon = UIImage(systemName: "xmark.circle")?.resized(newSize: CGSize(width: 35, height: 35))
        let finalIcon = icon?.withTintColor(.systemBackground)
        btn.setImage(finalIcon, for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 100)
        btn.layer.borderColor = UIColor.systemBackground.cgColor
        btn.layoutIfNeeded()
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setupLayout()
        setupTabBar()
    }
    
    func setupTabBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = self.barTitle
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = .systemBackground
             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            self.navigationController?.navigationBar.barTintColor = .lightText
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        }
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.backgroundColor = .systemBackground
        } else {
            navigationController?.navigationBar.backgroundColor = .white
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addSubviews() {
       
        view.addSubview(outputImage)
        view.addSubview(uploadBtn)
        view.addSubview(cameraBtn)
        view.addSubview(dissmissButton)
    }
    
    func setupLayout() {
        
        outputImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outputImage.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        outputImage.bottomAnchor.constraint(equalTo: uploadBtn.topAnchor, constant: -50).isActive = true
        
        uploadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        uploadBtn.heightAnchor.constraint(equalToConstant: 65).isActive = true
        uploadBtn.bottomAnchor.constraint(equalTo: cameraBtn.topAnchor, constant: -30).isActive = true
        
        cameraBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        cameraBtn.heightAnchor.constraint(equalToConstant: 65).isActive = true
        cameraBtn.bottomAnchor.constraint(equalTo: dissmissButton.topAnchor, constant: -30).isActive = true
        
        dissmissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dissmissButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        dissmissButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        dissmissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // your chosen image
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        self.outputImage.image = pickedImage.resized(newSize: CGSize(width: 350, height: 350))
        
        self.outputImage.showSpinner()
        
        // convert the UIImage to base64 encoding
        let imageDataBase64 = pickedImage.jpegData(compressionQuality: 0.2)!.base64EncodedString(options: .lineLength64Characters)
        print(imageDataBase64)
        
        let parameters: Parameters = ["image": imageDataBase64]
        
        AF.request(URL.init(string: self.apiEntryPoint)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: .none).responseJSON { (response) in
        print(response.result)
            
        switch response.result {

            case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let base64StringOutput = JSON["output_image"] as! String
                        let newImageData = Data(base64Encoded: base64StringOutput)
                        if let newImageData = newImageData {
                           let outputImage = UIImage(data: newImageData)
                            let finalOutputImage = outputImage!.resized(newSize: CGSize(width: 350, height: 350))
                            self.outputImage.removeSpinner()
                            self.outputImage.image = finalOutputImage
                        }
                    }
                break
            case .failure(let error):
                print(error)
                break
            }
            
        }
    
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func buttonToUpload(_ sender: MyButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func buttonToCamera(_ sender: MyButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func buttonToDissmiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

var view: UIView?

extension UIImageView {
    
    func showSpinner() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        print(self.bounds)
        view!.backgroundColor = .clear
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = #colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1)
        spinner.center = view!.center
        spinner.startAnimating()
        view!.addSubview(spinner)
        self.addSubview(view!)
    }
    
    func removeSpinner() {
        view!.removeFromSuperview()
        view = nil
    }
}
