//
//  RecordAudio.swift
//  Pitch Perfect
//
//  Created by SAMUEL HAVARD on 3/5/15.
//  Copyright (c) 2015 SAMUEL HAVARD. All rights reserved.
//

import Foundation

class RecordAudio: NSObject{
    var filePathURL: NSURL!
    var title: String!
    
    init(path: NSURL!, title: String!) {
        self.filePathURL = path
        self.title = title
    }
}
