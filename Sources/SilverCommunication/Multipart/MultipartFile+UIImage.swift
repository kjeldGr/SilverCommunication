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
        contentType: ContentType,
        name: String = UUID().uuidString
    ) {
        let data: Data
        switch contentType {
        case .png, .custom("image/png", _):
            guard let pngData = image.pngData() else {
                return nil
            }
            data = pngData
        case let .jpeg(bytes?):
            guard let jpegData = image.compress(to: bytes) else {
                return nil
            }
            data = jpegData
        case .jpeg(.none), .custom("image/jpeg", _):
            guard let jpegData = image.jpegData(compressionQuality: 1) else {
                return nil
            }
            data = jpegData
        default:
            return nil
        }
        self.init(
            data: data,
            name: name,
            contentType: contentType
        )
    }
}
#endif
