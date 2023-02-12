# CS3217 Problem Set 4

**Name:** Peter Jung

**Matric No:** A0220141E

## Tips
1. CS3217's docs is at https://cs3217.github.io/cs3217-docs. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

## Ball Launch
The ball can be launched by (1) holding down on the screen and dragging your finger
across the game view and (2) releasing your finger to fire the ball towards the
release position. The cannon follows the position of the finger when the finger
is being dragged across the screen and thus provides a good visual indicator for
where the ball will be fired towards.

## Dev Guide
The developer guide is located at `Peggle/Documentation/DeveloperGuide.md`.
The guide includes diagrams that are fetched from a remote origin, so it
may take a brief moment to load all the images.

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
Please explain how the player moves the cannon.

### Win and Lose Conditions
Please explain how the player wins/loses the game.

## Level Designer Additional Features

### Peg Rotation
Please explain how the player rotates the triangular pegs.

### Peg Resizing
Please explain how the player resizes the pegs.

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.

## Tests

### Unit Tests
The XCode project includes unit tests for the models and view models of
the application. Refer to the project files for more information.

### Integration Tests

Below is an exposition on how integration tests will be performed on the application.

#### Level designer

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

#### Game player

- Test start up
    - Should correctly load a level by displaying pegs (1) at the correct position and (2) with the correct type.
    - Cannon should be pointing downwards.
- Test cannon
    - Should follow the position the user is holding down at.
    - Should not point upwards; i.e. the angle of the head of the cannon should not deviate more than ±90 degrees from the original angle.
    - Should turn grey once the ball is fired and the game is in its active state.
    - Should not change angle when the game is in its active state.
    - Should not fire ball when the game is in its active state.
    - SHould turn back to its original colour once the game exits its active state to the idle state.
- Test ball
    - Should be affected by gravity.
    - Should display proper collision with pegs and bounce off in a reasonable manner (parabolic trajectory).
    - Should bounce off the top and the sides of the physics world.
    - Should disappear once it collides with the bottom of the physics world (game over).
- Test peg
    - Should not be affected by gravity.
    - Should not move during collision with the ball.
    - Should glow up once collided with the ball.
    - Should disappear if in constant collision for too long with the ball.
    - Should disappear if the ball exits the physics world (game over) and if the peg is lit.
    - Should fade away and scale larger upon disappear.


## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

#### Renderer as Delegate vs Game Engine as Delegate

One software design tradeoff I made for the game player was for the game engine to handle the refreshing of the display and not the renderer; that is, the game engine would instantiate the `CADisplayLink` and, for every refresh, notify the renderer of a rerender. This also meant that the game engine would keep a weak reference to the renderer via the `GameEngineDelegate` protocol, and not the other way around with `RendererDelegate`.

Using the game engine as a delegate via `RendererDelegate` would allow the renderer to, upon gesture input from the user, delegate any game related logic and operations to the game engine. However, this would make it difficult to synchronised game related events as they happen throughout the lifecycle of a game, as the flow would have to be (1) renderer refreshes, (2) renderer delegates logic operations to game engine, (3) game engine handles logic and returns game state, (4) renderer rerenders view with new game state.

In order to avoid this back-and-forth between the two components, I have decided to use the renderer as a delegate via `GameEngineDelegate`. This way, to update the display, the flow would simply be (1) game engine refreshes, (2) game engine delegates logic operations to game engine, (3) renderer rerenders view with new game state. User gesture handling is also kept quite simple as, in this case, the renderer contains a strong reference to the game engine and therefore can directly operate on the game engine to trigger any necessary operations upon gesture input.

#### Collision Controller vs Object Handles Collision

Another design tradeoff I made for the game player was to implement collision detection and resolution between objects to the objects themselves and not use a collision controller that accepts two physics bodies and handles the collision behaviour.

A collision controller would be give way for a clean implementation as all collision detection and resolution behaviour would be abstracted away behind a single entity. The collision controller would effectively check the types of the two objects that are passed in and, using their position and velocity data, compute the result of the collision. Although this implementation would abstract away the collision logic and keep the rest of the code legible, it would not be a very extensible implementation as it would not be possible to implement additional collision behaviour, should a client of the physics engine API want to introduce a new type of physics body.

This is where the new implementation of delegating the collision handling responsibility to the objects themselves comes in. In my current implementation, the `DynamicCirclePhysicsBody` protocol implements default methods for handling collision with different types of physics bodies (although currently, they are only limited to circular physics bodies). Should a client of the physics engine API want to create a new type of dynamic physics body that extends the `DynamicPhysicsBody` protocol, they could very well do so and implement new collision handling behaviour; this implementation therefore better abides by the open-closed principle. However, one minor disadvantage of this method would be that the client must specify collision handling for every type of physics body that is introduced, though I believe that the benefits gained from the extensibility of this implementation greatly outweighs this disadvantage.
