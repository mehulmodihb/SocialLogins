//
//  AppleSignInHelper.swift
//  SocialLogins
//
//  Created by hb on 18/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import AuthenticationServices

@available(iOS 13, *)
class AppleSignInHelper: NSObject {
    
    static let shared = AppleSignInHelper()
    
    private var viewController: UIViewController!
    private var loggedIn: ((_ error: AppleError?, _ user: AppleUserModel?) -> Void)?
    
    func login(from viewController: UIViewController, callback: @escaping(_ error: AppleError?, _ user: AppleUserModel?) -> Void) {
        self.loggedIn = callback
        self.viewController = viewController
        self.handleAuthorizationAppleIDButtonPress()
    }
    
    override init() {
        super.init()
    }
    
    @objc
    private func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

@available(iOS 13, *)
extension AppleSignInHelper: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userApple = AppleUserModel(credential: appleIDCredential)
            self.loggedIn?(nil, userApple)
            
        default:
            self.loggedIn?(AppleError(title: "Apple Error", description: "Your Apple credential is not found", code: -3) , nil)
        }
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.loggedIn?(AppleError(title: "Apple Error", description: error.localizedDescription, code: -3), nil)
    }
}

@available(iOS 13, *)
extension AppleSignInHelper: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.viewController.view.window!
    }
}
