//
// Created by Orest Fufalko on 2019-04-08.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleViewController: UIViewController {

	@IBOutlet private weak var collectionView: UICollectionView!

	var output: PhotoPuzzleViewControllerOutput?

}

extension PhotoPuzzleViewController: PhotoPuzzleViewControllerInput {

}

extension PhotoPuzzleViewController: UICollectionViewDataSource {


}
