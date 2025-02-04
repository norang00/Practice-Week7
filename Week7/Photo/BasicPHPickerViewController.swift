//
//  BasicPHPickerViewController.swift
//  Week7
//
//  Created by Kyuhee hong on 2/4/25.
//

import UIKit
import PhotosUI // PHPicker

class BasicPHPickerViewController: UIViewController {

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
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 사진만 가지고 오고 싶을 때 images 지정, .any(of: [.screenshots, .images]) -> 여러 종류를 선택하고 싶을 때는 이렇게
        configuration.selectionLimit = 3
        configuration.mode = .default
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

}

extension BasicPHPickerViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function, Thread.isMainThread)
        
        // itemProvider 를 통해 선택한 사진을 불러오기
        if let itemProvider = results.first?.itemProvider {
            print("1", Thread.isMainThread)

            // 고른 사진이 그 사이에 삭제되거나 할 수 있기 때문에 정말 불러올 수 있는지 확인하는 과정이 필요
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                print("2", Thread.isMainThread)

                // 불러올 수 있는 사진인 것이 확인되면 불러오기
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    print("3", Thread.isMainThread) // -> false, 여기서 global() 큐로 돌아간다. 사진은 괜찮은데, 영상 등의 자료를 가지고 온다거나 할 때 영향이 있을 수 있기 때문에

                    DispatchQueue.main.async {
                        self.photoImageView.image = image as? UIImage
                    }
                }
            }
            
        }
        dismiss(animated: true)
    }

}
