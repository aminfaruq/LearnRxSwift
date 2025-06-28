//
//  UIAlertViewController+Rx.swift
//  Combinestagram
//
//  Created by Amin faruq on 28/06/25.
//  Copyright © 2025 Underplot ltd. All rights reserved.
//

import RxSwift

extension UIViewController {
  func showAlert(_ title: String, description: String? = nil) -> Observable<Void> {
    return Observable.create { [weak self] observer in
      let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { _ in
        observer.onNext(())
        observer.onCompleted()
      }))
      
      self?.present(alert, animated: true, completion: nil)
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
}
