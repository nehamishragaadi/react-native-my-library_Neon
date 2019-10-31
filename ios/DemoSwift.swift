//
//  DemoSwift.swift
//  DemoNew
//
//  Created by Neha on 10/31/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(DemoSwift)
public class DemoSwift: NSObject {
  @objc
  public func showName(){
    let NeonHandle: NeoniosDemo = NeoniosDemo()
    NeonHandle.openNeutral()
    print("Method calling")
  }
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
