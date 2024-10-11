//
//  PremiumViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 24/09/2024.
//

import UIKit
import Anchorage

class PremiumViewController: UIViewController {
    
    var pageIndex: Int = 0
    var titleText: String = ""
    var selectedMonthlyPlanWithCurrency: String?
    var selectedYearlyPlanWithCurrency: String?
    
    private var basicPlanLeadingConstraint: NSLayoutConstraint?
    private var basicPlanTrailingConstraint: NSLayoutConstraint?
    private var advancePlanLeadingConstraint: NSLayoutConstraint?
    private var advancePlanTrailingConstraint: NSLayoutConstraint?
   
   // var pageIndexImageName: String = ""
    var premiumImageName: String = ""
    var robotImageName: String = ""
    var basicPlanImageName: String = ""
    var advancePlanImageName: String = ""
    let robotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let premiumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        return imageView
    }()
    var separatorColor: UIColor = .gray
    var pricingLabelColor: UIColor = .gray
    
    let pageControlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let crossButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "crossButtonImage")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
            button.tintColor = UIColor(named: "appPrimaryTextColor")
        }
        return button
    }()
    
    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.6941176471, blue: 0.9333333333, alpha: 0.08029801325)
        return separatorView
    }()
    
    let subHeaderLabel: UILabel = {
        let subHeaderLabel = UILabel()
        subHeaderLabel.textColor = UIColor(named: "appSubHeadingTextColor")
        subHeaderLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        subHeaderLabel.text = "Here is yearly and life time plan chose one to upgrade"
        subHeaderLabel.textAlignment = .center
        return subHeaderLabel
    }()
    
    let basicPlanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let advancePlanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let separator2View: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
        return separatorView
    }()
    
    private let purchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Rs.5000 for per month", for: .normal)
        let titleColorForNormalState: UIColor = UIColor(named: "appBackgroundViewColor") ?? .white
//        let titleColorForDisableState: UIColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
//        button.isEnabled = false
        button.setTitleColor(titleColorForNormalState, for: .normal)
//        button.setTitleColor(titleColorForDisableState, for: .disabled)
        button.setFont(FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 12), for: .normal)
        button.layer.cornerRadius = DesignMetrics.Padding.size8
        button.backgroundColor  = UIColor(named: "blackAndWhiteColor") ?? .black
        button.isOpaque = true
        return button
    }()
    
    private  let basicPricingLabel: UILabel = {
        let basicPricingLabel = UILabel()
        basicPricingLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 28)
        basicPricingLabel.textAlignment = .right
        return basicPricingLabel
    }()
    
    private  let advancePricingLabel: UILabel = {
        let advancePricingLabel = UILabel()
        advancePricingLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 28)
        advancePricingLabel.textAlignment = .right
        return advancePricingLabel
    }()
    
    private let basicPlanView: UIView = {
        let basicPlanView = UIView()
        basicPlanView.layer.cornerRadius = 8
        return basicPlanView
    }()
    
    private let advancePlanView: UIView = {
        let advancePlanView = UIView()
        advancePlanView.layer.cornerRadius = 8
        return advancePlanView
    }()
    
    
    // Enum for keeping track of the selected plan
        enum SelectedPlan: String {
            case basicMonthly = "Basic Monthly"
            case basicYearly = "Basic Yearly"
            case classicMonthly = "classic Monthly"
            case classicYearly = "classic Yearly"
        }
    
    var currentPlan: SelectedPlan = .basicMonthly // Default to Basic Plan
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        setupView()
        
//        self.setupUI()
//       // self.configurePageControlImage()
//        self.configureRobotImageView()
//        self.configureTitleLabels()
//        self.configurePricingView()
        
        // Fetch product prices when the view loads
                SubscriptionManager.shared.fetchAvailableProducts()

                // Set up a completion handler to update UI when products are fetched
                SubscriptionManager.shared.onProductsFetched = {
                    DispatchQueue.main.async {
                        self.updatePlanLabel()
                    }
                }
    }
    
    
    // Start animation in viewDidAppear for subsequent pages
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("page issss = \(pageIndex)")
        if(pageIndex == 0) {
            currentPlan = .basicMonthly
        }
        else if(pageIndex == 1) {
            currentPlan = .classicMonthly
        }
        else {
            currentPlan = .basicMonthly
        }
        
        monthlyPlanSelected()
        resetAndAnimateRobot()
    }
    
    // Stop the animation when the view disappears
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // robotImageView.layer.removeAllAnimations()
        stopRobotAnimation()
    }
    
    // Update the planLabel based on the selected plan
      private func updatePlanLabel() {
           var planText = ""
          
          switch pageIndex {
          
          case 0:
              if #available(iOS 16, *) {
                  if let basicMonthlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyBasicPlanID) {
                      planText = "\(currentPlan.rawValue) - \(basicMonthlyProduct.priceLocale)"
                      print(planText)
                      print("index = \(pageIndex)")
                      selectedMonthlyPlanWithCurrency = "\(basicMonthlyProduct.price) \(basicMonthlyProduct.priceLocale.currency ?? "")"
                      basicPricingLabel.text = selectedMonthlyPlanWithCurrency
                  }
                  
                  if let basicYearlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyBasicPlanID) {
                      planText = "\(currentPlan.rawValue) - \(basicYearlyProduct.price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      selectedYearlyPlanWithCurrency = "\(basicYearlyProduct.price) \(basicYearlyProduct.priceLocale.currency ?? "")"
                      advancePricingLabel.text = selectedYearlyPlanWithCurrency
                  }
                  
              } else {
                  // Fallback on earlier versions
                  if let basicMonthlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyBasicPlanID) {
                      let currencySymbol = basicMonthlyProduct.priceLocale.currencySymbol ?? ""
                      let price = basicMonthlyProduct.price
                      
                      // Format the text for earlier iOS versions
                      planText = "\(currentPlan.rawValue) - \(currencySymbol)\(price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      
                      selectedMonthlyPlanWithCurrency = "\(price) \(currencySymbol)"
                      basicPricingLabel.text = selectedMonthlyPlanWithCurrency
                  }
                  
                  // Fallback on earlier versions
                  if let basicYearlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyBasicPlanID) {
                      let currencySymbol = basicYearlyProduct.priceLocale.currencySymbol ?? ""
                      let price = basicYearlyProduct.price
                      
                      // Format the text for earlier iOS versions
                      planText = "\(currentPlan.rawValue) - \(currencySymbol)\(price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      
                      selectedYearlyPlanWithCurrency = "\(price) \(currencySymbol)"
                      advancePricingLabel.text = selectedYearlyPlanWithCurrency
                  }
                  
                  
              }
              
          case 1:
              
              if #available(iOS 16, *) {
                  if let classicMonthlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyClassicPlanID) {
                      planText = "\(currentPlan.rawValue) - \(classicMonthlyProduct.priceLocale)"
                      print(planText)
                      print("index = \(pageIndex)")
                      selectedMonthlyPlanWithCurrency = "\(classicMonthlyProduct.price) \(classicMonthlyProduct.priceLocale.currency ?? "")"
                      basicPricingLabel.text = selectedMonthlyPlanWithCurrency
                  }
                  
                  if let classicYearlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyClassicPlanID) {
                      planText = "\(currentPlan.rawValue) - \(classicYearlyProduct.price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      selectedYearlyPlanWithCurrency = "\(classicYearlyProduct.price) \(classicYearlyProduct.priceLocale.currency ?? "")"
                      advancePricingLabel.text = selectedYearlyPlanWithCurrency
                  }
                  
              } else {
                  // Fallback on earlier versions
                  if let basicMonthlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyClassicPlanID) {
                      let currencySymbol = basicMonthlyProduct.priceLocale.currencySymbol ?? ""
                      let price = basicMonthlyProduct.price
                      
                      // Format the text for earlier iOS versions
                      planText = "\(currentPlan.rawValue) - \(currencySymbol)\(price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      
                      selectedMonthlyPlanWithCurrency = "\(price) \(currencySymbol)"
                      basicPricingLabel.text = selectedMonthlyPlanWithCurrency
                  }
                  
                  // Fallback on earlier versions
                  if let basicYearlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyClassicPlanID) {
                      let currencySymbol = basicYearlyProduct.priceLocale.currencySymbol ?? ""
                      let price = basicYearlyProduct.price
                      
                      // Format the text for earlier iOS versions
                      planText = "\(currentPlan.rawValue) - \(currencySymbol)\(price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      
                      selectedYearlyPlanWithCurrency = "\(price) \(currencySymbol)"
                      advancePricingLabel.text = selectedYearlyPlanWithCurrency
                  }
                  
                  
              }
             
          case 2:
              if #available(iOS 16, *) {
                  if let premiumMonthlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyBasicPlanID) {
                      planText = "\(currentPlan.rawValue) - \(premiumMonthlyProduct.priceLocale)"
                      print(planText)
                      print("index = \(pageIndex)")
                      selectedMonthlyPlanWithCurrency = "\(premiumMonthlyProduct.price) \(premiumMonthlyProduct.priceLocale.currency ?? "")"
                      basicPricingLabel.text = selectedMonthlyPlanWithCurrency
                  }
                  
                  if let premiumYearlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyBasicPlanID) {
                      planText = "\(currentPlan.rawValue) - \(premiumYearlyProduct.price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      selectedYearlyPlanWithCurrency = "\(premiumYearlyProduct.price) \(premiumYearlyProduct.priceLocale.currency ?? "")"
                      
                      advancePricingLabel.text = selectedYearlyPlanWithCurrency
                  }
                  
              } else {
                  // Fallback on earlier versions
                  if let basicMonthlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyBasicPlanID) {
                      let currencySymbol = basicMonthlyProduct.priceLocale.currencySymbol ?? ""
                      let price = basicMonthlyProduct.price
                      
                      // Format the text for earlier iOS versions
                      planText = "\(currentPlan.rawValue) - \(currencySymbol)\(price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      
                      selectedMonthlyPlanWithCurrency = "\(price) \(currencySymbol)"
                      basicPricingLabel.text = selectedMonthlyPlanWithCurrency
                  }
                  
                  // Fallback on earlier versions
                  if let basicYearlyProduct = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyBasicPlanID) {
                      let currencySymbol = basicYearlyProduct.priceLocale.currencySymbol ?? ""
                      let price = basicYearlyProduct.price
                      
                      // Format the text for earlier iOS versions
                      planText = "\(currentPlan.rawValue) - \(currencySymbol)\(price)"
                      print(planText)
                      print("index = \(pageIndex)")
                      
                      selectedYearlyPlanWithCurrency = "\(price) \(currencySymbol)"
                      advancePricingLabel.text = selectedYearlyPlanWithCurrency
                  }
                  
                  
              }
              
          default:
              break
          }
          
       }
    
    private func setupView() {
            // Setup images and labels here based on the passed properties
                self.title = titleText
                robotImageView.image = UIImage(named: robotImageName)
            
        
                basicPlanImageView.image = UIImage(named: basicPlanImageName)
           
            
                advancePlanImageView.image = UIImage(named: advancePlanImageName)
            
            
                separatorView.backgroundColor = separatorColor
            
            
      //  basicPricingLabel.textColor = pricingLabelColor
            
            // Setup and layout the views here
        self.setupUI()
       // self.configurePageControlImage()
        self.configureRobotImageView()
        self.configureTitleLabels()
        self.configurePricingView()
        self.setupPurchaseButton()
        }
    
    
    private func setupUI() {
        view.addSubview(crossButton)
        crossButton.widthAnchor == DesignMetrics.Dimensions.width24
        crossButton.heightAnchor == DesignMetrics.Dimensions.height24
        crossButton.topAnchor == view.safeAreaLayoutGuide.topAnchor + DesignMetrics.Padding.size12
        crossButton.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor - DesignMetrics.Padding.size24
        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        
        view.addSubview(premiumImageView)
        premiumImageView.backgroundColor = separatorColor
        premiumImageView.layer.cornerRadius = 4
        premiumImageView.topAnchor == view.safeAreaLayoutGuide.topAnchor
        premiumImageView.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor + DesignMetrics.Padding.size48
        premiumImageView.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor - DesignMetrics.Padding.size48
        premiumImageView.heightAnchor == 320
        
        view.addSubview(separatorView)
        separatorView.topAnchor == premiumImageView.bottomAnchor
        separatorView.leadingAnchor == view.leadingAnchor
        separatorView.trailingAnchor == view.trailingAnchor
        separatorView.heightAnchor == 4
        separatorView.backgroundColor = separatorColor
    }
    
//    private func configurePageControlImage() {
//        view.addSubview(pageControlImageView)
//        if let image = UIImage(named: pageIndexImageName)?.withRenderingMode(.alwaysTemplate) {
//            pageControlImageView.image = image
//            pageControlImageView.tintColor = UIColor(named: "appPrimaryTextColor")
//        }
//        pageControlImageView.topAnchor == separatorView.bottomAnchor + 12
//        pageControlImageView.widthAnchor == 100
//        pageControlImageView.heightAnchor == 10
//        pageControlImageView.centerXAnchor == view.centerXAnchor
//    }
    
    private func configureRobotImageView() {
        view.addSubview(robotImageView)
        if let image = UIImage(named: robotImageName){
            robotImageView.image = image
        }
        
        robotImageView.widthAnchor == 108
        robotImageView.heightAnchor == 108
        robotImageView.centerYAnchor == separatorView.centerYAnchor - 12
        robotImageView.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor - DesignMetrics.Padding.size28
   
    }
    
    private func configureTitleLabels() {
        let headersVStackView = UIStackView()
        headersVStackView.axis = .vertical
        headersVStackView.spacing = 0
        
        let headerLabel = UILabel()
        headerLabel.textColor = UIColor(named: "appPrimaryTextColor")
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 18)
        headerLabel.text = "Chose Plan to Upgrade"
        headerLabel.textAlignment = .center
   
        view.addSubview(headersVStackView)
        headersVStackView.topAnchor == separatorView.bottomAnchor + 36
        headersVStackView.leadingAnchor == view.leadingAnchor + 16
        headersVStackView.trailingAnchor == view.trailingAnchor - 16
        headersVStackView.heightAnchor == 50
        
        headersVStackView.addArrangedSubview(headerLabel)
        headersVStackView.addArrangedSubview(subHeaderLabel)
        
    }
    
    private func configurePricingView() {
        let recommendedImageView = UIImageView()
        recommendedImageView.contentMode = .scaleAspectFit
        recommendedImageView.image = UIImage(named: "recommendedPremiumImage")
        
        let basicPlanTitleLabel = UILabel()
        basicPlanTitleLabel.textColor = UIColor(named: "appPrimaryTextColor")
        basicPlanTitleLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 18)
        basicPlanTitleLabel.text = "Monthly Plan"
        basicPlanTitleLabel.textAlignment = .left
        
        let basicPlanSubTitleLabel = UILabel()
        basicPlanSubTitleLabel.textColor = #colorLiteral(red: 0.2745098039, green: 0.3882352941, blue: 0.5294117647, alpha: 1)
        basicPlanSubTitleLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 10)
        basicPlanSubTitleLabel.text = "RS 410.00 for the first month"
        basicPlanSubTitleLabel.textAlignment = .left
        
       
        basicPricingLabel.textColor = pricingLabelColor
        basicPricingLabel.text = selectedMonthlyPlanWithCurrency
        
        let advancePlanTitleLabel = UILabel()
        advancePlanTitleLabel.textColor = UIColor(named: "appPrimaryTextColor")
        advancePlanTitleLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 18)
        advancePlanTitleLabel.text = "Yearly Plan"
        advancePlanTitleLabel.textAlignment = .left
        
        let advancePlanSubTitleLabel = UILabel()
        advancePlanSubTitleLabel.textColor = #colorLiteral(red: 0.2745098039, green: 0.3882352941, blue: 0.5294117647, alpha: 1)
        advancePlanSubTitleLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 10)
        advancePlanSubTitleLabel.text = "RS 410.00 for the first month"
        advancePlanSubTitleLabel.textAlignment = .left
        
        advancePricingLabel.textColor = pricingLabelColor
        advancePricingLabel.text = selectedYearlyPlanWithCurrency
        
        
        
        view.addSubview(basicPlanView)
        view.addSubview(advancePlanView)
        view.addSubview(separator2View)
        view.addSubview(recommendedImageView)
        
        basicPlanView.addSubview(basicPlanTitleLabel)
        basicPlanView.addSubview(basicPlanSubTitleLabel)
        basicPlanView.addSubview(basicPricingLabel)
        advancePlanView.addSubview(advancePlanTitleLabel)
        advancePlanView.addSubview(advancePlanSubTitleLabel)
        advancePlanView.addSubview(advancePricingLabel)
        
        basicPlanTitleLabel.topAnchor == basicPlanView.topAnchor + 12
        basicPlanTitleLabel.leadingAnchor == basicPlanView.leadingAnchor + 24
        basicPlanSubTitleLabel.topAnchor == basicPlanTitleLabel.bottomAnchor + 4
        basicPlanSubTitleLabel.leadingAnchor == basicPlanView.leadingAnchor + 24
        
        advancePlanTitleLabel.topAnchor == advancePlanView.topAnchor + 16
        advancePlanTitleLabel.leadingAnchor == advancePlanView.leadingAnchor + 16
        advancePlanSubTitleLabel.topAnchor == advancePlanTitleLabel.bottomAnchor + 4
        advancePlanSubTitleLabel.leadingAnchor == advancePlanView.leadingAnchor + 16
        
        recommendedImageView.topAnchor == basicPlanView.topAnchor - 12.5
        recommendedImageView.trailingAnchor == basicPlanView.trailingAnchor - 24
        recommendedImageView.widthAnchor == 107.81
        recommendedImageView.heightAnchor == 25
        
        basicPricingLabel.topAnchor == basicPlanView.topAnchor + 16
        basicPricingLabel.trailingAnchor == basicPlanView.trailingAnchor - 24
        
        advancePricingLabel.topAnchor == advancePlanView.topAnchor + 16
        advancePricingLabel.trailingAnchor == advancePlanView.trailingAnchor - 16
        
        basicPlanView.addSubview(basicPlanImageView)
        basicPlanImageView.image = UIImage(named: basicPlanImageName)
        basicPlanImageView.edgeAnchors == basicPlanView.edgeAnchors
        
        advancePlanView.addSubview(advancePlanImageView)
        advancePlanImageView.image = UIImage(named: advancePlanImageName)
        advancePlanImageView.edgeAnchors == advancePlanView.edgeAnchors
        
        basicPlanView.topAnchor == subHeaderLabel.bottomAnchor + 30
//        basicPlanView.leadingAnchor == view.leadingAnchor + 16
//        basicPlanView.trailingAnchor == view.trailingAnchor - 16
        // In your setup code
        basicPlanLeadingConstraint = basicPlanView.leadingAnchor == view.leadingAnchor + 16
        basicPlanTrailingConstraint = basicPlanView.trailingAnchor == view.trailingAnchor - 16
        basicPlanView.heightAnchor == 74
        
        
        
        advancePlanView.topAnchor == basicPlanView.bottomAnchor + 12
//        advancePlanView.leadingAnchor == view.leadingAnchor + 24
//        advancePlanView.trailingAnchor == view.trailingAnchor - 24
        advancePlanLeadingConstraint = advancePlanView.leadingAnchor == view.leadingAnchor + 24
        advancePlanTrailingConstraint = advancePlanView.trailingAnchor == view.trailingAnchor - 24
        advancePlanView.heightAnchor == 74
       
        addTapGesture(to: basicPlanView, tag: 0)
        addTapGesture(to: advancePlanView, tag: 1)

        
        
        separator2View.topAnchor == advancePlanImageView.bottomAnchor + 28
        separator2View.leadingAnchor == view.leadingAnchor
        separator2View.trailingAnchor == view.trailingAnchor
        separator2View.heightAnchor == 2
    }
    
    private func setupPurchaseButton() {
        view.addSubview(purchaseButton)
       
        purchaseButton.topAnchor == separator2View.bottomAnchor + DesignMetrics.Padding.size12
        purchaseButton.leadingAnchor == view.leadingAnchor + DesignMetrics.Padding.size24
        purchaseButton.trailingAnchor == view.trailingAnchor - DesignMetrics.Padding.size24
        purchaseButton.heightAnchor == DesignMetrics.Dimensions.height60
        purchaseButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
    }
    
    @objc private func purchaseButtonTapped() {
            print("Can move to next")

        if(pageIndex == 0) {
            if(currentPlan == .basicMonthly) {
                if let product = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyBasicPlanID) {
                          // SubscriptionManager.shared.purchaseProduct(product)
                    
                    Task {
                           do {
                               if #available(iOS 15.0, *) {
                                   try await SubscriptionManager.shared.purchaseProduct(product)
                               } else {
                                   // Fallback on earlier versions
                               }
                               print("Purchase successful!")
                           } catch {
                               print("Purchase failed: \(error.localizedDescription)")
                           }
                       }
                    
                    
                       } else {
                           print("Basic plan not available.")
                       }
            }
            else {
                if let product = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyBasicPlanID) {
                          // SubscriptionManager.shared.purchaseProduct(product)
                    
                    Task {
                           do {
                               if #available(iOS 15.0, *) {
                                   try await SubscriptionManager.shared.purchaseProduct(product)
                               } else {
                                   // Fallback on earlier versions
                               }
                               print("Purchase successful!")
                           } catch {
                               print("Purchase failed: \(error.localizedDescription)")
                           }
                       }
                            
                       } else {
                           print("Basic plan not available.")
                       }
            }
        }
        else  if(pageIndex == 1) {
            if(currentPlan == .classicMonthly) {
                if let product = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyClassicPlanID) {
                          // SubscriptionManager.shared.purchaseProduct(product)
                    Task {
                           do {
                               if #available(iOS 15.0, *) {
                                   try await SubscriptionManager.shared.purchaseProduct(product)
                               } else {
                                   // Fallback on earlier versions
                               }
                               print("Purchase successful!")
                           } catch {
                               print("Purchase failed: \(error.localizedDescription)")
                           }
                       }
                       } else {
                           print("Basic plan not available.")
                       }
            }
            else {
                if let product = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyClassicPlanID) {
                          // SubscriptionManager.shared.purchaseProduct(product)
                    Task {
                           do {
                               if #available(iOS 15.0, *) {
                                   try await SubscriptionManager.shared.purchaseProduct(product)
                               } else {
                                   // Fallback on earlier versions
                               }
                               print("Purchase successful!")
                           } catch {
                               print("Purchase failed: \(error.localizedDescription)")
                           }
                       }
                       } else {
                           print("Basic plan not available.")
                       }
            }
        }
        
        else {
            if(currentPlan == .basicMonthly) {
                if let product = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.monthlyBasicPlanID) {
                       //    SubscriptionManager.shared.purchaseProduct(product)
                    Task {
                           do {
                               if #available(iOS 15.0, *) {
                                   try await SubscriptionManager.shared.purchaseProduct(product)
                               } else {
                                   // Fallback on earlier versions
                               }
                               print("Purchase successful!")
                           } catch {
                               print("Purchase failed: \(error.localizedDescription)")
                           }
                       }
                       } else {
                           print("Basic plan not available.")
                       }
            }
            else {
                if let product = SubscriptionManager.shared.getProductByID(SubscriptionManager.shared.yearlyBasicPlanID) {
                          // SubscriptionManager.shared.purchaseProduct(product)
                    Task {
                           do {
                               if #available(iOS 15.0, *) {
                                   try await SubscriptionManager.shared.purchaseProduct(product)
                               } else {
                                   // Fallback on earlier versions
                               }
                               print("Purchase successful!")
                           } catch {
                               print("Purchase failed: \(error.localizedDescription)")
                           }
                       }
                       } else {
                           print("Basic plan not available.")
                       }
            }
        }
      
        
    }
    
    private func addTapGesture(to view: UIView, tag: Int) {
        view.tag = tag
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(purchaseViewTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func purchaseViewTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        switch tappedView.tag {
        case 0:
            if(pageIndex == 0) {
                currentPlan = .basicMonthly
            }
            else if(pageIndex == 1) {
                currentPlan = .classicMonthly
            }
            else {
                currentPlan = .basicMonthly
            }
            monthlyPlanSelected()
        case 1:
            if(pageIndex == 0) {
                currentPlan = .basicYearly
            }
            else if(pageIndex == 1) {
                currentPlan = .classicYearly
            }
            else {
                currentPlan = .basicYearly
            }
            yearlyPlanSelected()
        default:
            break
        }
    }
    
    private func monthlyPlanSelected() {
        // Update the images and content modes
            basicPlanImageView.image = UIImage(named: basicPlanImageName)
            advancePlanImageView.image = UIImage(named: advancePlanImageName)
            basicPlanImageView.contentMode = .scaleAspectFill
            advancePlanImageView.contentMode = .scaleAspectFit
            
            // Deactivate the leading and trailing constraints
            basicPlanLeadingConstraint?.isActive = false
            basicPlanTrailingConstraint?.isActive = false
            advancePlanLeadingConstraint?.isActive = false
            advancePlanTrailingConstraint?.isActive = false
            
            // Create new constraints
            basicPlanLeadingConstraint = basicPlanView.leadingAnchor == view.leadingAnchor + 16
            basicPlanTrailingConstraint = basicPlanView.trailingAnchor == view.trailingAnchor - 16
            
            advancePlanLeadingConstraint = advancePlanView.leadingAnchor == view.leadingAnchor + 24
            advancePlanTrailingConstraint = advancePlanView.trailingAnchor == view.trailingAnchor - 24
            
            // Apply the layout changes
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()  // Apply the layout changes smoothly
            }
    }
    
    private func yearlyPlanSelected() {
        // Update the images and content modes
            basicPlanImageView.image = UIImage(named: advancePlanImageName)
            advancePlanImageView.image = UIImage(named: basicPlanImageName)
            basicPlanImageView.contentMode = .scaleAspectFit
            advancePlanImageView.contentMode = .scaleAspectFill
            
            // Deactivate the leading and trailing constraints
            basicPlanLeadingConstraint?.isActive = false
            basicPlanTrailingConstraint?.isActive = false
            advancePlanLeadingConstraint?.isActive = false
            advancePlanTrailingConstraint?.isActive = false
            
            // Create new constraints
            basicPlanLeadingConstraint = basicPlanView.leadingAnchor == view.leadingAnchor + 24
            basicPlanTrailingConstraint = basicPlanView.trailingAnchor == view.trailingAnchor - 24
            
            advancePlanLeadingConstraint = advancePlanView.leadingAnchor == view.leadingAnchor + 16
            advancePlanTrailingConstraint = advancePlanView.trailingAnchor == view.trailingAnchor - 16
            
            // Apply the layout changes
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()  // Apply the layout changes smoothly
            }
    }
    
    
    @objc func crossButtonTapped(){
        self.dismiss(animated: true)
    }
    
    
    private func animateRobot() {
        // Animate the robot to move up, scale up, and then move down and scale down
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            // Move the robot up and scale it up
            let translation = CGAffineTransform(translationX: 0, y: -20) // Move up by 20 points
            let scale = CGAffineTransform(scaleX: 1.2, y: 1.2) // Scale by 1.2
            self.robotImageView.transform = translation.concatenating(scale)
        }, completion: nil)
    }
    
    // Function to reset and start the animation
    func resetAndAnimateRobot() {
        // Reset the transform to the original state
        self.robotImageView.transform = CGAffineTransform.identity
        
        // Start the animation
        animateRobot()
    }
    
    // Function to stop the animation
    private func stopRobotAnimation() {
        self.robotImageView.layer.removeAllAnimations()
    }
    
}
