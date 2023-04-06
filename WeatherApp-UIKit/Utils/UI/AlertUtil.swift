//
//  AlertUtil.swift
//  WeatherApp-UIKit
//
//  Created by Anwesh on 3/31/23.
//

import UIKit

class AlertUtil{
    
    func showAlert(title: String? = nil, message: String, vc: UIViewController?){
        
        var vc: UIViewController? = vc
        if vc == nil{
            vc = UIApplication.shared.windows.first?.rootViewController
        }
        
        guard vc != nil else{
            print("VC nill")
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = vc?.view
            alert.popoverPresentationController?.sourceRect = vc?.view.bounds ?? .zero
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        vc?.present(alert, animated: true)
    }
    
    func showLocationPermissionAlert( vc: UIViewController){
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alertController.popoverPresentationController?.sourceView = vc.view
            alertController.popoverPresentationController?.sourceRect = vc.view.bounds 
            alertController.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        vc.present(alertController, animated: true, completion: nil)
    }
    
}
