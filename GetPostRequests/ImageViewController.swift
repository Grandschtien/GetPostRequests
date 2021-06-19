//
//  ImageViewController.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 16.06.2021.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let url = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        
        fetchImage()
        // Do any additional setup after loading the view.
    }
    // Пример загрузки картинки
    func fetchImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        NetworkManager.dowloadImage(url: url) {[weak self] image in
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
                self?.imageView.contentMode = .scaleAspectFill
        }
    }

}
