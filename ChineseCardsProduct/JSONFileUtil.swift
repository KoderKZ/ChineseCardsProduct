//
//  JSONFileUtil.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/17/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation

class JSONFileUtil{
    static func readCourseFromFile(courseName:String) -> Course{
        let pathString = Bundle.main.path(forResource: "Class 1", ofType: "json")
        var course = Course(courseName: "", cards: NSMutableArray())
        if FileManager.default.fileExists(atPath: pathString!){
            let jsonData = NSData(contentsOfFile: pathString!)
            do{
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData! as Data, options: .mutableContainers) as! NSDictionary
                course = Course(courseName: jsonDict.object(forKey: "courseName") as! String, cards: jsonDict.object(forKey: "cards") as! NSMutableArray)
                return course
            }catch{
                //error
            }
        }
        return course
    }
    static func readGradeFromFile(gradeName:String) -> Grade{
        let pathString = Bundle.main.path(forResource: gradeName, ofType: "json")
        let writePath = URL(fileURLWithPath: pathString!)
        let jsonData = NSData(contentsOfFile: writePath.path)
        do{
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData! as Data, options: .mutableContainers) as! NSDictionary
            let grade = Grade(gradeName: jsonDict.object(forKey: "gradeName") as! String, classes: jsonDict.object(forKey: "classes") as! NSMutableArray)
            return grade
        }catch{
            //error
        }
        let grade = Grade(gradeName: "", classes: NSMutableArray())
        return grade
    }
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
