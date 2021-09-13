//
//  ViewController.swift
//  HwSwiftProj1
//
//  Created by Alex Wibowo on 13/9/21.
//

import UIKit

class ImageListViewController: UITableViewController {
    
    var images = [ImageMetadata]()

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
                
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let path = Bundle.main.resourcePath {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.loadImages(path: path)
            }
        }
    }
    
    func loadImages(path: String){
       
        
        let fileManager = FileManager.default
        if let files = try? fileManager.contentsOfDirectory(atPath: path) {
            do {
                // simulate slow loading
                sleep(3)
            }
            
            images = files.filter { fileName in
                fileName.starts(with: "nss")
            }.sorted().map { fileName in
                return ImageMetadata(fileName: fileName, clickCount: 0)
            }
            
            let userDefaults = UserDefaults.standard
            if let existingData = userDefaults.object(forKey: "images") as? Data {
                restoreMetadata(existingData)
            } else {
                let jsonEncoder = JSONEncoder()
                if let encoded = try? jsonEncoder.encode(images) {
                    userDefaults.setValue(encoded, forKey: "images")
                }
            }
         
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }
    
    func restoreMetadata(_ existingData: Data) {
        let decoder = JSONDecoder()
        if let decodedImages = try? decoder.decode([ImageMetadata].self, from: existingData) {
            for decodedMetadata in decodedImages {
                // find index in array, so that we can replace entry on that array
                let foundIndex = images.firstIndex { metadata in
                    metadata.fileName == decodedMetadata.fileName
                }
                
                if foundIndex != nil {
                    images[foundIndex!] = ImageMetadata(fileName: decodedMetadata.fileName, clickCount: decodedMetadata.clickCount)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
        imageCell.textLabel?.text = images[indexPath.row].fileName
        imageCell.detailTextLabel?.text = "Clicks: \(images[indexPath.row].clickCount)"
        return imageCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var imageMetadata = images[indexPath.row]
        imageMetadata.incrementCount()
        images[indexPath.row] = imageMetadata
        
        
        if let currentCell = tableView.cellForRow(at: indexPath) {
            currentCell.detailTextLabel?.text = "Clicks: \(imageMetadata.clickCount)"
        }
        
        
        let jsonEncoder = JSONEncoder()
        if let encoded = try? jsonEncoder.encode(images) {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(encoded, forKey: "images")
        }
        
        let imageDetailViewController = storyboard?.instantiateViewController(identifier: "ImageDetail") as! ImageDetailViewController         
        imageDetailViewController.imageName = imageMetadata.fileName
        imageDetailViewController.displayTitle = "Image \(indexPath.row + 1) of \(images.count)"
        
        navigationController?.pushViewController(imageDetailViewController, animated: true)
    }
    


}

