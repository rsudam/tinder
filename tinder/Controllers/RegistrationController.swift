//
//  RegristrationViewController.swift
//  tinder
//
//  Created by Raghu Sairam on 24/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


class RegistrationController: UIViewController {
    
    //MARK:- fileprivate instance variables
    fileprivate let topColor = #colorLiteral(red: 0.9804053903, green: 0.3804147542, blue: 0.3686065674, alpha: 1)
    fileprivate let bottomColor = #colorLiteral(red: 0.8941414952, green: 0.1059144512, blue: 0.46270293, alpha: 1)
    fileprivate let registerButtonEnableColor = #colorLiteral(red: 0.8157079816, green: 0.09805912524, blue: 0.3333103657, alpha: 1)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let registrationViewModel = RegistrationViewModel()
    fileprivate let showRegisterHUD = JGProgressHUD(style: .dark)
    
    let selectPhotoButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = false
        button.setTitleColor(.darkGray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView:UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
                fullNameTextField,
                emailTextField,
                passwordTextField,
                registerButton
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overAllStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
    ])

    
    //MARK:- override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationObserver()
        setTapGesture()
        setupRegistrationFormValidationObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overAllStackView.axis = .horizontal
            selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        } else {
            overAllStackView.axis = .vertical
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK:- fileprivate methods
    
    fileprivate func setupGradientLayer() {
        
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupLayout() {

        overAllStackView.spacing = 8
        overAllStackView.axis = .vertical
        
        view.addSubview(overAllStackView)
        overAllStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overAllStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue  else {
            return
        }
        let keyboardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - overAllStackView.frame.origin.y - overAllStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    
    @objc func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    fileprivate func setTapGesture() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc func handleTapDismiss() {
        self.view.endEditing(true)
    }

    
    @objc fileprivate func handleTextChange(textfield: UITextField){
        if textfield == fullNameTextField {
            registrationViewModel.fullName = textfield.text
        } else if textfield == emailTextField {
            registrationViewModel.email = textfield.text
        } else {
            registrationViewModel.password = textfield.text
        }
        
    }
    
    fileprivate func setupRegistrationFormValidationObserver() {

        registrationViewModel.bindableIsFormValidation.bind { (isFormValid) in
            
            guard let isFormValid = isFormValid else { return }
            
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.backgroundColor = self.registerButtonEnableColor
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = .gray
                self.registerButton.setTitleColor(.darkGray, for: .disabled)
            }
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
            guard let image = image else {return}
            self.selectPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }

    }

    
    
    
    @objc fileprivate func handleRegister(){
        self.handleTapDismiss()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        showRegisterHUD.textLabel.text = "Registering..."
        showRegisterHUD.show(in: self.view)
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print(err.localizedDescription)
                self.showHUDWithError(error: err)
                return
            }
            print("succesfully created user account", res?.user.uid ?? "")
            let fileName = UUID().uuidString
            let imageData = self.registrationViewModel.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            
            ref.putData(imageData, metadata: nil, completion: { (metaData, err) in
                if let err = err {
                    self.showHUDWithError(error: err)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        self.showHUDWithError(error: err)
                        return
                    }
                    
                    print("absoluteString:",url?.absoluteString ?? "unable to get the path of the file")
                    self.showRegisterHUD.dismiss()
                })
                
            })
            
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        showRegisterHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration..."
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
        
    }
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}
