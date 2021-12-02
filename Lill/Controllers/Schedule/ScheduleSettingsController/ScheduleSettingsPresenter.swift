//
//  ScheduleSettingsPresenter.swift
//  Lill
//
//  Created by Andrey S on 29.11.2021.
//

import Foundation
import Apollo
import UIKit

//----------------------------------------------
// MARK: - Outputs Protocol
//----------------------------------------------

protocol ScheduleSettingsOutputProtocol: BaseController {
    func success()
    func failure(error: String)
}

//----------------------------------------------
// MARK: - Inputs Protocol
//----------------------------------------------

protocol ScheduleSettingsPresenterProtocol: AnyObject {
    init(view: ScheduleSettingsOutputProtocol)
    
    func setNotifications(cares: Bool,
                          waitingCares: Bool,
                          missedCares: Bool,
                          frequency: String,
                          secondChance: Bool,
                          secondChanceSendAfter: String,
                          groupNotifications: Bool,
                          groupNotificationsSendAt: String)
}

class ScheduleSettingsPresenter: ScheduleSettingsPresenterProtocol {

    private weak var view: ScheduleSettingsOutputProtocol?
    
    required init(view: ScheduleSettingsOutputProtocol) {
        self.view = view
    }
    
    func setNotifications(cares: Bool,
                          waitingCares: Bool,
                          missedCares: Bool,
                          frequency: String,
                          secondChance: Bool,
                          secondChanceSendAfter: String,
                          groupNotifications: Bool,
                          groupNotificationsSendAt: String) {
        view?.startLoader()
        
    
        let update = NotificationSettingsUpdateInput(cares: cares,
                                                     waitingCares: waitingCares,
                                                     missedCares: missedCares,
                                                     frequency:  "hours: \(1)",
                                                     secondChance: secondChance,
                                                     secondChanceSendAfter: "hours: \(1)",
                                                     groupNotifications: groupNotifications,
                                                     groupNotificationsSendAt: groupNotificationsSendAt)
        
        let mutation = NotificationSettingsUpdateMutation(record: update)
        let _ = Network.shared.mutation(model: NotificationSettingsUpdateModel.self, mutation, controller: view, successHandler: { [weak self] model in
            self?.view?.stopLoading()
            self?.view?.success()
        }, failureHandler: { [weak self] error in
            self?.view?.stopLoading()
            self?.view?.failure(error: error.localizedDescription)
        })
    }
}