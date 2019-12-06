
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet var userName: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var updateUsernameTF: UITextField!
    @IBOutlet weak var updatePasswordTF: UITextField!
    @IBOutlet weak var updateView: UIStackView!

    var ref: DatabaseReference!
    let image = UIImagePickerController()
    var userID : String?
    var updateRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView.isHidden = true
        ref = Database.database().reference()
        updateUserInfo()
        // Do any additional setup after loading the view.
    }
    /* Update button where correctly display the views*/
    @IBAction func updateMyInfoBtn(_ sender: Any) {
        if updateView.isHidden == false {
            updateView.isHidden = true
            self.view.endEditing(true)
        } else {
            updateView.isHidden = false
        }
        
    }
    /* Update botton trigger to show the textfields where user can change their info*/
    @IBAction func updateBtn(_ sender: Any) {
        guard let newUsernameStr = updateUsernameTF.text else {
            print("Error in parsing the New Username")
            return
        }
        guard let newPasswordStr = updatePasswordTF.text else {
            print("Error in parsing the New Password")
            return
        }
        
        let noSpaceNewPassword =  newPasswordStr.replacingOccurrences(of: " ", with: "")
        let trimmedNewUsername = newUsernameStr.trimmingCharacters(in: .whitespaces)
        if noSpaceNewPassword.count <= 5 && noSpaceNewPassword != ""{
            print("invalid password ")
            let alert = UIAlertController(title: "Password NOT Updated", message: "The new password has to be at least 6 characters", preferredStyle: .alert)
            let goAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(goAction)
            self.present(alert, animated: true, completion: nil)
            updatePasswordTF.text = ""
            return
        }
        // update databse:
        dataUpdated(newUsername: trimmedNewUsername, newPassword: noSpaceNewPassword)
        updatePasswordTF.text = ""
        updateUsernameTF.text = ""
        updateView.isHidden = true
        self.view.endEditing(true)
    }
    /* Update the information from user if it is needed to the Firebase*/
    func dataUpdated(newUsername:String, newPassword: String) {
        self.userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("user").child(userID ?? "error with userID")
        
        if (newPassword != "" && newUsername != "") {
            self.userName.text = newUsername
            
            Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
                print("ERROR MESSAGE:", error)
                
            }
            
            self.ref.updateChildValues(["username" : newUsername])
        } else if newPassword != "" && newUsername == "" {
            Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
                print("ERROR MESSAGE:", error)
            }
            
        } else if newUsername != ""  {
            self.ref.updateChildValues(["username" : newUsername])
            self.userName.text = newUsername
        }
        
    }
    /* Getting the most updated information from Firebase*/
    func updateUserInfo(){
        self.userID = Auth.auth().currentUser?.uid
        ref.child("user").child(userID ?? "error with userID").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let usernamee = value?["username"] as? String ?? "lala?"
            let email = value?["email"] as? String ?? "lala?"
            let imageName = value?["image"] as? String ?? ""
            self.userName.text = usernamee
            self.emailLabel.text = email
            self.getUserImageFromFB(imageName: imageName)
            print("Image name!!! ",imageName)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    /* Log out the user to the login view */
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = storyboard.instantiateViewController(identifier: "LoginNavControler")
        let TapHomeVC = vs as! UINavigationController
        TapHomeVC.modalPresentationStyle = .fullScreen
        self.present(TapHomeVC, animated: true, completion: nil)
    }
    
    @IBAction func changeProfilebtn(_ sender: Any) {
        initPicker()
    }
    /* Init the photo picker */
    func initPicker(){
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        image.delegate = self
        self.present(image,animated: true)
    }
    /*  Place the user's selected image and dismiss the photo picker
        Also uploadthe user's selected image to the firebase
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selected : UIImage?
        if let edited = info[.editedImage] as? UIImage{
            selected = edited
        }else if let original = info[.originalImage] as? UIImage{
            selected = original
        }
        self.profileImage.image = selected!
        picker.dismiss(animated:true, completion:nil)
        uploadUserImageToFB()
    }
    /* Get user's profile image from firebase and if user's image has not been set up, then set the user's image as default grey image.*/
    func getUserImageFromFB(imageName: String){
        self.profileImage.image = UIImage(named: "default.png")!
        let imageRef = Storage.storage().reference().child(imageName)
        imageRef.getData(maxSize: 20*2048*2048){ response, error in
            if let err = error {
                print("\(err)")
                return
            }
            if let data = response {
                print("Sucessfully download image.")
                self.profileImage.image = UIImage(data: data)
            }else{
                self.profileImage.image = UIImage(named: "default.png")!
            }
        }
    }
    
    /* Upload the user's image to firebase */
    func uploadUserImageToFB() {
        if let img = self.profileImage.image {
            let imageName = "\(self.userID ?? "nilllll").png"
            let imageRef = Storage.storage().reference().child(imageName)
            if let uploadData = img.pngData() {
                imageRef.putData(uploadData, metadata: nil) { metadata, error in
                    if error != nil {
                        print("Error: \(error.debugDescription)")
                        return
                    } else {
                        print("Sucessfully upload image.")
                        if let user=Auth.auth().currentUser { self.ref.child("user").child(user.uid).child("image").setValue(imageName)}
                    }
                }
            }
        }
    }
    
    
    
    
}
