//
//  PostModel.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 27/06/17.
//  Copyright © 2017 BTS. All rights reserved.
//

class PostModel {
    
    var id: String?
    var image: String?
    var email: String?
    var storageUUID: String?
    var timestamp: String?
    var userUid: String?
    
    init(id: String?, image: String?, email: String?, storageUUID: String?, timestamp: String?, userUid: String?) {
        self.id = id;
        self.image = image;
        self.email = email;
        self.storageUUID = storageUUID;
        self.timestamp = timestamp;
        self.userUid = userUid;
    }
}
