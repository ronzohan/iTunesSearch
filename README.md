# iTunesSearch
## Architecture:
#### Coordinator-MVVM
Coordinators are the objects which control the navigation flow of our application. They help to:

* isolate and reuse ViewControllers
* pass dependencies down the navigation hierarchy
* define use cases of the application

Image below shows how a coordinator is used to define on what ViewController will be shown:
![Image of Yaktocat](https://octodex.github.com/images/yaktocat.png)