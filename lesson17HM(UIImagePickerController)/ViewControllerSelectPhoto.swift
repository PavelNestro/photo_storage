//
//  ViewControllerSelectPhoto.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 7.08.22.
//

import UIKit
import AVKit
class ViewControllerSelectPhoto: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewCustomButtonComments: ViewCustomButtonComments!
    @IBOutlet weak var viewCustom: ViewCustom!
    @IBOutlet weak var collectionView: UICollectionView!
    static let sheard = ViewControllerSelectPhoto()

    let user = User()
    let imageView = UIImageView()
    var message = [Comments]()
    var arrayNameImage: [String] = []
    var arrayPhotoDone: [UIImage?] = []
    var arrayUserClass: [User] = []
    var arrayUserNameProfile: [UserNameProfile] = []
    var imageLike = false
    var imageComments = true
    var string = ""
    var nameImage = ""
    var password = "123"
    var selectedIndexPath: IndexPath?
    var cellSize: CGSize {
    var minimumLineSpacing: CGFloat = 0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        minimumLineSpacing = flowLayout.minimumLineSpacing
        }
        let width = (collectionView.frame.width - minimumLineSpacing) / 2
        return CGSize(width: width, height: width)
    }

    private let fileManager = FileManager.default
    private lazy var cacheFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var imagesFolderURL = cacheFolderURL.appendingPathComponent("images")

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        viewCustom.imageView.image = nil
        viewCustomButtonComments.imageView.image = nil
        view.addSubview(viewCustom)
        loadUserProfile(password)
    }

    @IBAction func selectedPhotoPressed(_ sender: Any) {
          showChooseMediaAlert()
    }

    @IBAction func deletePhotoButtonPressed(_ sender: Any) {
        deletePhoto(nameImage)
        deletedObjectUser(nameImage)
    }

    func deletePhoto(_ nameImage: String) {
// существует ли файл по указанному пути где imagesFolderURL.path путь к нашей папку с картинками
if fileManager.fileExists(atPath: cacheFolderURL.path) {
            do {
// .contentsOfDirectory получаем доступ к списку имен файлов где они лежат
let imageNames = try fileManager.contentsOfDirectory(atPath: cacheFolderURL.path)
                print(imageNames)
                guard let name = imageNames.filter({$0 == nameImage}).first else {
                    return
                }
                    let imageURL = cacheFolderURL.appendingPathComponent(name)
                 try fileManager.removeItem(at: imageURL)

            } catch {
                print(error.localizedDescription)
            }
    }
        print("картинка удалена")

    }
    func deletedObjectUser(_ string: String) {
        arrayUserClass.removeAll(where: { $0.nameImageforLike == string })
        user.save(arrayUserClass, .keyForUserArray)
        let lastValue = user.load(.keyForUserArray)
                arrayUserClass = lastValue
                arrayNameImage = arrayUserClass.map({$0.nameImageforLike})
                arrayPhotoDone = getArrayImage(arrayUserClass)
                collectionView.reloadData()

        }

    func picker() {
        let picker = UIImagePickerController() // команда чтобы появилась наша галлерея фотографий в телефоне
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func saveImageToFolder(_ image: UIImage?) -> String {
        guard let image = image else {
            return String()
        }
        let imageData = image.pngData() // pngData это нолики и еденицы
        let dateString = Int(Date().timeIntervalSince1970)
        let imagesURl = cacheFolderURL.appendingPathComponent("\(dateString).png")
        fileManager.createFile(atPath: imagesURl.path, contents: imageData, attributes: [:])

        return "\(dateString).png"
}

        func getArrayImage(_ userArray: [User]) -> [UIImage?] {
                    var savedImages: [UIImage] = [UIImage]()

            for name in userArray.map({$0.nameImageforLike}) {
                        let imageURL = cacheFolderURL.appendingPathComponent(name)
                        do {
                            let imageData = try Data(contentsOf: imageURL)
                            if let images = UIImage(data: imageData) {
                                savedImages.append(images)
                            }
                        } catch {
                            print(error.localizedDescription)
                }
        }
            return savedImages
        }

    func showChooseMediaAlert() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController(title: "Choose media sourse", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Media library",
                                      style: .default,
                                      handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        present(alert, animated: true)
      }

    func saveImageForCollectionView(_ image: UIImage?) {
        let objectUser = User()
        string = saveImageToFolder(image)
        objectUser.nameImageforLike = string
        arrayUserClass.append(objectUser)
        objectUser.save(arrayUserClass, .keyForUserArray)
        let lastValue = objectUser.load(.keyForUserArray)
        arrayUserClass = lastValue
        arrayPhotoDone = getArrayImage(arrayUserClass)
        arrayNameImage = arrayUserClass.map({$0.nameImageforLike})
        saveUserProfile(password)
        collectionView.reloadData()
        print(arrayUserClass.count)
    }

    func swipeHorizontal() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            print("сделал свай по горизонта")
            collectionView.isPagingEnabled = true
        }
    }

    func swipeVertically() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            collectionView.isPagingEnabled = false
        }
    }

    func saveLike(_ stringNamePng: String) {
        arrayUserClass = user.load(.keyForUserArray)
        print("колличество объектов класса \(arrayUserClass.count)")
        print(arrayUserClass.map({$0.nameImageforLike}))
        guard let objectUser = arrayUserClass.filter({$0.nameImageforLike == stringNamePng}).first else {
            return
        }
        objectUser.likeImage = !objectUser.likeImage
        user.save(arrayUserClass, .keyForUserArray)
        saveUserProfile(password)
        print(arrayUserClass.map({$0.likeImage}))
    }

    func saveComment(_ stringNamePng: String) {
        arrayUserClass = user.load(.keyForUserArray)
        print("колличество объектов класса \(arrayUserClass.count)")
        print(arrayUserClass.map({$0.nameImageforLike}))
        guard let objectUser = arrayUserClass.filter({$0.nameImageforLike == stringNamePng}).first else {
            return
        }
        objectUser.comments = message
        user.save(arrayUserClass, .keyForUserArray)
        saveUserProfile(password)
        print(arrayUserClass.map({$0.comments}))
    }

    func chekLike() {
        if imageLike == true {
            viewCustom.imageView.image = viewCustom.image
            viewCustom.imageView.tintColor = .red
            print("red")
        } else {
            viewCustom.imageView.image = viewCustom.image
            viewCustom.imageView.tintColor = .systemGray
            print("gray")
        }
    }

    func changeLike() {
        imageLike = !imageLike
        if imageLike == true {
            viewCustom.imageView.tintColor = .red
            print("Красный")
        } else {
            viewCustom.imageView.tintColor = .systemGray
            print("Серый")
        }
    }

    func chekeComment() {
        imageComments = !imageComments
        if imageComments == true {
            viewCustomButtonComments.imageView.image = viewCustomButtonComments.image
            viewCustomButtonComments.imageView.tintColor = .white
            print("Белый")
        } else {
            viewCustomButtonComments.imageView.image = viewCustomButtonComments.image
            viewCustomButtonComments.imageView.tintColor = .systemGray
            print("Серый")
        }
    }

   func createCommentViewController() {
        let viewController = ViewControllerFactory.sheard.createCommentViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func saveUserProfile(_ password: String) {
        arrayUserNameProfile = UserNameProfile.sheard.loadUserProfile(.keyUserProfile)
        print("количество объектов класса UserNameProfile \(arrayUserNameProfile.count)")
        arrayUserClass = user.load(.keyForUserArray)
        if let objectProfile = arrayUserNameProfile.filter({$0.password == password}).first {
            objectProfile.user = arrayUserClass
            UserNameProfile.sheard.saveUserProfile(arrayUserNameProfile, .keyUserProfile)
        } else {
            print("нет такого пароля")
        }

    }

    func loadUserProfile(_ password: String) {
        arrayUserNameProfile = UserNameProfile.sheard.loadUserProfile(.keyUserProfile)
        if let objectProfile =  arrayUserNameProfile.filter({$0.password == password}).first {
            arrayUserClass = objectProfile.user
            user.save(arrayUserClass, .keyForUserArray)
            arrayUserClass = user.load(.keyForUserArray)
            print(arrayUserClass.map({$0.nameImageforLike}))
            print(arrayUserClass.map({$0.likeImage}))
            arrayNameImage = arrayUserClass.map({$0.nameImageforLike})
            arrayPhotoDone = getArrayImage(arrayUserClass)
        } else {
            print("нет такого пароля")
        }
    }

}

extension ViewControllerSelectPhoto: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ piker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("image was selected")
        let image = info[.editedImage ] as? UIImage
        imageView.image = image
        saveImageForCollectionView(image)
        piker.dismiss(animated: true)

    }
}

extension ViewControllerSelectPhoto: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNameImage.count
    }

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier,for: indexPath) as? CustomCollectionViewCell else {
        return UICollectionViewCell()
    }
    if arrayPhotoDone.isEmpty {
        cell.imageView.image = imageView.image
        arrayNameImage.removeAll()
        arrayPhotoDone.removeAll()
        arrayUserClass.removeAll()
    } else {
        cell.imageView.image = arrayPhotoDone[indexPath.item]
        cell.textLabel.text = "\(arrayNameImage[indexPath.item])"

    }
    cell.backgroundColor = .black
       return cell
    }
}

extension ViewControllerSelectPhoto: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(arrayNameImage[indexPath.item])
        viewCustom.imageDidTapHandler = {
            print("Image did tapped")
            self.saveLike(self.arrayNameImage[indexPath.item])
            self.changeLike()
       }
        viewCustomButtonComments.imageDidTapHandler = {
            print("ImageComments did tapped")
            self.createCommentViewController()
        }
        // --------------------------кусок вставил

        let arrayBool = arrayUserClass.map({$0.likeImage})

        print(arrayBool)
        imageLike = arrayBool[indexPath.item]
        chekLike()
        chekeComment()
        print(imageLike)
        // ----------------------------
        if selectedIndexPath == nil {
            selectedIndexPath = indexPath
            swipeHorizontal()
            nameImage = arrayNameImage[indexPath.item]
            UserDefaults.standard.setValue(nameImage, forKey: .keyForComments)
        } else {
            selectedIndexPath = nil
            swipeVertically()
            viewCustom.imageView.image = nil
            viewCustomButtonComments.imageView.image = nil
        }
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let arrayBool = arrayUserClass.map({$0.likeImage})
        let xOrigin = targetContentOffset.pointee.x
        let item = Int(xOrigin / view.frame.width)
        imageLike = arrayBool[item]
        print("current cell: \(item)")
        nameImage = arrayNameImage[item]
        UserDefaults.standard.setValue(nameImage, forKey: .keyForComments)
        if selectedIndexPath != nil {
            chekLike()
        }
        viewCustom.imageDidTapHandler = {
            print("Image did tapped")
            self.saveLike(self.arrayNameImage[item])
            self.changeLike()
       }
    }
}

extension ViewControllerSelectPhoto: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndexPath != nil {
            return collectionView.frame.size
        } else {
            return cellSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if selectedIndexPath == nil {
          return 5
        } else {
          return 0
        }
    }
}

extension ViewControllerSelectPhoto: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       print("сработала кнопка return на клавиатуре")
        return true
    }
}
