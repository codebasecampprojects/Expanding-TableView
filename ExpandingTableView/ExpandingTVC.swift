//
//  ExpandingTVC.swift
//  ExpandingTableView
//
//  Created by Thomas Walker on 04/12/2016.
//  Copyright © 2016 CodeBaseCamp. All rights reserved.
//

import Foundation
import UIKit

class ExpandingTVC : UITableViewController {
    
    var destinationData: [DestinationData?]?
    
    override func viewDidLoad() {
        destinationData = getData()
        
        //self.automaticallyAdjustsScrollViewInsets = false;
        //tableView.estimatedRowHeight = 142;
        //self.tableView.setNeedsLayout()
        //self.tableView.layoutIfNeeded()
        //tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    private func getData() -> [DestinationData?] {
        let data: [DestinationData?] = []
        
        let sanFranciscoFlights = [FlightData(start: "MAN", end: "CFO")]
        let sanFrancisco = DestinationData(name: "San Francisco", price: "£425", imageName: "san_francisco-banner", flights: sanFranciscoFlights)
        
        let londonFlights = [FlightData(start: "MAN", end: "LHR"), FlightData(start: "MAN", end: "LCY")]
        let london = DestinationData(name: "London", price: "£500", imageName: "london-banner", flights: londonFlights)
        
        let newYorkFlights = [FlightData(start: "MAN", end: "JFK")]
        let newYork = DestinationData(name: "New York", price: "£630", imageName: "new_york-banner", flights: newYorkFlights)
        
        return [sanFrancisco, london, newYork]
    }
    
    /*  Number of Rows  */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = destinationData {
            return data.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let rowData = destinationData?[indexPath.row] {
            return 142
        } else {
            return 75
        }
    }
    
    /*  Create Cells    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Row is DefaultCell
        if let rowData = destinationData?[indexPath.row] {
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultCell
            defaultCell.DestinationLabel.text = rowData.name
            defaultCell.PriceLabel.text = rowData.price
            defaultCell.backgroundView = UIImageView(image: UIImage(named: rowData.imageName))
            defaultCell.selectionStyle = .none
            return defaultCell
        }
        // Row is ExpansionCell
        else {
            if let rowData = destinationData?[getParentCellIndex(expansionIndex: indexPath.row)] {
                //  Create an ExpansionCell
                let expansionCell = tableView.dequeueReusableCell(withIdentifier: "ExpansionCell", for: indexPath) as! ExpansionCell
                    
                //  Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                    
                //  Get the index of the flight data (e.g. if there are multiple ExpansionCells
                let flightIndex = indexPath.row - parentCellIndex - 1
                    
                //  Set the cell's data
                expansionCell.StartLabel.text = rowData.flights?[flightIndex].start
                expansionCell.EndLabel.text = rowData.flights?[flightIndex].end
                expansionCell.selectionStyle = .none
                return expansionCell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = destinationData?[indexPath.row] {
            
            // If user clicked last cell, do not try to access cell+1 (out of range)
            if(indexPath.row + 1 >= (destinationData?.count)!) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                // If next cell is not nil, then cell is not expanded
                if(destinationData?[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                // Close Cell (remove ExpansionCells)
                } else {
                    contractCell(tableView: tableView, index: indexPath.row)

                }
            }
        }
    }
    
    /*  Expand cell at given index  */
    private func expandCell(tableView: UITableView, index: Int) {
        // Expand Cell (add ExpansionCells
        if let flights = destinationData?[index]?.flights {
            for i in 1...flights.count {
                destinationData?.insert(nil, at: index + i)
                tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    /*  Contract cell at given index    */
    private func contractCell(tableView: UITableView, index: Int) {
        if let flights = destinationData?[index]?.flights {
            for i in 1...flights.count {
                destinationData?.remove(at: index+1)
                tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)

            }
        }
    }
    
    /*  Get parent cell index for selected ExpansionCell  */
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: DestinationData?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = destinationData?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
}











