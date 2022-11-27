//
//  Exceptions.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import Foundation

enum AppException : Error {
    case InternetError
    case LoginFailed
    case DoubleLogin
    case DataError
}
