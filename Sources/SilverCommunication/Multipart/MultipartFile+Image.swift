//
//  MultipartFile+UIImage.swift
//  
//
//  Created by Kjeld Groot on 30/11/2023.
//

#if os(iOS)
import UIKit

public extension MultipartFile {
    enum MultipartImageError: Error {
        case invalidData
        case invalidConfiguration(String)
    }
    
    init(
        image: UIImage,
        contentType: ContentType,
        compressToBytes: Int? = nil,
        name: String = UUID().uuidString
    ) throws {
        let data: Data
        switch (contentType, compressToBytes) {
        case (.png, .none), (.custom("image/png", _), .none):
            guard let pngData = image.pngData() else {
                throw MultipartImageError.invalidData
            }
            data = pngData
        case let (.jpeg, bytes?), let (.custom("image/jpeg", _), bytes?):
            guard let jpegData = image.compress(to: bytes) else {
                throw MultipartImageError.invalidData
            }
            data = jpegData
        case (.jpeg, .none), (.custom("image/jpeg", _), .none):
            guard let jpegData = image.jpegData(compressionQuality: 1) else {
                throw MultipartImageError.invalidData
            }
            data = jpegData
        case (.png, .some), (.custom("image/png", _), .none):
            throw MultipartImageError.invalidConfiguration("Image compression is only support for JPEG images")
        default:
            throw MultipartImageError.invalidConfiguration("Invalid image configuration for content type \(String(reflecting: contentType))")
        }
        self.init(
            data: data,
            contentType: contentType,
            name: name
        )
    }
    
    init(
        imageData: Data,
        contentType: ContentType,
        compressToBytes: Int? = nil,
        name: String = UUID().uuidString
    ) throws {
        guard let image = UIImage(data: imageData) else {
            throw MultipartImageError.invalidData
        }
        try self.init(image: image, contentType: contentType, compressToBytes: compressToBytes, name: name)
    }
}
#endif
