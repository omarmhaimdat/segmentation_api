//
//  ViewController.swift
//  segmentation_api
//
//  Created by M'haimdat omar on 21-05-2020.
//  Copyright © 2020 M'haimdat omar. All rights reserved.
//

import UIKit
import Alamofire

let screenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController {
    
    lazy var name: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "Avenir-Heavy", size: 35)
        text.text = "Segmentation API"
        text.textColor = #colorLiteral(red: 0.4980392157, green: 0.05882352941, blue: 0.07843137255, alpha: 1)
        return text
        
    }()
    
    lazy var logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "profile"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var semanticBtn : MyButton = {
       let btn = MyButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonToSemanticSegmentation(_:)), for: .touchUpInside)
        btn.setTitle("Semantic segmentation", for: .normal)
        let icon = UIImage(systemName: "map")?.resized(newSize: CGSize(width: 35, height: 35))
        let finalIcon = icon?.withTintColor(#colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1))
        btn.setImage(finalIcon, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 100)
        btn.layoutIfNeeded()
        return btn
    }()
    
    lazy var instanceBtn : MyButton = {
       let btn = MyButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonToInstanceSegmentation(_:)), for: .touchUpInside)
        btn.setTitle("Instance segmentation", for: .normal)
        let icon = UIImage(systemName: "map.fill")?.resized(newSize: CGSize(width: 45, height: 35))
        let finalIcon = icon?.withTintColor(#colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1))
        btn.setImage(finalIcon, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 100)
        btn.layoutIfNeeded()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addElementsToSubview()
        setupView()
    }
    
    fileprivate func addElementsToSubview() {
        view.addSubview(name)
        view.addSubview(logo)
        view.addSubview(semanticBtn)
        view.addSubview(instanceBtn)
    }
    
    fileprivate func setupView() {
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        instanceBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        instanceBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        instanceBtn.heightAnchor.constraint(equalToConstant: 65).isActive = true
        instanceBtn.bottomAnchor.constraint(equalTo: semanticBtn.topAnchor, constant: -40).isActive = true
        
        semanticBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        semanticBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        semanticBtn.heightAnchor.constraint(equalToConstant: 65).isActive = true
        semanticBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        name.heightAnchor.constraint(equalToConstant: 100).isActive = true
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        name.numberOfLines = 1
        
    }
    
    @objc func buttonToSemanticSegmentation(_ sender: MyButton) {
        let controller = OutputViewController()
        controller.apiEntryPoint = "http://127.0.0.1:5000/semantic"
        controller.barTitle = "Semantic"

        let navController = UINavigationController(rootViewController: controller)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func buttonToInstanceSegmentation(_ sender: MyButton) {
        let controller = OutputViewController()
        controller.apiEntryPoint = "http://127.0.0.1:5000/instance"
        controller.barTitle = "Instance"

        let navController = UINavigationController(rootViewController: controller)
        
        self.present(navController, animated: true, completion: nil)
    }


}

