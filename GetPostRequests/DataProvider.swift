//
//  DataProvider.swift
//  GetPostRequests
//
//  Created by Егор Шкарин on 18.06.2021.
//

import UIKit

class DataProvider: NSObject {
    
    private var downloadTask: URLSessionDownloadTask!
    var fileLocation: ((URL) -> ())?
    var onProgress: ((Double) -> ())?
    private lazy var bgSession: URLSession = {
        // Определяет поведение нашей сессии при загрузке данных (в background нужно присвоить бандл своего приложения
        let config = URLSessionConfiguration.background(withIdentifier: "Shkarin.GetPostRequests")
        // Определяет могут ли фоновые задачи быть запланированы по усмотрению системы для улучшения производительности (рекомендовано true)
        //config.isDiscretionary = true
        // Это означает что при завершении загрузки наше приложение запустится в фоновом режиме
        config.sessionSendsLaunchEvents = true
        
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload() {
        // создаем экземпляр класса url
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            // Создаем экземпляр URLSession, метод downloadTask копирует предаставленные параметры конфигурации и назтраивает с учетом них сессию
            downloadTask = bgSession.downloadTask(with: url)
            // earliestBeginDate гарантирует что загрузка начнется не раннее заранее заданного времени (в слеж строчке к примеру есть гарантия что загрузка начнется не раннее чем через 3 секудны после создания сессии
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            // Определяет наиболее вероятную верхнюю границу числа байтов котрое клиент ожтиет отправить
            downloadTask.countOfBytesClientExpectsToSend = 512
            // Определяет наиболее вероятную верхнюю границу числа байтов котрое клиент ожтиет получить
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
     
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension DataProvider: URLSessionDelegate {
    // Этот метод вызывает по завершении всех фоновых задач связанных с нашем идентификатором приложения
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                //
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                
                let competionHandler = appDelegate.bgSessionCompletionHandler
            else {return}
            
            appDelegate.bgSessionCompletionHandler = nil
            competionHandler()
            
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    // значение параметра location возвращает адрес директории куда файл загрузился
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finished dowloading \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
   
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        let progress = Double(totalBytesWritten / totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
    
}
