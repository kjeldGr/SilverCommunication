//
//  UIImage+Compression.swift
//
//
//  Created by Kjeld Groot on 19/01/2024.
//

#if os(iOS)
import UIKit

public extension UIImage {
    func compress(to bytes: Int) -> Data? {
        guard let data = jpegData(compressionQuality: 1) else {
            return nil
        }
        let compressionQuality = CGFloat(bytes) / CGFloat(data.count)
        if compressionQuality >= 1 {
            return data
        } else if compressionQuality <= 0 {
            return nil
        } else {
            return jpegData(compressionQuality: compressionQuality)
        }
    }
}
#endif
