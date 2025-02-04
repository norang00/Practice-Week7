//
//  ImagePickerViewController.swift
//  Week7
//
//  Created by Kyuhee hong on 2/4/25.
//

import UIKit
import SnapKit

class ImagePickerViewController: UIViewController {

    let photoImageView = UIImageView()
    let pickerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(photoImageView)
        view.addSubview(pickerButton)
        
        photoImageView.backgroundColor = .systemYellow
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(300)
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        pickerButton.backgroundColor = .systemTeal
        pickerButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        pickerButton.addTarget(self, action: #selector(pickerButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func pickerButtonTapped() {
        print(#function)
        // 갤러리에서 사진을 가지고 오든 촬영을 하든 그런 것들의 UI 를 제공
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // 여러가지 sourceType 을 사용할 수 있다.
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.sourceType = .camera
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true

        present(imagePicker, animated: true) // 권한 묻지 않고 사진 조회가 가능하다
    }
    
}

// PickerView 내부에서도 화면 이동이 있어서 NavigationController 기능도 함께 이용한다
extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 사진 골랐을 때
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        // 사진을 선택
        // originalImage 기준으로 가지고 오기
        let image = info[UIImagePickerController.InfoKey.originalImage]
        
        // edit 된 Image 를 가지고 오기
        let editImage = info[UIImagePickerController.InfoKey.editedImage]
        
        // 이미지 뷰에 이미지를 추가
        if let result = editImage as? UIImage {
            photoImageView.image = result
        } else {
            // result 가 UIImage 가 아닐때의 대응은 여기서 필요
        }
        
        // 작업 완료 후 picker dismiss 필요
        dismiss(animated: true)
    }
    
    // 취소 버튼 눌렀을 때 (delegate 연결 시 동작 위임이 되기 때문에 각각의 동작에 명시적으로 기능들을 정의해주어야 한다)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
}
