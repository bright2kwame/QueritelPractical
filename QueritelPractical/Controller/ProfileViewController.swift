//
//  ProfileViewController.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var regDateLabel: UILabel!
    
    override func viewDidLoad() {
        
        self.getData()
    }
    
    private func getData(){
        
        let defaults = UserDefaults.standard
        let stringData = defaults.data(forKey: "user")
        if (stringData != nil){
            do {
                let apiData = try JSONDecoder().decode(ApiPayLoad.self, from: stringData!)
                upateUI(apiData: apiData)
            } catch {
                print(error)
            }
            return
        }
        
        
        let url = "https://api.queritel.com/api/test-lab/ios.php"
        let parameters = ["action": "get_profile_data"]

        //MARK: API returns data only for maltipart request
        AF.upload(multipartFormData: { (multiFormData) in
                for (key, value) in parameters {
                    multiFormData.append(Data(value.utf8), withName: key)
                }
            }, to: url).responseDecodable(of: ApiPayLoad.self) { response in
                switch response.result {
                case .success(let data):
                    do {
                        let enc = try JSONEncoder().encode(data)
                        defaults.set(enc, forKey: "user")
                    } catch {
                        print(error)
                    }
                    self.upateUI(apiData: data)
                case .failure(_):
                    print("fail")
                }
            }
    }
    
    private func upateUI(apiData: ApiPayLoad){
        nameLabel.text = "\(apiData.user_data.lname) \(apiData.user_data.fname)"
        phoneLabel.text = apiData.user_data.phone_number
        emailLabel.text = apiData.user_data.email
        genderLabel.text = apiData.user_data.gender
        countryLabel.text = apiData.user_data.country
        regDateLabel.text = apiData.user_data.registration_date
        
        AF.request(apiData.user_data.image_url).responseImage { response in
            if case .success(let image) = response.result {
                self.profileImageView.image = image
            }
        }
        
    }
}
