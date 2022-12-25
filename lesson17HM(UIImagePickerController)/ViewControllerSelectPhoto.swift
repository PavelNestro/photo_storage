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
    var stringArray: [String] = []
    var photoArrayDone: [UIImage?] = []
    var arrayUserClass:[User] = []
    var current = 0
    var stringIndexPath = ""
    var imageLike = false
    var imageComments = true
    var string = ""
    var name = ""
    var selectedIndexPath: IndexPath?
    var pageControl = UIPageControl()
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


        
       //--проверка объектов класса-------то что потом можно удалить
          arrayUserClass = user.load(.keyForUserArray)
         print("колличество объектов класса \(arrayUserClass.count)")
         print(arrayUserClass.map({$0.nameImageforLike}))
      // -------------------------------------------------------------//

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        view.addSubview(viewCustom)
        
        guard let lastValue = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.stringArrayNameImage.rawValue) else {
            return
        }
        stringArray = lastValue
        photoArrayDone = getArrayImage(stringArray)
        print("названия картинок которые дожны продолжаться \(stringArray)")
        print(stringArray.count)
// ----------------------------------------------------------- добавил кусок кода для проверки удаляет ли фото
//        guard let imageNames = try? fileManager.contentsOfDirectory(atPath: cacheFolderURL.path) else {
//            return
//        }
//              print(imageNames)
//        stringArray = imageNames
//        stringArray.remove(at: 0)
//        photoArrayDone = getArrayImage(stringArray)
//
//        print("Проверяю сколько сейчас картинок после удаления \(photoArrayDone.count) и названия \(stringArray.count)")
// -------------------------------------------------------------

    }
    
    @IBAction func selectedPhotoPressed(_ sender: Any) {
          showChooseMediaAlert()
    }
    
    
    @IBAction func deletePhotoButtonPressed(_ sender: Any) {
        deletePhoto(stringArray[selectedIndexPath?.item ?? Int()])
        
    }
    
    func deletePhoto(_ nameImage: String) {
     //   if selectedIndexPath == nil {
        if fileManager.fileExists(atPath: cacheFolderURL.path) { // существует ли файл по указанному пути где imagesFolderURL.path путь к нашей папку с картинками
            do {
                let imageNames = try fileManager.contentsOfDirectory(atPath: cacheFolderURL.path) // .contentsOfDirectory получаем доступ к списку имен файлов где они лежат
                print(imageNames)
                guard let name = imageNames.filter({$0 == nameImage}).first else {
                    return
                }
                    let imageURL = cacheFolderURL.appendingPathComponent(name)
                 try fileManager.removeItem(at: imageURL)
                 // удаление файлов
            } catch {
                print(error.localizedDescription)
            }
            
    }
        print("картинки удалена")
    
        

    }
    
    
    func picker() {
        let picker = UIImagePickerController() //команда чтобы появилась наша галлерея фотографий в телефоне
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

        func getArrayImage(_ arrayString:[String]) -> [UIImage?]  {
                     //print(arrayString)
                    var savedImages: [UIImage] = [UIImage]()
            
                    for name in arrayString {
                        let imageURL = cacheFolderURL.appendingPathComponent(name)
                        do {
                            let imageData = try Data(contentsOf: imageURL)
                            
                            if let images = UIImage(data: imageData) {
                                savedImages.append(images)
                                 //print(savedImages)
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
        alert.addAction(UIAlertAction(title: "Media library", style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        present(alert, animated: true)
      }

    func saveImageForCollectionView(_ image: UIImage?) {
        string = saveImageToFolder(image)
        stringArray.append(string)
        UserDefaults.standard.setValue(stringArray, forKey: .stringArrayNameImage)
        
        guard let lastValue = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.stringArrayNameImage.rawValue) else {
            return
        }
        stringArray = lastValue
        photoArrayDone = getArrayImage(stringArray)
        collectionView.reloadData()
        let user = User()
        user.nameImageforLike = string
        self.arrayUserClass.append(user)
        print(arrayUserClass.count)
        user.save(arrayUserClass, .keyForUserArray)
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

//----------------------------------------ЗАКАНЧИВАЮТСЯ ФУНКЦИИ_______--------------------------//
    //-----------------------------------------------------------------------------------

}
extension ViewControllerSelectPhoto: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ piker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("image was selected") 
        let image = info[.editedImage ] as? UIImage
        imageView.image = image
        saveImageForCollectionView(image)
        piker.dismiss(animated: true)
        
    }
}

extension ViewControllerSelectPhoto: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stringArray.count
    }
    

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
        return UICollectionViewCell()
    }
    if photoArrayDone.isEmpty {
        cell.imageView.image = imageView.image
        stringArray.removeAll()
        photoArrayDone.removeAll()
        arrayUserClass.removeAll()
    } else {
        cell.imageView.image = photoArrayDone[indexPath.item]
        cell.textLabel.text = "\(stringArray[indexPath.item])"

    }
    cell.backgroundColor = .black
       return cell
    }
}


extension ViewControllerSelectPhoto: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(stringArray[indexPath.item])
        viewCustom.imageDidTapHandler = {
            print("Image did tapped")
            self.saveLike(self.stringArray[indexPath.item])
            self.changeLike()
       }
        viewCustomButtonComments.imageDidTapHandler = {
            print("ImageComments did tapped")
            self.createCommentViewController()
        }
        //--------------------------кусок вставил
        let arrayBool = arrayUserClass.map({$0.likeImage})
        imageLike = arrayBool[indexPath.item]
        chekLike()
        chekeComment()
        print(imageLike)
        //----------------------------
        if selectedIndexPath == nil {
            selectedIndexPath = indexPath
            swipeHorizontal()
            name = stringArray[indexPath.item]
            UserDefaults.standard.setValue(name, forKey: .test)
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
        let x = targetContentOffset.pointee.x
        let item = Int(x / view.frame.width)
        imageLike = arrayBool[item]
        print("current cell: \(item)")
        print("название картинки для предачи коммента\(stringArray[item])")
        name = stringArray[item]
        UserDefaults.standard.setValue(name, forKey: .test)
        if selectedIndexPath != nil {
            chekLike()
        }
        viewCustom.imageDidTapHandler = {
            print("Image did tapped")
            self.saveLike(self.stringArray[item])
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
