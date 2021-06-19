//
//  MainViewController.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 17.06.2021.
//

import UIKit
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

    // MARK: UICollectionViewDataSource

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
            print(action.rawValue)
        }
        
    }
    
}
