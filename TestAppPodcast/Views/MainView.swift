//
//  MainView.swift
//  TestAppPodcast
//
//  Created by Reynaldi Wijaya on 27/07/20.
//  Copyright © 2020 Reynaldi Wijaya. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(inputImage)
        inputImage.addSubview(label)
        self.addSubview(mergeButton)
        self.addSubview(outputImage)
        
        setupImageConstraint()
        setupLabelConstraint()
        setupMergeButtonConstraint()
        setupOutputImageConstraint()
    }
    
    lazy var inputImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "test")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = """
        Nanad Cepet Sembuh Ya
        Salam hangat 😊
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mergeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Merge into image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var outputImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func setupImageConstraint() {
        inputImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        inputImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        inputImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        inputImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupLabelConstraint() {
        label.centerXAnchor.constraint(equalTo: inputImage.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: inputImage.centerYAnchor).isActive = true
    }
    
    private func setupMergeButtonConstraint() {
        mergeButton.topAnchor.constraint(equalTo: inputImage.bottomAnchor, constant: 20).isActive = true
        mergeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mergeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupOutputImageConstraint() {
        outputImage.topAnchor.constraint(equalTo: mergeButton.bottomAnchor, constant: 20).isActive = true
        outputImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        outputImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        outputImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

