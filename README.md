# Aquarium

Dependency Injector container implemented for Swift.

One of the things Swift lacks is a dependency injection framework like Spring or NetCore, there are multiple strategies for injecting the dependencies your modules are gonna use.

But maybe you have no Idea what a dependency injector is so, Why ?

Let start from the beggining

## Whats a dependency ? 

Your system will have objects and those objects are gonna need other objects to work.
so when will an object A depend on object B:
 - **A receives B as a Parameter**
 - **A uses B inside some function**
 - **A returns B in some function**
 - **B is not part of the state of A**

Example:
```swift
class LoginViewPresenter {
    private let interceptor: LoginInterceptor
    private var view: LoginView

    init() {
      loginInterceptor = LoginInterceptorImp()
    }

    func showProfileImage() {
        let request = URLRequest("getimage.com")
        interceptor.image(urlRequest: request) { result in
        switch result {
            case .success(let image):
                // update UI or cache image
                view.showProfileImage(image)
            case .failure(let error):
                //show message or nothing
                view.showErrorMessage("Error downloading profile image")
        }
    }
}	
```

## Whats the problem here ?
 - Our code is coupled to the LoginInterceptorImp class that solves the LoginCall
 - If we want to change the LoginInterceptor we need to change this class.
 - A change or bug in LoginInterceptorImp will impact LoginViewPresenter
 - There is a dependency between LoginViewPresenter Package and LoginInterceptorImp Package, do we really need this ?
 - Single Responsability principle is broken here because LoginViewPresenter is responsible of initializing the login interceptor.

Remember the good practices! Clean Code, Clean Architecture, SOLID, GRASP, Component Cohesion and Component Coupling.

**SRP** - We want our clases to change for only one reason!.
in this case given that we have multiple responsabilities inside a class we are breaking this principle.
**OCP** - Our modules should be open for extension, closed for modification; here we are not open for extension, our class is coupled to an implementation of a module and it is being directly impacted by this implementation.
**DIP** - "high level modules should not depend on low level modules", in this case the presenter is a higher level module than a interactor therefore we are also breaking this rule.

## How do we solve this ?
Dependency Injection!!!

Dependency injection is a design pattern used to break dependencies between componentes!
note: Always remember before implementing a design pattern that they solve one problem not all of them!

```swift
class LoginViewPresenter {
    private let interceptor: LoginInterceptor
    private var view: LoginView

    init(interceptor: LoginInterceptor) {
      self.interceptor = interceptor
    }

    func showProfileImage() {
        let request = URLRequest("getimage.com")
        interceptor.image(urlRequest: request) { result in
        switch result {
            case .success(let image):
                // update UI or cache image
                view.showProfileImage(image)
            case .failure(let error):
                //show message or nothing
                view.showErrorMessage("Error downloading profile image")
        }
    }
}	
```
Well now we got it!, we dont depend on LoginInterceptorImp anymore, we use a constructorDependency injection, usually there are multiple injection strategies but always favour contructor strategy, setter and property are not great practices.

