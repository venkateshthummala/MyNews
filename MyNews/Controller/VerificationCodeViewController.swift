//
//  VerificationCodeViewController.swift
//  MyNews
//
//  Created by ashish jain on 04/09/23.
//

import UIKit
import Firebase

class VerificationCodeViewController: UIViewController {

    
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    @IBOutlet weak var verificatiomCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func onTapVeificationCodeButton(_ sender: UIButton) {
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID"),
                    let verificationCode = verificationCodeTextField.text else { return }
                 print(verificationID)
              let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)

              Auth.auth().signIn(with: credential) { (authResult, error) in
                  if let error = error {
                      print("Error verifying code: \(error.localizedDescription)")
                      return
                  }

                  // Authentication successful, you can now proceed to the main part of your app.

                  
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsHeadLinesViewController")as!NewsHeadLinesViewController
                  self.navigationController?.pushViewController(vc, animated: true)
                  // For example, you can dismiss the verification code view controller and show the main screen.
//                  self.dismiss(animated: true, completion: nil)
              }
          }

}
