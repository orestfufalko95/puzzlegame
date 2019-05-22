//
// Created by Orest Fufalko on 2019-04-27.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PuzzleCollectionViewFlowLayout: UICollectionViewFlowLayout {

	private weak var delegate: PuzzleFlowLayoutDelegate?

	init(delegate: PuzzleFlowLayoutDelegate) {
		self.delegate = delegate

		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		self.delegate = nil

		super.init(coder: aDecoder)
	}

	override func prepare() {
		super.prepare()

		guard let collectionView = collectionView else {
			return
		}

		let inset: CGRect = collectionView.bounds.inset(by: collectionView.layoutMargins)
		let size = CGFloat(self.delegate?.gridSize ?? 1)
		let cellWidth = (inset.width / size).rounded(.down)
		let cellHeight = (inset.height / size).rounded(.down)

		self.itemSize = CGSize(width: cellWidth, height: cellHeight)
		self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
		self.minimumInteritemSpacing = 0
		self.sectionInsetReference = .fromSafeArea

	}
}
