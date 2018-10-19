//
//  DogPic.swift
//  App
//
//  Created by Steve Goodrich on 10/19/18.
//

import Foundation
import Vapor

struct DogPic: Codable {
    init(path: String, breed: String) {
        m_path = path;
        m_breed = breed;
    }
    var m_path: String;
    var m_breed: String;
}

func GetPics() -> [DogPic] {
    let workdir = DirectoryConfig.detect().workDir
    let imagedir = workdir + "Public/images/doggos"
    let fm = FileManager.default;
    do {
        let imgs = try fm.contentsOfDirectory(atPath: imagedir)
        return imgs.map{return DogPic(path: $0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "" , breed: "Unknown")}
        
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
