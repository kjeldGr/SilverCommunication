//
//  Bundle+DataParsing.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 03/06/2022.
//

import Foundation

extension Bundle {
    
    // MARK: - Data parsing
    
    func dataFromBundle(
        withName bundleName: String,
        forPath path: String,
        withExtension fileExtension: String
    ) throws -> Data {
        guard let bundleURL = url(forResource: bundleName, withExtension: "bundle"),
              let bundle = Bundle(url: bundleURL) else {
            throw FileError.fileNotFound("\(bundleName).bundle")
        }
        return try bundle.dataFromFile(withName: path, withExtension: fileExtension)
    }
    
    func dataFromFile(withName filename: String, withExtension fileExtension: String) throws -> Data {
        guard let url = url(forResource: filename, withExtension: fileExtension) else {
            throw FileError.fileNotFound("\(filename).\(fileExtension)")
        }
        guard let data = try? Data(contentsOf: url) else {
            throw FileError.fileNotFound(url.absoluteString)
        }
        return data
    }
}
