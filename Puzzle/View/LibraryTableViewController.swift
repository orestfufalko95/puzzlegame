//
//  LibraryTableViewController.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

	private var presenter: PhotoLibraryPresenter?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.presenter = PhotoLibraryPresenter(model: PhotoLibraryModel())

//        self.tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.presenter?.attachView(view: self)
		tableView.rowHeight = UITableView.automaticDimension
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		self.presenter?.detachView()
	}
}

// MARK: - Library View methods
extension LibraryTableViewController: LibraryView {

	func showProgress(message: String) {

	}

	func hideProgress() {

	}
}

// MARK: - Table view data source
extension LibraryTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 29
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: GaleryPhotoCell.identifier, for: indexPath)
		print("start cellForRowAt timestamp: \(Date().timeIntervalSince1970) index: \(indexPath.row)")
		// Configure the cell...
		self.presenter?.load(index: indexPath.row, completion: { [weak cell] image in
			if let newCell = cell as? GaleryPhotoCell, let newImage = image {
				print("end cellForRowAt timestamp: \(Date().timeIntervalSince1970) index: \(indexPath.row)")
				if !(self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? true) {
					return
				}

				newCell.photo?.image = newImage
			}
		})

		return cell
	}


	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	*/

	/*
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
	*/

	/*
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

	}
	*/

	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the item to be re-orderable.
		return true
	}
	*/

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}
