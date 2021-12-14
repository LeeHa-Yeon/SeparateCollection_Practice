//
//  PhotoViewController.swift
//  SeparateCollection-Practice
//
//  Created by 이하연 on 2021/12/15.
//

import UIKit
import SnapKit
import Then
import Alamofire

let apiKey: String = "cPs6pJefrpTBaBSaw8K2rL3a"

class PhotoViewController: UIViewController {
    
    lazy var photoImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var photoButton = UIButton(frame: .zero).then {
        let image = #imageLiteral(resourceName: "cameraBtn")
        $0.setImage(image, for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
        
    }
    lazy var removeButton = UIButton(frame: .zero).then {
        let image = #imageLiteral(resourceName: "xBtn")
        $0.setImage(image, for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(removeBgPhoto), for: .touchUpInside)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        view.addSubview(photoImageView)
        view.addSubview(photoButton)
        view.addSubview(removeButton)
        view.subviews.forEach { view in view.translatesAutoresizingMaskIntoConstraints = false
            view.sizeToFit()
        }
        
        photoImageView.snp.makeConstraints{
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        photoButton.snp.makeConstraints{
            $0.width.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(photoImageView.snp.bottom).offset(20)
        }
        
        removeButton.snp.makeConstraints{
            $0.width.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(photoButton.snp.bottom).offset(20)
        }
        
    }
    
    @objc func uploadPhoto() {
        photoImageView.backgroundColor = .clear
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func removeBgPhoto() {
        guard let jpgData = self.photoImageView.image?.jpegData(compressionQuality: 0.8) else { return }
        
        AF.upload(
            multipartFormData: { builder in
                builder.append(
                    jpgData,
                    withName: "image_file",
                    fileName: "file.jpg",
                    mimeType: "image/jpeg"
                )
            },
            to: URL(string: "https://api.remove.bg/v1.0/removebg")!,
            headers: [
                "X-Api-Key": apiKey
            ]
        ).responseJSON { json in
            if let imageData = json.data {
                guard let img = UIImage(data: imageData) else {
                    print("실패")
                    return
                }
                self.photoImageView.image = img
            }
        }
    }
    
    
}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { dismiss(animated: true, completion: nil)
    }
}
