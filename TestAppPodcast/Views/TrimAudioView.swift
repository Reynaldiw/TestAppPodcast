//
//  TrimAudioView.swift
//  TestAppPodcast
//
//  Created by Reynaldi Wijaya on 27/07/20.
//  Copyright © 2020 Reynaldi Wijaya. All rights reserved.
//

import UIKit

class TrimAudioView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    fileprivate func  setupViews() {
        self.addSubview(labelDuration)
        self.addSubview(startTimeInputTF)
        self.addSubview(endTimeInputTF)
        self.addSubview(renderButton)
        self.addSubview(labelNewDuration)
    }
    
    fileprivate func setupConstraints() {
        setupDurationLabelConstraint()
        setupStartTimeTFConstraint()
        setupEndTimeTFConstraint()
        setupRenderButtonConstraint()
        setupDurationNewLabelConstraint()
    }
    
    lazy var labelDuration: UILabel = {
        let label = UILabel()
        label.text = "Duration"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupDurationLabelConstraint() {
        labelDuration.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelDuration.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        labelDuration.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    lazy var startTimeInputTF: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.textColor = .black
        textField.tintColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate func setupStartTimeTFConstraint() {
        
        let name = "Start Time"
        
        let myMutableStringTitle = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range:NSRange(location:0,length:name.count))
        
        startTimeInputTF.attributedPlaceholder = myMutableStringTitle
        startTimeInputTF.layer.cornerRadius = 5
        startTimeInputTF.layer.borderColor = UIColor.black.cgColor
        startTimeInputTF.layer.borderWidth = 2
        
        startTimeInputTF.topAnchor.constraint(equalTo: labelDuration.bottomAnchor, constant: 20).isActive = true
        startTimeInputTF.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        startTimeInputTF.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    lazy var endTimeInputTF: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.textColor = .black
        textField.tintColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate func setupEndTimeTFConstraint() {
        
        let name = "End Time"
        
        let myMutableStringTitle = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range:NSRange(location:0,length:name.count))
        
        endTimeInputTF.attributedPlaceholder = myMutableStringTitle
        endTimeInputTF.layer.cornerRadius = 5
        endTimeInputTF.layer.borderColor = UIColor.black.cgColor
        endTimeInputTF.layer.borderWidth = 2
        
        endTimeInputTF.topAnchor.constraint(equalTo: startTimeInputTF.bottomAnchor, constant: 20).isActive = true
        endTimeInputTF.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        endTimeInputTF.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    lazy var renderButton: UIButton = {
        let button = UIButton()
        button.setTitle("RENDER AUDIO", for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate func setupRenderButtonConstraint() {
        renderButton.layer.cornerRadius = 8
        renderButton.topAnchor.constraint(equalTo: endTimeInputTF.bottomAnchor, constant: 20).isActive = true
        renderButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        renderButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        renderButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    lazy var labelNewDuration: UILabel = {
        let label = UILabel()
        label.text = "New Duration"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupDurationNewLabelConstraint() {
        labelNewDuration.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelNewDuration.topAnchor.constraint(equalTo: renderButton.topAnchor, constant: 40).isActive = true
        labelNewDuration.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
