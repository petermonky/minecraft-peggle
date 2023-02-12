# Peggle Developer Guide

## Introduction

### [Purpose of the Developer Guide](#purpose-of-the-developer-guide)

The purpose of this developer guide is to provide a comprehensive understanding of the architecture, design patterns, and implementation details of Peggle – henceforth, application. It is intended for developers who are:
- familiar with Swift and SwiftUI,
- interested in understanding the inner workings of the application, 
- intending to making further contributions to the application.

The guide is organised into several sections, starting with an overview of the application's architecture and the relationships between its components. The application follows the **Model-View-VidewModel (MVVM)** architectural pattern to separate its domain logic and presentation logic; the guide therefore delves into the details of each component, including the model, view, and view model layers. To demonstrate the extensibility and maintainability of the application, the guide also covers the design patterns and paradigms used throughout development. In order to aid with understanding the relationships between the different components of the application – namely, the flow of data and control between them – the guide also includes diagrams to visually represent inter-component interactions.

### [Application Overview](#application-overview)

The application is intended to function as a clone of the popular video game series [Peggle](https://en.wikipedia.org/wiki/Peggle_(series)). In its current state, however, the application is **limited to the level designer and the game player**; for the purpose of PS3, the level designer has been disabled and only th game player is accessible to the user. Integration between the level designer and the game player will come in the following weeks.

The level designer is used to create and edit Peggle levels. The user is able to select between different types of pegs, place pegs on a board, move them around, and delete them. Created levels can be saved for persistence between sessions, from which they may be retrieved at a later point in time for editing. The game player is used to play created Peggle levels. The user is able to control a cannon on the top of the game view to fire a ball, which will bounce between pegs as per Peggle rules. The user is unable to control the cannon when the game is in its active state.

The level designer is composed of several distinct components: the **board**, the **palette**, the **action**, and the **level list**. The board is responsible for hosting pegs and effectively acts as a canvas on which pegs can be placed, moved, or removed. The palette provides a number of buttons that can be selected to alter the type of action performed upon tapping the board. The action allows the user to perform meta-operations on the levels which they design, such as loading an existing level, saving a new level, and renaming the current level. The level list displays all created levels in chronological order with respect to the date at which they were updated, allowing the user to load and delete past levels.

The game player is composed of three separate components: the **physics engine**, the **game engine**, and the **renderer**. The physics engine is responsible for handling all physics related operations in-game, such as object movement as well as collision detection and resolution. The game engine is responsible for attributing *meaning* to the physics objects and providing an API that is used by the rendere for game logic related operations. The renderer sits on top of the game engine, displaying changes to the user as the game engine delegates the rendering operation to the renderer for every display refresh.

## Architecture

### [High-level Design](#high-level-design)

#### Level designer

![](https://i.imgur.com/zXhSdJy.png)

The level designer adopts an **opinionated version of MVVM**, in which the view interacts with the view model to update the model, with the data manager sitting at the view model layer. The model then notifies the view model of its changes, from which the data binding between the view and the view model allows the view to observe the changes to update itself accordingly. The data manager provides an application programming interface (API) to be used by the view model to load and save data to a **JSON encoded file** for persistence. Though conventionally data management is handled by the model for MVVM, our implementation allows the view model to perform data loading and saving as to focus any domain logic concerns to the view model layer. Below is a brief overview of the roles of each component.

- **View**
    - displays data as bound with the view model
    - handles any presentation logic pertaining to rendering visual components
- **View model**
    - exposes data as bound with the view
    - performs operations as requested by the view
    - handles any domain logic pertaining to user request handling
- **Model**
    - represents and holds data related to the application
    - contains and exposes model-specific operations to be used by the view model
- **Data manager**
    - manages persistence by exposing methods for saving and loading data in device's document directory

#### Game player

![](https://i.imgur.com/xtgZaND.png)

The game player loosesly follows a similar approach to the MV* architecture, where by the renderer manages view related operations and the game engine and physics engine manage model related operations. The renderer accepts a game engine object that is used to receive delegated operations from. The game engine syncs with the device display via `CADisplayLink` and for every refresh, delegates the responsibility of rendering to the renderer. The game engine keeps a reference to the physics engine and updates the state of the physics world with the time interval between each refresh. Below is a brief overview of the roles of each component.

- **Renderer**
    - displays state of the game as delegated by the game engine
    - handles any presentation logic pertaining to rendering visual components
- **Game engine**
    - delegates rendering responsibility to renderer
    - interacts with physics engine with time interval to update state of physics world
- **Physics engine**
    - contains physics objects and manages their physics related states
    - handles physics object manipulations based on physics data and rules

### [Low-level Design](#low-level-design)

#### Level designer

![](https://i.imgur.com/p3HyXEp.png)

As described above in the [application overview](#application-overview), the level designer consists of four main components: board, palette, action, and level list. Each component consists of a view and a view model, which are used to handle the presentation logic and domain logic of the application, respectively. Note how the board and palette consist further components that are the peg and palette button. Although the sub-components are simple enough that they may function as stand-alone views and bind with read-only data, as to maintain symmetry across components, the sub-components have also been created to adopt their own view models.

From the view models, the peg view model and the level list view model  own the peg and level models, respectively. The peg view model owns a peg and thus gains access to its data and methods to perform any necessary peg-related domain logic operations, such as translating a peg, determining inter-peg overlap, and cloning a peg. The level list view model own multiple levels and, similar to the peg view model, gains access to the level's respective data and methods. One should note that, in our current implementation, the level designer view model does **not directly** own the level model, but rather **indirectly**; different attributes of the level model such as ID, title, update date, and pegs, are spread across the level designer's sub-components upon loading a level to split up level-related operations.

The data manager exposes a **single shared instance** that is contained by the level designer view model to be used for saving and loading level data. Other components do not require a reference to the shared instance as the level designer is singlehandedly responsible for any data-related operations. This is made possible via SwiftUI's [`@EnvironmentObject`](https://developer.apple.com/documentation/swiftui/environmentobject) property wrapper that allows sub-views—board, palette, action, and level list views—to gain access to an observable object—level designer view model—as injected by the main view—level designer view.

#### Game player

![](https://i.imgur.com/XRBMntd.png)

As described above in the [application overview](#application-overview), the game player consists of three main components: renderer, game engine, and physics engine. Similiar to the level designer, the renderer contains views that own its own logical unit (game object).

The game engine contains the actual game objects that provide the view components with an interface to perform game related operations. Note here that only the peg game object and the ball game object conform the circle physics body and dynamic circle physics body protocols, respectively, as they require handling of physics related operations. The cannon game object on the other hand does not interact physically with other game objects and therefore does not conform to the physics body protocol. Another noteworthy implementation is how the renderer conforms to the game engine delegate protocol; the game engine contains a reference to the delegate – in this context, the renderer – and for every update the game engine makes, delegates changes to be updated visually to the renderer.

The physics engine consists of a physics world that manages all interactions between physics bodies. The physics world also contains an array of collision data that contains metadata about body-to-body and body-to-frame collisions that occur for every update. The physics body represents a standard object in the physics world, with an id, shape, body, and position. A dynamic physics body is an extension of the physics body and is affected by physics interactions such as gravity and collision. Note here that currently the only physics shape available is the circle physics shape, but the nature of the current implementation allows for other shapes to be implemented just as easily.


### [Component Interactions](#component-interactions)

Below are some noteworthy interactions between components of the application.

#### Level designer

##### Start up

![](https://i.imgur.com/GC9zWZr.png)

On start up, the application creates a level designer view that operates on its view model to load the data. The level designer view modedl first loads the data from the device's local document directory via the data manager, and converts the received array of levels to a set and passes it to the level list view model. This is possible as the level designer view model internally contains a direct reference to the level list view model. From this point forward, the user is able to view that the levels have correctly been loaded by clicking into the level list view.

##### Tap peg palette button

![](https://i.imgur.com/0xV0lFI.png)

Note how multiple view models—palette button view model and palette view model—are sequentially at play. The `@EnvironmentObject` property wrapper allows the palette button view model to interact with the encasing level designer, through which the palette view model is accessed and method called upon. Also, notice that the palette button view model interacts with the peg palette button protocol to delegate the responsibility of updating the palette to the specific peg palette button.

##### Create peg on board

![](https://i.imgur.com/hRdkhzE.png)

The board view makes use of the palette view model on top of its own board view model. The reason for this behaviour is to first fetch the peg factory as stored in the palette to use to generate a peg that is to be placed on the board. To separate concerns pertaining to each logical entity, the board view model then calls a method on the peg view model instead of on the peg model directly to delegate the responsibility of checking for overlaps to the peg view model.

##### Delete peg on board

![](https://i.imgur.com/9OQhQzP.png)

For deletion of a peg, the peg view in fact does not call any methods on its own peg view model, but calls the board view model for peg deletion instead. This is because the peg view model is passed as a parameter for the method that is called on the board view model, as peg view models are uniquely identified by the ID of the peg that they hold; this allows the board view model to use the passed peg view model directly to remove it from its set of peg view models. Note that the above interaction applies the same for when the peg is deleted on tap whilst the peg delete palette button is selected.

##### Translate peg on board

![](https://i.imgur.com/19Cdwoq.png)

The logic for translating a peg on board is quite nuanced, as it does not involve a direct translation of the original peg but of its clone; effectively, translating an existing peg removes the original peg and creates a new peg at the desired location. This implementation is rather convenient as the logic for adding a peg can be reused and therefore abstracts away any necessary validity checks like checking for peg overlap and overflow. Should there ever rise a need to maintain peg identity in the future, this implementation should  remain maintainable as the translation can be performed directly on the original peg with validity checks made manually afterwards.

##### Save current level

![](https://i.imgur.com/xGVzLG0.png)

The domain logic for saving the current level is handled by the level designer view model after the request has been made by tapping the SAVE action button in the action view. The level designer view model adds the current level to the level list view model and saves the entire state of the application—the levels data—by interacting with the shared data manager instance. The logic for adding a level remains the same regardless of whether the level is new or existing, as the level list view model uses a set to store levels and thus simply adds new levels or overwrites any existing levels automatically.

##### Load previous level

![](https://i.imgur.com/sI5E9vD.png)

Loading a previous level involves opening the level list view first via tapping the LOAD action button in the action view, then tapping a level list item to command the level designer view model to load the level by spreading the level attributes across itself, the action view model, and the board view model. Specifically, the level designer view model holds the ID, the action view model holds the title, and the board view model holds the set of pegs.

##### Delete previous level

![](https://i.imgur.com/fyiRhe3.png)

Deleting a level follows a similar logic to saving a level whereby the set of levels in the level list view model is updated in memory, after which the level designer view model performs a save to persist the data.

#### Game player

##### Start up

![](https://i.imgur.com/6CNWKFU.png)

The initialisationn of the game engine occurs independently from that of the renderer. The game engine accepts a level and initialises itself in tandem with the physics engine, instantiating physics objects that represent static peg objects. The renderer accepts the game engine as a parameter for initialisation, setting itself as the delegate to the game engine for accepting delegated rendering operations.

##### Refresh display

![](https://i.imgur.com/kzsQUZD.png)

Refreshing the display is a rather complex process whereby for every refresh, the game engine (1) updates the physics engine, (2) the physics engine handles collisions and physics body movements, (3) the game engine removes blocking and collided pegs, and (4) the game engine delegates the display refresh to the renderer from which the renderer clears and rerenders the view components.

## Design Patterns and Paradigms

This section details the design patterns and paradigms adopted during development to make the implementation more maintainable and extensible.

### [Observer Pattern](#observer-pattern)

One primary pattern that is adopted throughout the appliation is the Observer Pattern. By establishing state bindings between views and view models by (1) publishing observable state in view models via the [`@Published`](https://developer.apple.com/documentation/combine/published) property wrapper, and (2) observing view model state changes from views via the `@EnvironmentObject` and [`@StateObject`](https://developer.apple.com/documentation/swiftui/stateobject) property wrappers. This pattern is not explicitly implemented in the application however, as the property wrappers provided by the SwiftUI API abstract away the actual implementation.

![](https://i.imgur.com/Y1aHMUd.png)

### [Singleton Pattern](singleton-pattern)

As one global data manager is sufficient for the purpose of the application, the current implementation adopts the Singleton Pattern that instantiates only a single instance of a data manager that is used throughout the lifetime of the application. This makes it easy to reason about the state of persistence as only one instance is being used at any point in time. Currently, there exists only one global instance of a shared data manager that is used in the application; however, should there ever rise a need to instantiate more data managers, or even create testing specific data managers with mock data, this can be easily adopted by simply instantiating additional shared instances of the data manager.

![](https://i.imgur.com/O2pI4yW.png)

### [Factory Method Pattern](#factory-method-pattern)

The creation of pegs is handled by a peg factory utility protocol that delegates the instantiation of a peg to concrete sub-class factories. This implementation makes it fairly easy to extend the palette with new types of pegs, as one simply needs to implement concrete factories that generate the new pegs. In the current implementation, the palette view model holds the peg factory that is accessed by the board view to create a new peg, but this implementation may change to elevate the peg factory to the level designer view model instead to make the factory easier and cleaner to access.

![](https://i.imgur.com/8Fn2u4c.png)

### [Dependency Injection Pattern](#dependency-injection-pattern)

In order to reduce coupling between view models, the view models instantiated using dependency injection. For example, the level designer view model does not inherently hold a reference to an instane of the palette, board, action, and level list view models, but receives them as parameters during initialisation. This implementation separates the concerns of constructing objects, making it easier to test the components in isolation as well, as test-specific dependencies may be injected in place of the actual dependencies.

![](https://i.imgur.com/GTkV5NN.png)

### [Delegation Pattern](#delegation-pattern)

The delegation pattern is in place to handle interaction between the game engine and the renderer, specifically the action of refreshing the display. This pattern is implemented as (1) the renderer needs a way to fire events to the game engine for game related logic handling and (2) the game engine has to be able to notify the renderer somehow that the game state has been updated and the display needs refreshing. By using a `weak var`, both entities maintain a reference to each other to facilitate the previously mentioned interaction, whilst avoiding a strong circular reference between the two to allow proper object de-instantiation to take place.

![](https://i.imgur.com/8wLqEHT.png)

## Testing

### [Unit Testing](#unit-testing)

The XCode project includes unit tests for the models and view models of the application. Refer to the project for more information.

### Integration Testing

Below is an exposition on how integration tests will be performed on the application.

- Test palette view
    - Should display a horizontal array of buttons, with peg palette buttons grouped together on the left, and the delete peg palette button located on the right.
- Test palette button view
    - Blue peg button
        - Should be selected by default upon start up.
        - When tapped, a semi-transparent white overlay should appear over the button.
    - Orange peg button
        - When tapped, a semi-transparent white overlay should appear over the button.
    - Delete peg button
        - When tapped, a semi-transparent white overlay should appear over the button.
- Test board view
    - If a peg palette button is selected
        - When tapped, if the tap position does not overlap with another peg and does not overflow the board, a peg of the selected type should be created at the tap position.
        - When tapped, if the tap position does not overlap with another peg and does overflow the board, a peg of the selected type should not be created at the tap position.
        - When tapped, if the tap position does overlap with another peg and does not overflow the board, a peg of the selected type should not be created at the tap position.
        - When tapped, if the tap position does overlap with another peg and does overflow the board, a peg of the selected type should not be created at the tap position.
- Test peg view
    - Tap gesture
        - If the delete peg palette button is selected, the tapped peg should be deleted.
        - If the delete peg palette button is not selected, nothing should happen.
    - Drag gesture
        - If the drag release position does not overlap with another peg and does not overflow the board, the peg should be translated to the release position.
        - If the drag release position does not overlap with another peg and does overflow the board, the peg should not be translated to the release position.
        - If the drag release position does overlap with another peg and does not overflow the board, the peg should not be translated to the release position.
        - If the drag release position does overlap with another peg and does overflow the board, the peg should not be translated to the release position.
    - Long press gesture
        - The peg should be deleted from the board.
- Action view
    - SAVE button
        - When tapped, the current level opened by the level designer should be saved into persistent storage. The saved level should be visible in the level list view.
    - LOAD button
        - When tapped, the level list view should slide in from the right.
        - When tapped, it should dismiss the keyboard if it is open.
    - RESET button
        - When tapped, every peg on the board should be removed.
    - Title text field
        - When tapped, the keyboard should open.
        - When typing in the keyboard, the title of the level should be visibly updated. The title should not be saved into persistent storage unless the SAVE button is tapped afterwards.
    - START button
        - When tapped, nothing should happen.
- Level list view
    - Should display a list of previously created levels.
    - Create new level button
        - When tapped, it should clear the loaded level from the level designer–remove all pegs from the board and clear the title in the action–and redirect the user back to the level designer.
    - Existing level button
        - If one of the previously created levels is open in the level designer, the opened level should be greyed out from the list with the text "Currently open" displayed on the right-side of the item.
        - When tapped, if the tapped level is currently open, nothing should happen.
        - When tapped, it the tapped level is not currently open, it should load the pegs and title of the board into the board and action, respectively, and the user should be redirected back to the level designer.
