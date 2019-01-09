//
//  CourseStruct.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/17/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
public struct Course:JSONSerializable{
    var courseName:String
    var cards:NSMutableArray
}
public struct FlashCard:JSONSerializable{
    var chinese:String
    var english:String
    var pinyin:String
    var imageFileName:String
    var audioStartTime:Double
    var audioDuration:Double
}
public struct Grade:JSONSerializable{
    var gradeName:String
    var classes:NSMutableArray
}
