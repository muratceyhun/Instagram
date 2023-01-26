//
//  MainTabBarController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 10.09.2022.
//

import Foundation
import UIKit
import Firebase


class MainTabBarController : UITabBarController {
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        self.delegate = self
        
        
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let logInController = LogInController()

                let navController = UINavigationController(rootViewController: logInController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return

        }
        
        goesToUserProfile()
    }
    
    func goesToUserProfile(){
        
        let mainNavController = formNavController(unselectedIcon: UIImage(imageLiteralResourceName: "Main_Unselected"), selectedIcon: UIImage(imageLiteralResourceName: "Main_Selected"), rootViewController: MainController(collectionViewLayout: UICollectionViewFlowLayout()))
                
        let searchNavController = formNavController(unselectedIcon: UIImage(imageLiteralResourceName: "Search_Unselected"), selectedIcon: UIImage(imageLiteralResourceName: "Search_Selected"),rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
   
        
        let addNavController = formNavController(unselectedIcon: UIImage(imageLiteralResourceName: "Add_Unselected"), selectedIcon: UIImage(imageLiteralResourceName: "Add_Unselected"))
        
        let likeNavController = formNavController(unselectedIcon: UIImage(imageLiteralResourceName: "Like_Unselected"), selectedIcon: UIImage(imageLiteralResourceName: "Like_Selected"))
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileNavController.tabBarItem.image = UIImage(imageLiteralResourceName: "Profile_Chosen")
        userProfileNavController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "Profile")
        tabBar.tintColor = .black
        
        
viewControllers = [mainNavController,searchNavController,addNavController,likeNavController,userProfileNavController]

        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }



    }
    
    
    fileprivate func formNavController(unselectedIcon : UIImage, selectedIcon : UIImage, rootViewController : UIViewController = UIViewController()) -> UINavigationController {
        
        let rootController = rootViewController
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = unselectedIcon
        navController.tabBarItem.selectedImage = selectedIcon
        
        return navController
        
    }
    
}



extension MainTabBarController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let choosingPhotoController = ChoosingPhotoController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: choosingPhotoController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}
