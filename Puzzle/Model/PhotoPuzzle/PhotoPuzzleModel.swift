//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleModel {

	private var output: PhotoPuzzleModelOutput?

	init(presenter: PhotoPuzzleModelOutput) {
		self.output = presenter
	}
}

extension PhotoPuzzleModel: PhotoPuzzleModelInput {

}
