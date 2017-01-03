//
//  Dictionary.swift
//  RxStreamPlayer
//
//  Created by Anton Efimenko on 03.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

extension Dictionary {
	init(_ elements: [Element]){
		self.init()
		for (k, v) in elements {
			self[k] = v
		}
	}
}
