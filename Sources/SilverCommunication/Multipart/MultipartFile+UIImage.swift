//
//  MultipartFile+UIImage.swift
//  
//
//  Created by Kjeld Groot on 30/11/2023.
//

#if os(iOS)
import UIKit

public extension MultipartFile {    
    init?(
        image: UIImage,
        name: String = UUID().uuidString
    ) {
        let data: Data
        let type: String
        let fileExtension: String
        
        if let imageData = image.pngData() {
            data = imageData
            type = "image/png"
            fileExtension = "png"
        } else if let imageData = image.jpegData(compressionQuality: 1) {
            data = imageData
            type = "image/jpeg"
            fileExtension = "jpg"
        } else {
            return nil
        }
        self.init(data: data, type: type, name: name, fileExtension: fileExtension)
    }
    
    init?(
        imageData: Data,
        type: String,
        name: String = UUID().uuidString
    ) {
        guard let fileExtension = type.split(separator: "/").last.flatMap({ String($0) }) else {
            return nil
        }
        self.init(data: imageData, type: type, name: name, fileExtension: fileExtension)
    }
}
#endif
