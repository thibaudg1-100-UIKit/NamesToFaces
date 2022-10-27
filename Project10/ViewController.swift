//
//  ViewController.swift
//  Project10
//
//  Created by RqwerKnot on 15/10/2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to find PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let imageUrl = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: imageUrl.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
                       
        let ac = UIAlertController(title: person.name, message: nil, preferredStyle: .actionSheet)
        
        let rename = UIAlertAction(title: "Rename", style: .default) { [weak self, weak person] _ in
            guard let person = person else { return } // necessary?
            
            self?.rename(person)
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(rename)
        ac.addAction(delete)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    
    func rename(_ person: Person) {
        let ac = UIAlertController(title: "Rename me", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let action = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            
            person.name = newName
            
            self?.collectionView.reloadData()
        }
        
        ac.addAction(action)
        
        present(ac, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}

