//
//  ImageDetailViewController.swift
//  HwSwiftProj1
//
//  Created by Alex Wibowo on 13/9/21.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var imageName: String?
    var displayTitle: String?
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = displayTitle
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        if let imageName = self.imageName {
            let image = UIImage(named: imageName)
            imageView.image = image
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))


    }
    
    @objc func share(){
        guard let  image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        
        let uac = UIActivityViewController(activityItems: [image], applicationActivities: [])
        uac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(uac, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
   

}
