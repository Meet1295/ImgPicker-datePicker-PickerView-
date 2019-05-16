//
//  ProfileVC.swift
//  Zacl
//
//  Created by Admin on 1/23/19.
//  Copyright © 2019 zacl. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class ProfileVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var viewMainKGPicker: UIView!
    @IBOutlet weak var viewMainDatePicker: UIView!
    @IBOutlet weak var LayConstKgLbsPickerVwBottom: NSLayoutConstraint!
    @IBOutlet weak var LayConstdatePickerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var btnRegisterNow: UIButton!
    @IBOutlet weak var imgViewProfilepic: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblKgLbs: UILabel!
    @IBOutlet weak var datePickerDOB: UIDatePicker!
    @IBOutlet weak var pickerVwKGLBS: UIPickerView!
    
    var strFName = ""
    var strLName = ""
    var strEmail = ""
    var strPassword = ""
    
    var tempDatePickerValue = ""
    var strPickerVwKgLbsSelectedValue = ""
    var todayDate = ""
    var genderVal = ""
    var genderSelected = Bool()
    
    var sentTo: String?
    var pool: AWSCognitoIdentityUserPool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainUIAndView()
    }
    

//MARK:- Custom Methods -
    func setUpMainUIAndView(){
        UINavigationBar.appearance().isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Registration"
       
        pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        genderSelected = false
        
        btnRegisterNow.layer.cornerRadius = 5.0
        lblUserName.text = "\(strFName) \(strLName)"
        txtHeight.attributedPlaceholder = NSAttributedString(string:"Height(CM)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtWeight.attributedPlaceholder = NSAttributedString(string:"Weight", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        lblKgLbs.text = "Kg/LBS"
        lblKgLbs.textColor = UIColor.gray
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        todayDate = formatter.string(from: date)
        lblDob.text = todayDate
        
        datePickerDOB.datePickerMode = .date

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tapProfilePicImgView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.imgPicker_Clicked))
        imgViewProfilepic.isUserInteractionEnabled = true
        imgViewProfilepic.addGestureRecognizer(tapProfilePicImgView)
        
        HideDatePickerView()
        HideKgLBSPickerView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func imgPicker_Clicked() {
        openImagePicker()
    }
    
    func openImagePicker(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.title = "Choose any to set Profile Picture"
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = false
                imagePickerController.delegate = self
                
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("The device does not have any camera availabe.")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
//MARK:- Show  Picker View -
    func ShowKgLBSPickerView() -> Void {
        self.LayConstKgLbsPickerVwBottom.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
//MARK:- Hide PickerView -
    func HideKgLBSPickerView() -> Void{
        self.LayConstKgLbsPickerVwBottom.constant = -247
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
//MARK:- Show Date Picker View -
    func ShowDatePickerView() -> Void {
        self.LayConstdatePickerViewBottom.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
//MARK:- Hide Date PickerView -
    func HideDatePickerView() -> Void{
        self.LayConstdatePickerViewBottom.constant = -247
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
   
//MARK:-  Image Picker  Methods -
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image1 = info [UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.imgViewProfilepic.image = image1
                self.imgViewProfilepic.layer.cornerRadius = self.imgViewProfilepic.frame.height/2
                self.imgViewProfilepic.clipsToBounds = true
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
//MARK:- PickerView Delegate & DataSource -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        strPickerVwKgLbsSelectedValue =  row == 0  ? "KG" : "LBS"
        return strPickerVwKgLbsSelectedValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strPickerVwKgLbsSelectedValue =  row == 0  ? "KG" : "LBS"
    }
    
  //MARK:- Button Selections -
    @IBAction func dob_Clicked(_ sender: UIButton) {
        ShowDatePickerView()
    }
    
    @IBAction func gender_Female_Clicked(_ sender: UIButton) {
        genderSelected = true
        btnMale.isSelected = false
        genderVal = "Female"
        if sender.isSelected == true {
            sender.isSelected = false
        } else{
            sender.isSelected = true
        }
    }
    
    @IBAction func gender_Male_Clicked(_ sender: UIButton) {
        genderSelected = true
        btnFemale.isSelected = false
        genderVal = "Male"
        if sender.isSelected == true {
            sender.isSelected = false
        } else{
            sender.isSelected = true
        }
    }
    
    
    @IBAction func kgLBS_Clicked(_ sender: UIButton) {
        ShowKgLBSPickerView()
    }
    
    @IBAction func ok_KgPicker_Clicked(_ sender: UIButton) {
        lblKgLbs.text = strPickerVwKgLbsSelectedValue
        lblKgLbs.textColor = .white
        HideKgLBSPickerView()
    }
    
    @IBAction func cancel_KgPicker_Clicked(_ sender: UIButton) {
        lblKgLbs.text = "Kg/LBS"
        lblKgLbs.textColor = .gray
        HideKgLBSPickerView()
    }
    
    @IBAction func dob_valueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        let date = formatter.string(from: sender.date)
        tempDatePickerValue = date
    }
    
    @IBAction func dob_DatePicker_Cancle_Clicked(_ sender: UIButton) {
         HideDatePickerView()
    }
    
    @IBAction func dob_Datepicker_Ok_Clicked(_ sender: UIButton) {
        lblDob.text = tempDatePickerValue
        HideDatePickerView()
    }
    
    @IBAction func registerNow_Clicked(_ sender: UIButton) {
        if txtMobileNo.text?.removeWhiteSpaces() == "" {
             ShowToast.show(toatMessage: kMobileNoAlertMsg)
        } else if txtMobileNo.hasText {
            if (txtMobileNo.text?.count)! > 13 || (txtMobileNo.text?.count)! < 13{
                ShowToast.show(toatMessage: kValidMobileNoAlertMsg)
            } else if lblDob.text == todayDate{
                ShowToast.show(toatMessage: kDobAlertMsg)
            } else if genderSelected == false {
                ShowToast.show(toatMessage: kGenderAlertMsg)
            } else if txtHeight.text?.removeWhiteSpaces() == ""{
                ShowToast.show(toatMessage: kHeightAlertMsg)
            } else if txtHeight.hasText {
                if (txtHeight.text?.count)! < 3 {
                    ShowToast.show(toatMessage: kValidHeightAlertMsg)
                } else if txtWeight.text?.removeWhiteSpaces() == ""{
                    ShowToast.show(toatMessage: kWeightAlertMsg)
                } else  if txtWeight.hasText {
                    if (txtWeight.text?.count)! < 3 {
                        ShowToast.show(toatMessage: kValidWeightAlertMsg)
                    } else if lblKgLbs.text?.removeWhiteSpaces() == "Kg/LBS"{
                        ShowToast.show(toatMessage: kkgLbsAlertMsg)
                    } else{
                        AWSSignUp()
                    }
                }
            }
        }
    }
    
    func AWSSignUp() {
        //sign up the user
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        if let MobileNo = txtMobileNo.text, !MobileNo.isEmpty {
            let phone = AWSCognitoIdentityUserAttributeType()
            phone?.name = "phone_number"
            phone?.value = MobileNo
            attributes.append(phone!)
        }
        
        if let DOB = lblDob.text, !DOB.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let date = formatter.date(from: DOB)
            let strDate = formatter.string(from: date!)
            let dateOfBirth = AWSCognitoIdentityUserAttributeType()
            dateOfBirth?.name = "birthdate"
            dateOfBirth?.value = strDate
            attributes.append(dateOfBirth!)
        }
        
        if let Hieght = txtHeight.text, !Hieght.isEmpty {
            let HieghtVal = AWSCognitoIdentityUserAttributeType()
            HieghtVal?.name = "custom:height"
            HieghtVal?.value = Hieght
            attributes.append(HieghtVal!)
        }
        
        if let Weight = txtWeight.text, !Weight.isEmpty {
            let WeightVal = AWSCognitoIdentityUserAttributeType()
            WeightVal?.name = "custom:weight"
            WeightVal?.value = Weight
            attributes.append(WeightVal!)
        }
        
        if let KgLbs = lblKgLbs.text, !KgLbs.isEmpty {
            let KgLbsVal = AWSCognitoIdentityUserAttributeType()
            KgLbsVal?.name = "custom:weight_type"
            KgLbsVal?.value = KgLbs
            attributes.append(KgLbsVal!)
        }
        
        if let imageProfile = imgViewProfilepic.image {
            let imageProfileVal = AWSCognitoIdentityUserAttributeType()
            imageProfileVal?.name = "picture"
            imageProfileVal?.value = "imageProfile"
            attributes.append(imageProfileVal!)
        }
        
        let GenderVal = AWSCognitoIdentityUserAttributeType()
        GenderVal?.name = "gender"
        GenderVal?.value = genderVal
        attributes.append(GenderVal!)

        let strFullName = "\(strFName) \(strLName)"
        let userName = AWSCognitoIdentityUserAttributeType()
        userName?.name = "preferred_username"
        userName?.value = strFullName
        attributes.append(userName!)
        
        let strFirstName = AWSCognitoIdentityUserAttributeType()
        strFirstName?.name = "name"
        strFirstName?.value = strFName
        attributes.append(strFirstName!)
        
        let strLastName = AWSCognitoIdentityUserAttributeType()
        strLastName?.name = "given_name"
        strLastName?.value = strLName
        attributes.append(strLastName!)
        
        
        self.pool?.signUp(strEmail, password: strPassword, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alertController.addAction(retryAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "VarifyOTPVC") as! VarifyOTPVC
                        vc.strEmail = (strongSelf.strEmail)
                        vc.strMobileNo = strongSelf.txtMobileNo.text!
                        vc.strUserName = strFullName
                        vc.sentTo = self?.sentTo
                        vc.user = self!.pool?.getUser(self!.strEmail)
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
                    } else {
                         let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                }
            })
            return nil
        }
    }
}
