//
//  UserData.swift
//  BUAA Tools
//
//  Created by mac on 2022/11/27.
//

import Foundation
import CoreData

class UserData {
    private let container: NSPersistentContainer
    
    static let dataModel = UserData(name: "DataModel")
    private init(name: String) {
        container = NSPersistentContainer(name: name)
    }
    
    func createPersistentContainer() {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Load stores error. \(error)")
            }
            print("Load stores success. The description is \(description)")
        }
    }
    
    func insertTraffic(_ traffic: Traffic, username: String = User.defaultUser.username) {
        let context = container.viewContext
        let fetchTraffic = NSFetchRequest<TrafficEntity>(entityName: "TrafficEntity")
        let today = getMorningDate(date: Date())
        fetchTraffic.predicate = NSPredicate(format: "username == %@ && date >= %@", username, today as NSDate)
        let hasContained = try? context.fetch(fetchTraffic)
        var shouldChange: TrafficEntity
        if let hasContained = hasContained,
           !hasContained.isEmpty {
            shouldChange = hasContained[0]
        } else {
            shouldChange = (NSEntityDescription.insertNewObject(forEntityName: "TrafficEntity", into: context) as! TrafficEntity)
        }
        shouldChange.date = Date()
        shouldChange.paid = traffic.paidTraffic ?? -1
        shouldChange.free_tot = traffic.freeTraffic?.tot ?? -1
        shouldChange.free_res = traffic.freeTraffic?.res ?? -1
        shouldChange.gift_tot = traffic.giftTraffic?.tot ?? -1
        shouldChange.gift_res = traffic.giftTraffic?.res ?? -1
        shouldChange.username = username
        if context.hasChanges {
            do {
                try context.save()
                print("Insert new Traffic successfully.")
            } catch {
                print("Insert new Traffic has an error: \(error)")
            }
        }
    }
    
    func insertBalance(_ balance: Balance, username: String = User.defaultUser.username) {
        let context = container.viewContext
        let fetchBalance = NSFetchRequest<BalanceEntity>(entityName: "BalanceEntity")
        let today = getMorningDate(date: Date())
        fetchBalance.predicate = NSPredicate(format: "username == %@ && date >= %@", username, today as NSDate)
        let hasContained = try? context.fetch(fetchBalance)
        var shouldChange: BalanceEntity
        if let hasContained = hasContained,
           !hasContained.isEmpty {
            shouldChange = hasContained[0]
        } else {
            shouldChange = (NSEntityDescription.insertNewObject(forEntityName: "BalanceEntity", into: context) as! BalanceEntity)
        }
        shouldChange.date = Date()
        shouldChange.value = balance.balance ?? -1
        shouldChange.username = username
        if context.hasChanges {
            do {
                try context.save()
                print("Insert new Balance successfully.")
            } catch {
                print("Insert new Balance has an error: \(error)")
            }
        }
    }
    
    func fetchTrafficBetween(from date_st: Date, to date_ed: Date, username: String = User.defaultUser.username) throws -> [TrafficEntity] {
        let context = container.viewContext
        let fetchTraffic = NSFetchRequest<TrafficEntity>(entityName: "TrafficEntity")
        fetchTraffic.predicate = NSPredicate(format: "username == %@ && date BETWEEN  {%@,%@}", username, date_st as NSDate, date_ed as NSDate)
        let traffics = try context.fetch(fetchTraffic)
        return traffics
    }
    
    func fetchBalanceBetween(from date_st: Date, to date_ed: Date, username: String = User.defaultUser.username) throws -> [BalanceEntity] {
        let context = container.viewContext
        let fetchBalance = NSFetchRequest<BalanceEntity>(entityName: "BalanceEntity")
        fetchBalance.predicate = NSPredicate(format: "username == %@ && date BETWEEN  {%@,%@}", username, date_st as NSDate, date_ed as NSDate)
        let balances = try context.fetch(fetchBalance)
        return balances
    }
}
