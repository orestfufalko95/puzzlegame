//
//  LibraryTableViewController.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

	var output: LibraryTableViewControllerOutput?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.output?.handleViewCreated()

		self.tableView.prefetchDataSource = self
	}
}

// MARK: -  View Input methods
extension LibraryTableViewController: LibraryTableViewControllerInput {
	func handleImagesUpdated() {
		self.tableView.reloadData()
	}
}

// MARK: - Table view data source prefetching
extension LibraryTableViewController: UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		let maxRow: Int = indexPaths.reduce(0, ({ return $0 > $1.row ? $0 : $1.row }))
		print("prefetchRowsAt index: \(maxRow)")

		self.output?.prefetchIndex(index: maxRow)
	}
}

// MARK: - Table view data source
extension LibraryTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.output?.itemsCount ?? 0
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		print("start cellForRowAt timestamp: \(Date().timeIntervalSince1970) index: \(indexPath.row)")

		let cell = tableView.dequeueReusableCell(withIdentifier: GaleryPhotoCell.identifier, for: indexPath)
		if let newCell = cell as? GaleryPhotoCell {
			newCell.photo?.image = self.output?.photo(index: indexPath.row).image
		}

		return cell
	}

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/
}
