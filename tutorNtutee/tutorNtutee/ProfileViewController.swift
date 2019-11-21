
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet var userName: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
     var ref: DatabaseReference!
    let image = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        //Bordersetup()
        updateUserInfo()
        // Do any additional setup after loading the view.
    }
    func updateUserInfo(){
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
        let value = snapshot.value as? NSDictionary
        let usernamee = value?["username"] as? String ?? ""
        let email = value?["email"] as? String ?? ""
        let imageName = value?["image"] as? String ?? ""
//        self.userName.text = usernamee
//        self.emailLabel.text = email
            print(usernamee)
            print(email)
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
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
    func initPicker(){
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        image.delegate = self
        self.present(image,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selected : UIImage?
        if let edited = info[.editedImage] as? UIImage{
            selected = edited
        }else if let original = info[.originalImage] as? UIImage{
                selected = original
        }
        
    self.profileImage.image = selected!
    picker.dismiss(animated:true, completion:nil)
    }
//    func Bordersetup(){
//           myPostBtn.layer.masksToBounds = true
//           myPostBtn.layer.cornerRadius = 2.0
//           myPostBtn.layer.borderColor = UIColor.blue.cgColor
//           myPostBtn.layer.borderWidth = 0.5
//           myPostBtn.layer.masksToBounds = true
//           changepswBtn.layer.cornerRadius = 2.0
//           changepswBtn.layer.borderColor = UIColor.blue.cgColor
//           changepswBtn.layer.borderWidth = 0.5
//           changepswBtn.layer.masksToBounds = true
//           bookmarkbtn.layer.cornerRadius = 2.0
//           bookmarkbtn.layer.borderColor = UIColor.blue.cgColor
//           bookmarkbtn.layer.borderWidth = 0.5
//           changepswBtn.layer.masksToBounds = true
//           setting.layer.cornerRadius = 2.0
//           setting.layer.borderColor = UIColor.blue.cgColor
//           setting.layer.borderWidth = 0.5
//          }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
