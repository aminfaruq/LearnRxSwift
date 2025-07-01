//
//  Unwrap.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 01/07/25.
//

import Foundation
import RxSwift

extension ObservableType {
  
  /**
   Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
   - returns: An observable sequence of non-optional elements
   */
  
  public func unwrap<T>() -> Observable<T> where Element == T? {
    return self.filter { $0 != nil }.map { $0! }
  }
}
