//
//  SubscriptionManager.swift
//  CloudVault
//
//  Created by Appinators Technology on 27/09/2024.
//

import Foundation
import StoreKit

class SubscriptionManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = SubscriptionManager()

    private var productRequest: SKProductsRequest?
    private(set) var availableProducts = [SKProduct]()
    
    var onProductsFetched: (() -> Void)? // Completion handler to notify UI

    let monthlyBasicPlanID = "monthly_basic"
    let yearlyBasicPlanID = "yearly_basic"
    let monthlyClassicPlanID = "monthly_classic"
    let yearlyClassicPlanID = "yearly_classic"

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    // Fetch products from App Store
    func fetchAvailableProducts() {
        let productIDs = Set([monthlyBasicPlanID, yearlyBasicPlanID, monthlyClassicPlanID, yearlyClassicPlanID])
        productRequest = SKProductsRequest(productIdentifiers: productIDs)
        productRequest?.delegate = self
        productRequest?.start()
    }

    // StoreKit delegate method - called when products are fetched
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        availableProducts = response.products
        onProductsFetched?()
    }

    // Helper to get product by ID
    func getProductByID(_ productID: String) -> SKProduct? {
        return availableProducts.first(where: { $0.productIdentifier == productID })
    }

    @available(iOS 15.0, *)
    func purchaseProduct(_ product: SKProduct) async throws {
        guard SKPaymentQueue.canMakePayments() else {
            throw NSError(domain: "PaymentError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User cannot make payments."])
        }

        // Use withCheckedThrowingContinuation to ensure we handle the continuation correctly
        return try await withCheckedThrowingContinuation { continuation in
            let payment = SKPayment(product: product)
            
            let transactionObserver = TransactionObserver { result in
                switch result {
                case .success:
                    // Successful transaction, resume continuation
                    continuation.resume()
                case .failure(let error):
                    // Transaction failed, resume continuation with an error
                    continuation.resume(throwing: error)
                }
            }
            
            // Add observer and payment
            SKPaymentQueue.default().add(transactionObserver)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    
    
    
    

    // Observer for payment transactions
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful purchase
                completeTransaction(transaction)
            case .failed:
                // Handle failed purchase
                failedTransaction(transaction)
            case .restored:
                // Handle restored purchases if needed
                restoreTransaction(transaction)
            case .deferred, .purchasing:
                // Handle pending or purchasing state if needed
                break
            @unknown default:
                break
            }
        }
    }

    // Complete the transaction
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        print("Purchase successful: \(transaction.payment.productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
        // Unlock the subscription or entitlement here
    }

    // Handle failed transactions
    private func failedTransaction(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error as NSError? {
            if error.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(error.localizedDescription)")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    // Handle restored transactions
    private func restoreTransaction(_ transaction: SKPaymentTransaction) {
        print("Restored: \(transaction.payment.productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
        // Restore the subscription or entitlement here
    }

    // Restore purchases (optional for subscription)
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}




// MARK: - Transaction Observer Class

class TransactionObserver: NSObject, SKPaymentTransactionObserver {
    var continuationHandler: (Result<SKPaymentTransaction, Error>) -> Void
    
    init(continuationHandler: @escaping (Result<SKPaymentTransaction, Error>) -> Void) {
        self.continuationHandler = continuationHandler
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Successful purchase
                SKPaymentQueue.default().finishTransaction(transaction)
                continuationHandler(.success(transaction))
            case .failed:
                // Failed purchase
                if let error = transaction.error {
                    continuationHandler(.failure(error))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
