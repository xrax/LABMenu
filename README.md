# LABMenu


Simple Left Menu. Just create your customized view and put it in.

<p align="center">
    <a href="#requirements">Requirements</a> • <a href="#installation">Installation</a> • <a href="#usage">Usage</a> • <a href="#contribution">Contribution</a> • <a href="#contact">Contact</a> • <a href="#license-mit">License</a>
</p>

## Requirements

- iOS 10.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

#### CocoaPods

Install CocoaPods if it is not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add _LabMenu_:

``` bash
$ cd /path/to/MyProject
$ nano Podfile

platform :ios, '11.0'
use_frameworks!

target 'MyProject' do
 pod 'LABMenu', :git => 'https://github.com/xrax/LABMenu.git'
end
```

Install it into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import LABMenu` framework into your files.

## Usage

In order to usage this pod, you should understand it a bit. 

You need a ViewController as Container where all this pod works.

To works this container need some things:
    * Inherits from LABMenuViewController.
    * Set menuView properties before super.viewDidLoad() call.
    * Create a customized menu inherits from LABMenuContainer.
    * Set your customized menu as contentView calling menuView.setContentView(contentView:) function.
    * Set your customized menu button with a UIBarButtonItem or just with an image.
    * (Optional) Set your customized back button with a UIBarButtonItem. If you don't a "<" will show as default.
    * Push your viewControllers using pushViewController() function in your Container ViewController.

From this point, all viewControllers inside LABMenu are in an "internalNavigationController", but all viewControllers outside LABMenu are in the same navigationController as your Container ViewController.

As example, a viewControllers hierachy should looks like:

- NavigationController
    - LauncherViewController
    - LoginViewController
    - ContainerViewController
        - internalNavigationController
            - HomeViewController
            - ProfileViewController

This project have 4 screens: Launcher, Login, Home and Profile. Only Home and Profile are into Container.


* Step by step!

Create your custom menu view. For example (load from xib):

![xib file](https://github.com/xrax/LABMenu/blob/master/MenuView.png)

Create a swift file for your Menu. Inherit it from 'LABMenuContainer'. Set File's Owner class as that menu class.

![Files Owner](https://github.com/xrax/LABMenu/blob/master/FilesOwner.png)
![Setting Class](https://github.com/xrax/LABMenu/blob/master/SettingClass.png)

Implements the required init and override the 'init(delegate: LABMenuContainerDelegate)'. In overriden init call 'super.init(delegate:)' and call your xib with 'Bundle.main.loadNibNamed' function. Set the root view and implements all aspects and functionallities wanted in your Menu.
```swift
import UIKit
import LABMenu

class MyMenu: LABMenuContainer {
    
    fileprivate let sections: [String] = ["Main", "Options"]
    fileprivate let items: [[String]] = [["Home", "Profile"], ["Settings", "Options"]]
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var icUser: UIImageView!
    @IBOutlet weak var icUserName: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(delegate: LABMenuContainerDelegate) {
        super.init(menuProportionalWidth: 0.8, delegate: delegate)
        Bundle.main.loadNibNamed("MyMenu",
                                 owner: self,
                                 options: nil)
        
        self.view!.frame = CGRect(origin: CGPoint.zero,
                                  size: frame.size)
        self.addSubview(self.view!)
        
        self.delegate = delegate
    }
    
    @IBAction func closeSession(_ sender: Any) {
        NSLog("Session closed")
    }
}

extension MyMenu: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default,
                                   reuseIdentifier: nil)
        
        cell.textLabel!.text = items[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectItemAt(indexPath: indexPath)
    }
}
```

Note in the super.init call a menuProportionalWidth parameter, it have allowed values between 0 and 1. Same value should will set in LABMenuViewController constructor below.

In your storyboard embed your "ContainerViewController" in a NavigationController, and create all view controllers neededs.

![storyboard](https://github.com/xrax/LABMenu/blob/master/storyboard.png)

Then just inherit the "ContainerViewController" from 'LABMenuViewController', and override viewDidLoad. You can set all LABMenuController atributes before super.viewDidLoad() call:

```swift
class ViewController: LABMenuViewController {

	override func viewDidLoad() {
        // menuView properties
        barColor = .lightGray
        barTintColor = .white
        menuProportionalWidth = 0.8
        hideMenuButtonWhenShow = true
        backPosition = .left

        super.viewDidLoad()
    }
}
```
* barColor: Set the navigationBarColor and can change statusBar style too. If you need a specific statusBar style should set it after super.viewDidLoad() call.
* barTintColor: Set the tint of navigationItems.
* menuProportionalWidth: Allow values between 0 and 1. Represent a proportional width respect to screen. Same value should was set in LABMenuContainer super.init() call above.
* hideMenuButtonWhenShow: Set it as true if you want hide menu button when menu is open.
* backPosition: Set the position of back button. If is .left menu button will be replaced to back button when appear a viewController different of root.

In viewDidLoad function you must set your Menu class: 

```swift
	override func viewDidLoad() {
        // menuView properties
        barColor = .lightGray
        barTintColor = .white
        menuProportionalWidth = 0.8
        hideMenuButtonWhenShow = true
        backPosition = .left

        super.viewDidLoad()
        
        menuView.setContentView(contentView: MyMenu(delegate: self))
        // Just set the image in the Menu BarButtonItem
        setMenuButton(image: #imageLiteral(resourceName: "icMenu"))
        // Or this to set a customized BarButtonItem
        setMenuButton(button: UIBarButtonItem(customView: myCustomizedView))
        // You can set the image in the BackButton else it show a simple '<'
        setBackButton(button: #imageLiteral(resourceName: "icBackButton"))
        
        let homeViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
        self.pushViewController(homeViewController,
                                animated: true)
    }
```

- setContentView(contentView:), with your custom menu view.
- setMenuButton(image:), with your menu button image.
- setMenuButton(button:), with your customized menu button.
- setBackButton(button:), with your back button image.
- Instantiate your first ViewController and push it.


![home](https://github.com/xrax/LABMenu/blob/master/HOME.png)
![menu](https://github.com/xrax/LABMenu/blob/master/MENU.png)
![profile](https://github.com/xrax/LABMenu/blob/master/PROFILE.png)
![nmenu](https://github.com/xrax/LABMenu/blob/master/NMenu.png)

## To Consider

- You must create a viewController as containerViewController. Then you must use the pushViewController function to push a new viewController into LABMenuContainer, or onBackClick to go back to the previous one.
- To add a menu button you must call setMenuButton function in the containerViewController.
- In containerViewController you must add the first (root) viewController using pushViewController function.
- LABMenuContainer verifies that a viewController to push its not already in the current queue. All viewControllers must have a viewController class as owner.


## Contribution

All contributions are welcome. Just contact us.

## Contact

Leonardo Armero Barbosa
 - [limpusra@gmail.com](mailto:limpusra@gmail.com)
Luis Alejandro Barbosa Lee
 - [alejobarbosalee@gmail.com](mailto:alejobarbosalee@gmail.com)

## License (MIT)

 MIT License

Copyright (c) 2017 Leonardo Armero Barbosa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
