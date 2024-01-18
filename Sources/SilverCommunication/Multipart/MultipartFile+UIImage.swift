//
//  MultipartFile+UIImage.swift
//  
//
//  Created by Kjeld Groot on 30/11/2023.
//

#if os(iOS)
import UIKit

public extension MultipartFile {
    enum ImageType {
        case png
        case jpeg
    }
    
    init?(
        image: UIImage,
        preferredImageType: ImageType = .png,
        name: String = UUID().uuidString
    ) {
        let data: Data
        let type: String
        let fileExtension: String
        
        if let imageData = image.pngData(), preferredImageType == .png {
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
}
#endif
