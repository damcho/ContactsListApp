# ContactList App

## Arquitecture: light VIPER. (No presenter)

### ContactsModuleRouter: in charge of creating the module and routing through the app

### ContactsManager: in charge of communicating with the view controllers and the Data connectors. It is in charge of the business logic of the app

### ContactsListViewController: requests data to the contacts manager and shows it in a list. Contacts can be deleted by swiping on a cell and tapping "delete". A new contact can be created tapping the "+"
### ContactsDetailViewController: can display and edit a contact or can create a new one

### ContactModel: represents a contact

### ContactsAPIConnector: in charge of requesting contacts to the API
### ContactsDecoder: decodes a JSON contact retrieved from the API
### ContactsCoreDataConnector: In charge of requesting and deleting contacts persisted in the app. Images are stored in the file system, and retrieved by an url path stored in the contacts entity in CoreData

## External libraries
### - NVActivityIndicatorView: for activity indicator animations
### - Alamofire for networking

## How to install the app
- check out project
- open a terminal and go to the project's root directory
- type pod install ( pods will be downloaded )
- open the app's workspace file
- compile and run

## Things to improve:
- More unit testing (testing of the network layer and the persistence layer)
- take photo while creating new contact
- improve error handling when creating a contact
- internationalisation
- UI in general



