
import UIKit

protocol GardenChooseAddPlantDelegate: AnyObject {
    func didPressedAddUniquePlant()
}

class GardenChooseAddPlantController: BaseController {
    
    //----------------------------------------------
    // MARK: - @IBOutlets
    //----------------------------------------------
    
    @IBOutlet weak var identifyShadowView: ShadowView!
    @IBOutlet weak var identifyGradientView: GradientView!
    @IBOutlet weak var identifyCountView: GradientView!
    @IBOutlet weak var catalogShadowView: ShadowView!
    
    @IBOutlet weak var identifyLabel: UILabel!
    @IBOutlet weak var catalogLabel: UILabel!
    @IBOutlet weak var addUniqueLabel: UILabel!
    @IBOutlet weak var identifyCountLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    //----------------------------------------------
    // MARK: - Global property
    //----------------------------------------------
    
    weak var delegate: GardenChooseAddPlantDelegate?

    //----------------------------------------------
    // MARK: - Life cycle
    //----------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //----------------------------------------------
    // MARK: - Private methods
    //----------------------------------------------
    
    func configureView() {
        identifyLabel.text = RLocalization.garden_choose_add_plant_identify.localized(PreferencesManager.sharedManager.languageCode.rawValue)
        catalogLabel.text = RLocalization.garden_choose_add_plant_catalog.localized(PreferencesManager.sharedManager.languageCode.rawValue)
        addUniqueLabel.text = RLocalization.garden_choose_add_plant_unique.localized(PreferencesManager.sharedManager.languageCode.rawValue)
        cancelButton.setTitle(RLocalization.garden_choose_add_plant_cancel.localized(PreferencesManager.sharedManager.languageCode.rawValue), for: .normal)
        
        guard let meModel = KeychainService.standard.me else { return }
        identifyCountView.isHidden = meModel.access.isPremium
        identifyCountLabel.text = "\(meModel.access.identifyUsed)" + "/" + "\(meModel.access.identifyTotal ?? 0)"
    }
    
    //----------------------------------------------
    // MARK: - @IBActions
    //----------------------------------------------
    
    @IBAction func identifyAction(_ sender: Any) {
        
        guard let meModel = KeychainService.standard.me else { return }
        
        dismiss(animated: false) {
            let currentNavigationController = RootRouter.sharedInstance.topViewController?.navigationController
            
            if meModel.access.isPremium {
                PlantsRouter(presenter: currentNavigationController).presentIdentify()
            } else {
                if let model = StoreKitManager.sharedInstance.checkSaleType(type: .identify) {
                    if let total = meModel.access.identifyTotal, total >= model.value {
                        switch model.sale {
                        case .saleTypeLifetime_50:
                            MenuRouter(presenter: currentNavigationController).presentLifetimePayWall(controller: String(describing: GardenChooseAddPlantController.self))
                        case .saleTypeYearly_50:
                            MenuRouter(presenter: currentNavigationController).presentYearPaywall(delegate: nil, controller: String(describing: GardenChooseAddPlantController.self))
                        case .saleTypeCombo, .saleTypeComboFull:
                            if let currentPopUp = PreferencesManager.sharedManager.currentPopUp {
                                MenuRouter(presenter: currentNavigationController).presentComboPaywall(popupType: currentPopUp, controller: String(describing: GardenChooseAddPlantController.self))
                            }
                        case .saleTypeLongWeek, .saleTypeLongYear:
                            MenuRouter(presenter: currentNavigationController).presentLongPaywall(isWeek: model.sale == .saleTypeLongWeek,  delegate: nil, controller: String(describing: ChooseIdentify.self))
                        case .saleTypeShortWeek, .saleTypeShortYear:
                            MenuRouter(presenter: currentNavigationController).presentShortPaywall(isWeek: model.sale == .saleTypeShortWeek,  delegate: nil, controller: String(describing: ChooseIdentify.self))
                        default:
                            return
                        }
                    } else {
                        PlantsRouter(presenter: currentNavigationController).presentIdentify()
                    }
                }
            }
        }
    }
    
    @IBAction func catalogAction(_ sender: Any) {
        dismiss(animated: false) {
            let currentController = RootRouter.sharedInstance.topViewController?.navigationController
            currentController?.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func addUniqueAction(_ sender: Any) {
        dismiss(animated: false) { [weak self] in
            guard let `self` = self else { return }
            guard let meModel = KeychainService.standard.me else { return }
            
            let currentNavigationController = RootRouter.sharedInstance.topViewController?.navigationController
            
            if meModel.access.isPremium {
                self.delegate?.didPressedAddUniquePlant()
            } else {
                if let model = StoreKitManager.sharedInstance.checkSaleType(type: .unique) {
                    if meModel.totalUniquePlants >= model.value {
                        switch model.sale {
                        case .saleTypeLifetime_50:
                            MenuRouter(presenter: currentNavigationController).presentLifetimePayWall(controller: String(describing: GardenChooseAddPlantController.self))
                        case .saleTypeYearly_50:
                            MenuRouter(presenter: currentNavigationController).presentYearPaywall(delegate: nil, controller: String(describing: GardenChooseAddPlantController.self))
                        case .saleTypeCombo, .saleTypeComboFull:
                            if let currentPopUp = PreferencesManager.sharedManager.currentPopUp {
                                MenuRouter(presenter: currentNavigationController).presentComboPaywall(popupType: currentPopUp, controller: String(describing: GardenChooseAddPlantController.self))
                            }
                        case .saleTypeLongWeek, .saleTypeLongYear:
                            MenuRouter(presenter: currentNavigationController).presentLongPaywall(isWeek: model.sale == .saleTypeLongWeek,  delegate: nil, controller: String(describing: ChooseIdentify.self))
                        case .saleTypeShortWeek, .saleTypeShortYear:
                            MenuRouter(presenter: currentNavigationController).presentShortPaywall(isWeek: model.sale == .saleTypeShortWeek,  delegate: nil, controller: String(describing: ChooseIdentify.self))
                        default:
                            return
                        }
                    } else {
                        self.delegate?.didPressedAddUniquePlant()
                    }
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: false)
    }
}
