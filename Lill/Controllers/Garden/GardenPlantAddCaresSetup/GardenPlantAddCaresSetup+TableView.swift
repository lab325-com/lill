
import Foundation
import UIKit

//----------------------------------------------
// MARK: - UITableViewDataSource, UITableViewDelegate
//----------------------------------------------

extension GardenPlantAddCaresSetup: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cares.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.row {
//        case cares.count + 1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellAddCareIdentifier) as? AddCareCell else { return UITableViewCell() }
//            cell.delegate = self
//            cell.setupCell()
//
//            return cell
//        default:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellCareIdentifier) as? CareCell else { return UITableViewCell() }
//            cell.delegate = self
//            if let caresModel = cares[safe: indexPath.row - 1] {
//                cell.setupCell(caresModel: caresModel)
//            }
//
//            return cell
//        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
