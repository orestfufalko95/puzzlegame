//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//
import UIKit

final class PhotoPuzzlePresenter {

	private weak var view: (UIViewController & PhotoPuzzleViewControllerInput)?

	var model: PhotoPuzzleModelInput?

	init(view: (UIViewController & PhotoPuzzleViewControllerInput)) {
		self.view = view
	}
}

extension PhotoPuzzlePresenter: PhotoPuzzleModelOutput {

}

extension PhotoPuzzlePresenter: PhotoPuzzleViewControllerOutput {

}
