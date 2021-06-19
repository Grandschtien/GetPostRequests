//
//  NetworkManager.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 18.06.2021.
//
import UIKit

class NetworkManager {
    static func getRequest(url: String) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response,
                  let data = data
            else { return }
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                
            }
        }.resume()
    }
    // Для пост запроса пример
    static func postRequest(url: String) {
        guard let url = URL(string: url) else { return }
        
        let userData = ["Course": "Networking", "lesson": "GET and POST requests"]
        // Этот класс отвечает за запрос на сервер
        var request = URLRequest(url: url)
        // httpMethod отвечает дает понять с каким методом (гет пост или еще какеи либо) мы отсылаем запрос
        request.httpMethod = "POST"
        // Сериализуем джейсон в дату (это будет тело запроса)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        // Создаем тело запроса
        request.httpBody = httpBody
        // ДОбавляем необходимы заголовки, чтобы корректно улетал джейсон
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Создаем сессию
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    static func dowloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } 
        }.resume()
    }
    
    static func fetchData(url: String, completion: @escaping ([Course])->()){
      
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    completion(courses)
                }
            }catch let error{
                print("Error serialization json", error)
            }
        }.resume()
    }
}
