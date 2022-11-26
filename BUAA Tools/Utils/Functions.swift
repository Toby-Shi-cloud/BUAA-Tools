//
//  Functions.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import Foundation

func usePercentage(value: (tot: Double, res: Double)?) -> Double? {
    if let value = value {
        return value.res / value.tot
    } else {
        return nil
    }
}

func tdsToTdModels(value: [(term: String, value: Int)]) -> [TdViewModel] {
    var list: [TdViewModel] = []
    for td in value {
        list.append(TdViewModel(term: td.term, value: td.value))
    }
    return list
}

func indexToModel(value: [Int]) -> [IndexModel] {
    var list: [IndexModel] = []
    for i in value {
        list.append(IndexModel(index: i))
    }
    return list
}

func modelToIndex(value: [IndexModel]) -> [Int] {
    var list: [Int] = []
    for m in value {
        list.append(m.index)
    }
    return list
}
