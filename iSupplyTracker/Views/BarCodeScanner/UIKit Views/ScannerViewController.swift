//
//  ScannerUIViewController.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 24.03.22.
//

import Foundation
import UIKit
import SwiftUI

struct ScannerViewController: UIViewControllerRepresentable {
    @Binding var barCode: String?
    @Binding var scanningRestart: Bool?
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let viewController = uiViewController as? UIScannerViewController else { return }
        if let _ = scanningRestart {
            viewController.restartSession()
            scanningRestart = nil
        }
    }
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIStoryboard(name: "UIScanner", bundle: nil).instantiateViewController(withIdentifier: "UIScannerViewController") as! UIScannerViewController
        viewController.delegate = context.coordinator
        return viewController
    }
    
    class Coordinator: NSObject, UIScannerViewControllerDelegate {
        @Binding private var scannedBarCode: String?
        @Binding private var scanningPaused: Bool?
        
        init(withBarCode: Binding<String?>, scanningStatus: Binding<Bool?>) {
            _scannedBarCode = withBarCode
            _scanningPaused = scanningStatus
        }
        
        func updateBarCode(with scannedBarCode: String) {
            
            self.scannedBarCode = scannedBarCode
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(withBarCode: $barCode, scanningStatus: $scanningRestart)
    }
}

protocol UIScannerViewControllerDelegate {
    func updateBarCode(with scannedBarCode: String)
}
