//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleCell: UICollectionViewCell {
	static let identifier = "PhotoPuzzleCell"

	@IBOutlet weak var photo: UIImageView?
    @IBOutlet weak var coordinateLabel: UILabel?

	override var isSelected: Bool {
		didSet {
			alpha = isSelected ? 0.5 : 1.0
		}
	}
}
