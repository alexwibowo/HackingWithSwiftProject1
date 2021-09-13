//
//  ImageMetadata.swift
//  HwSwiftProj1
//
//  Created by Alex Wibowo on 13/9/21.
//

import Foundation


struct ImageMetadata: Codable {
    var fileName: String
    var clickCount: Int
    
    
    mutating func incrementCount(){
        self.clickCount += 1
    }
  
}
