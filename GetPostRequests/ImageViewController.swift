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
    private let url = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    // Пример загрузки картинки
    func fetchImage() {
        NetworkManager.dowloadImage(url: url) {[weak self] image in
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
                self?.imageView.contentMode = .scaleAspectFill
        }
    }
    func fetchDataWithAlamofire() {
        AF.request(url).responseData { [weak self] (responseData) in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
}
