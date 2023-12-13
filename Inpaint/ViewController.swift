//
//  ViewController.swift
//  Inpaint
//
//  Created by wudijimao on 2023/11/30.
//

import UIKit
import Vision
import SnapKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var selectImageBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("选择图片", for: .normal)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        return btn
    }()

    // UIScrollView实例
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        view.addSubview(selectImageBtn)
        setupScrollView()
        setupSelectImageButton()
    }

    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(selectImageBtn.snp.top).offset(-20)
        }

        let images = [("1", "1b"), ("2", "2b"), ("3", "3b")]
        var previousSplitImageView: SplitImageView?

        for imagePair in images {
            let splitImageView = SplitImageView(imageA: UIImage(named: imagePair.0),
                                                imageB: UIImage(named: imagePair.1))
            scrollView.addSubview(splitImageView)

            splitImageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(scrollView.snp.height)
                
                if let previous = previousSplitImageView {
                    make.top.equalTo(previous.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }
            }

            previousSplitImageView = splitImageView
        }

        if let lastImageView = previousSplitImageView {
            lastImageView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
            }
        }
    }

    private func setupSelectImageButton() {
        selectImageBtn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }

    
    @objc func onClick() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // You can handle the selected image here
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: {
            let vc = InpaintingViewController()
            vc.imageView.image = image
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}







