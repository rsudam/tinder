//
//  SettingsController.swift
//  tinder
//
//  Created by Raghu Sairam on 03/08/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class CustomerImagePickerController: UIImagePickerController {
    var buttom: UIButton?
}

class SettingsController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- class variables
    lazy var image1Button = createButton(selector: #selector(handleImageSelector))
    lazy var image2Button = createButton(selector: #selector(handleImageSelector))
    lazy var image3Button = createButton(selector: #selector(handleImageSelector))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationItems()  {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    //MARK:- overloaded methods
    
    @objc func handleImageSelector(button: UIButton){
        let imagePickerController = CustomerImagePickerController()
        imagePickerController.buttom = button
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomerImagePickerController)?.buttom
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.addSubview(image1Button)
        let padding:CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
                image2Button,image3Button
            ])
        header.addSubview(stackView)
        stackView.spacing = padding
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    //MARK:- file private methods
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}
