//
//  FileManager.swift
//  MySplashed
//
//  Created by user on 7/28/24.
//
import Foundation
import UIKit

extension FileManager {
    func saveImageToDocument(image: UIImage, filename: String) throws {
        // 1. document directory를 찾아가기
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
            .first else { return }
        
        //2. 이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //3. 이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //4. 이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            throw FileManagerError.fileSaveError
        }
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        var fileURLString: String
        if #available(iOS 16.0, *) {
            fileURLString =  fileURL.path()
        } else {
            fileURLString = fileURL.path
        }
        
        //이 경로에 실제로 파일이 존재하는 지 확인
        if FileManager.default.fileExists(atPath: fileURLString) {
            return UIImage(contentsOfFile: fileURLString)
        } else {
            return nil
        }
    }
    
    func removeImageFromDocument(filename: String) throws {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        var fileURLString: String
        if #available(iOS 16.0, *) {
            fileURLString =  fileURL.path()
        } else {
            fileURLString = fileURL.path
        }
        
        if FileManager.default.fileExists(atPath: fileURLString) {
            try FileManager.default.removeItem(atPath: fileURLString)
        } else {
            throw FileManagerError.noFileError
        }
    }
}

enum FileManagerError: Error {
    case noFileError
    case fileSaveError
}
