//
//  CoursesViewController.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 17.06.2021.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    private let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    private let putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchData() {
        NetworkManager.fetchData(url: url) {[weak self] courses in
            self?.courses = courses
            self?.tableView.reloadData()
        }
    }
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkRequest.sendRequest(url: url){ [weak self](courses) in
            self?.courses = courses
            self?.tableView.reloadData()
        }
    }
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
            
        }
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
        DispatchQueue.global().async {
            guard let imageUrl = course.imageUrl,
                  let imageURL = URL(string: (imageUrl)),
                  let dataImage = try? Data(contentsOf: imageURL)
            else {return}
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: dataImage)
            }
        }
       
    }
    func postRequest(){
        AlamofireNetworkRequest.postRequest(url: postRequestUrl) {[weak self] courses in
            self?.courses = courses
            DispatchQueue.main.async{
                self?.tableView.reloadData()
            }
        }
    }
    func putRequest() {
        AlamofireNetworkRequest.putRequest(url: putRequestUrl) {[weak self] courses in
            self?.courses = courses
            DispatchQueue.main.async{
                self?.tableView.reloadData()
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Description", let vc = segue.destination as? WebViewController else { return }
        vc.courseURL = courseURL ?? "https://swiftbook.ru"
        vc.selectedCourse = courseName
    }
    
}

extension CoursesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {return UITableViewCell()}
        
        configureCell(cell: cell, for: indexPath)
        return cell
    }
  
}

// MARK: Table View Delegate

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCourse = courses[indexPath.row]
        self.courseName = selectedCourse.name
        self.courseURL = selectedCourse.link
        
        performSegue(withIdentifier: "Description", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
