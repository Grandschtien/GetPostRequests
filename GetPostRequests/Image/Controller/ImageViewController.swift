//
//  ImageViewController.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 16.06.2021.
//

import UIKit
import Alamofire
class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    private let url = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    // Пример загрузки картинки
    func fetchImage() {
    
        NetworkManager.dowloadImage(url: url) {[weak self] image in
                self?.completeLabel.isHidden = true
                self?.progressView.isHidden = true
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
                self?.imageView.contentMode = .scaleAspectFill
        }
    }
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkRequest.downloadImage(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
            }
        }
        
    }
    
    func dowloadImageWithProgress() {
        AlamofireNetworkRequest.onProgress = { [weak self] progress in
            self?.progressView.isHidden = false
            self?.progressView.progress = Float(progress)
            
        }
        AlamofireNetworkRequest.completed = { [weak self] completed in
            self?.completeLabel.isHidden = false
            self?.completeLabel.text = completed
        }
        AlamofireNetworkRequest.downloadLargeImage(url: largeImageUrl) {[weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
            self?.imageView.contentMode = .scaleAspectFill
            self?.completeLabel.isHidden = true
            self?.activityIndicator.isHidden = true
            self?.progressView.isHidden = true
        }
    }
}
