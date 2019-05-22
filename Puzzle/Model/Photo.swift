//
// Created by Orest Fufalko on 2019-04-06.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class Photo {

	let image: UIImage!
	let itemId: Int!

	var puzzleTime: Int = 0

	init(image: UIImage, id: Int) {
		self.image = image
		self.itemId = id
	}
}