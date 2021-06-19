//
//  MainViewController.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 17.06.2021.
//

import UIKit
import UserNotifications
// Этот протокол дает возможность помещать все кейсы перечисления в массив
enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case donloadFile = "Download File"
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"



class MainViewController: UICollectionViewController {
    // соответсвенно метод для помещения кейсов
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private var dataProvider = DataProvider()
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        dataProvider.fileLocation = { [weak self] location in
            print(location)
            self?.filePath = location.absoluteString
            self?.alert.dismiss(animated: true, completion: nil)
            self?.postNotification()
        }
        
        
    }
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        let hieght = NSLayoutConstraint(item: alert.view!,
                                       attribute: .height,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 0,
                                       constant: 170)
        alert.view.addConstraint(hieght)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] action in
            self?.dataProvider.stopDownload()
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true) { [weak self] in
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: (self?.alert.view.frame.width)! / 2 - size.width / 2, y: (self?.alert.view.frame.height)! / 2 - size.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: (self?.alert.view.frame.height)! - 44, width: (self?.alert.view.frame.width)!, height: 2))
            
            progressView.tintColor = .blue
            self?.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self?.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self?.alert.view.addSubview(activityIndicator)
            self?.alert.view.addSubview(progressView)
            
        }
    }
    
    // MARK:- UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.label.text = actions[indexPath.row].rawValue
        
        return cell
    }
    
    // MARK: - Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            print("Image")
        case .donloadFile:
            showAlert()
            dataProvider.startDownload()
        }
        
    }
    
}

extension MainViewController {
    private func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            
        }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download comlete"
        content.body = "Your background transfer has completed. File path \(filePath ?? "Can't found directory")"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
