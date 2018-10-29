//
//  DogPic.swift
//  App
//
//  Created by Steve Goodrich on 10/19/18.
//

import Foundation
import Vapor
import FluentSQLite 

final class DogPic:  SQLiteModel {
    var id: Int?
    
    init(id: Int? = nil, path: String, breed: String) {
        self.id = id
        m_path = path
        m_breed = breed
    }
    var m_path: String
    var m_breed: String
}

extension DogPic: Content {}
extension DogPic: Migration {}

func GetPics() -> [DogPic] {
    let workdir = URL(fileURLWithPath: DirectoryConfig.detect().workDir)
    let imageDir = workdir.appendingPathComponent("Public", isDirectory: true).appendingPathComponent("images", isDirectory:true).appendingPathComponent("doggos")

    let fm = FileManager.default;
    do {
        let imgs = try fm.contentsOfDirectory(at: imageDir, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
        return imgs.map{return DogPic(path: $0.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "" , breed: "Unknown")}
        
    } catch {
        return [];
    }
    
}

func SavePic(pic: Data) -> Bool {
    var result = false;
    let workdir = DirectoryConfig.detect().workDir
    let fname = UUID().uuidString
    let imagedir = workdir + "Public/images/doggos/\(fname).png"
    do {
        try pic.write(to: URL(fileURLWithPath: imagedir))
        result = true;
    } catch {
        
    }
    
    return result;
}
