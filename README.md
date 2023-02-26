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

## Dev Guide
The developer guide is located at `Peggle/Documentation/DeveloperGuide.md`.
The guide includes diagrams that are fetched from a remote origin, so it
may take a brief moment to load all the images.

## Rules of the Game

### Ball Launch & Cannon Direction
The ball can be launched by (1) holding down on the screen and dragging your finger
across the game view and (2) releasing your finger to fire the ball towards the
release position. The cannon follows the position of the finger when the finger
is being dragged across the screen and thus provides a good visual indicator for
where the ball will be fired towards.

### Win and Lose Conditions
The win condition differs depending on which game mode the player chooses.

#### Normal Mode
The player must clear all red pegs on the board within 10 lives. The player wins
once they clear all red pegs before the end of their last life. If the player exhausts
their last life and has not yet cleared all red pegs, they lose.

#### Beat the Score Mode
The player must accrue points to the given target score before the timer runs out. The
time limit and the target score varies depending on the number of pegs on the board;
generally, more pegs equates to longer time limit and higher target score. If the player
reaches the target score before the timer runs out, they win, and otherwise, they lose.

#### Siam Left, Siam Right
The player must make three bucket shoots without touching a single peg. The player starts
off with three lives and, as with all other game modes, gains an extra life if they successfully
shoot into the bucket. If either the player fails to make three bucket shots before exhausting
their last life or touches a single peg with the ball, they lose, and otherwise, they win.


## Level Designer Additional Features

### Peg Rotation
A peg must first be selected in order to be able to rotate it. This can be achieved by tapping
on the peg on the game board. Once tapped, the rotation slider in the palette becomes enabled,
allowing the player to rotate the peg.

### Peg Resizing
In the same vein as above, a peg must first be selected in order to be able to resize it. This can be achieved by tapping on the peg on the game board. Once tapped, the size slider in the palette
becomes enabled, allowing the player to resize the peg.

## Bells and Whistles

### Minecraft Theme
Most notably, the theme of the application is Minecraft. It is rather cohesive and provides a
pleasant user experience to the player. This styling spans across the menu, the font, the game items,
and the game particle effects.

### Score System
A score system has been implemented following the one given in the problem set instructions. Each peg
has a unique score and the total score is computed by adding up the score of each peg and multiplying
it by the score multiplier value (which is determined by the number of red pegs remaining).

### Displaying the number of pegs and blocks in the level designer
The level designer shows an overview of the number of pegs and blocks that are currently placed in the
board. This helps the player get a better understanding of the state of their game at a glance.

### Displaying game statistics in the game player
The game player shows an overview of the game statistics, such as number of pegs remaining, time
remaining, total score, as well as the selected game mode. This provides a more immersive experience to
the user as they become more aware of their game performance.

### Timer that results in a game over
If the timer runs out during a game, the game ends and the player loses. The player is greeted with a
modal through which they are able to head to the main menu or back to the level designer.

### Particle effects
The game player displays particle effects upon certain events; specifically, the explosion particle
effect of the Kaboom character and the spirit particle effect of the Spooky character. A particle effect
can be initialised via `ParticleEffectGameObject`, which makes the implementation extensible as new
particle effects can be added easily.

## Tests

### Unit Tests
The XCode project includes unit tests for the models of
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
    - Red peg button
        - When tapped, a semi-transparent white overlay should appear over the button.
    - Green peg button
        - When tapped, a semi-transparent white overlay should appear over the button.
    - Block button
        - When tapped, a semi-transparent white overlay should appear over the button.
    - Delete button
        - When tapped, a semi-transparent white overlay should appear over the button.
- Test board view
    - If a peg palette button is selected
        - When tapped, if the tap position does not overlap with another peg or block and does not overflow the board, a peg of the selected type should be created at the tap position.
        - When tapped, if the tap position does not overlap with another peg or block and does overflow the board, a peg of the selected type should not be created at the tap position.
        - When tapped, if the tap position does overlap with another peg or block and does not overflow the board, a peg of the selected type should not be created at the tap position.
        - When tapped, if the tap position does overlap with another peg or block and does overflow the board, a peg of the selected type should not be created at the tap position.
    - If a block palette button is selected
        - When tapped, if the tap position does not overlap with another peg or block and does not overflow the board, a block of the selected type should be created at the tap position.
        - When tapped, if the tap position does not overlap with another peg or block and does overflow the board, a block of the selected type should not be created at the tap position.
        - When tapped, if the tap position does overlap with another peg or block and does not overflow the board, a block of the selected type should not be created at the tap position.
        - When tapped, if the tap position does overlap with another peg or block and does overflow the board, a block of the selected type should not be created at the tap position.
- Test palette sliders
    - If a peg or block is currently selected, the sliders should be enabled and should not have a white overlay.
    - Resize slider
        - If a peg or block is currently selected, sliding the resize slider should resize the object
        accordingly. The peg or block should not be resized such that it overlaps or overflows.
    - Rotation slider
        - If a peg or block is currently selected, sliding the rotation slider should rotate the object
        accordingly. The peg or block should not be rotated such that it overlaps or overflows.
- Test peg view
    - Tap gesture
        - If the delete peg palette button is selected, the tapped peg should be deleted.
        - If the delete peg palette button is not selected, the tapped peg should be selected and the sliders should be enabled.
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
    - Should display proper collision with pegs and blocks and bounce off in a reasonable manner (parabolic trajectory).
    - Should bounce off the top and the sides of the physics world.
    - Should disappear once it collides with the bottom of the physics world if the game mode if the ball is not in spooky mode.
    - Should be affected by peg explosions.
- Test peg
    - Should not be affected by gravity.
    - Should not move during collision with the ball.
    - Should glow up once collided with the ball.
    - Should disappear if in constant collision for too long with the ball.
    - Should disappear if the ball exits the physics world (game over) and if the peg is lit.
    - Should fade away and scale larger upon disappear.
    - Spooky peg
        - Should turn the ball into a spooky ball upon first collision
        - SHould not turn the ball into a spooky ball upon subsequent collisions
    - Kaboom peg
        - Should explode and affect the trajectory of the ball upon collision
        - Should be removed from the board and not remain in the physics world after explosion.
        - Should destroy surrounding pegs.
        - SHould propagate explosion to other Kaboom pegs after a short delay.
- Test block
    - Should not be affected by gravity.
    - Should not move during collision with the ball.
    - Should disappear if in constant collision for too long with the ball.
    - Should fade away and scale larger upon disappear.
- Test game mode
    - Normal mode
        - Should maintain number of lives in the game statistics view.
        - Should lead to win condition if all red pegs are destroyed before all lives are exhausted.
        - Should lead to lose condition if all red pegs are not destroyed before all lives are exhausted.
    - Beat the score mode
        - Should maintain timer in the game statistics view.
        - Should lead to win condition if total score exceeds given target score before timer is exhausted.
        - Should lead to lose condition if total score does not exceed given target score before timer is exhausted.
    - Siam left, siam right mode
        - Should maintain lives and bucket shoot count in the game statistics view.
        - Should lead to win condition if bucket shoot count reaches three before all lives are exhausted.
        - Should lead to lose condition if bucket shoot count does not reach three before all lives are exhausted.

## Written Answers

### Reflecting on your Design

To be frank, I do not think I did not design my code well in my previous problem sets. I did not fully understand how to apply MVVM and ended up abusing it in a really poor way. Despite knowing that it would be extremely tedious, I took it upon myself to redo the architecture and redesign the level designer in such a way that it would be much easier to work with in PS4. I achieved this by creating one central view model for the level designer. This implementation was a huge improvement over the previous implementation as it centralised all the necessary information and operations within one entity, preventing the need to access multiple differentt view models.

Some technical debt that remains in this problem set is how subclassing is currently handled. There are parts in the implementation that deduce the type of an object by checking their enum type or typecasting them, which is not very scalable. I had attempted to resolve this issue but had trouble doing so because it was a lot more layered than I had initially thought; I had traced the issue all the way down to how the data was being encoded and persisted. I also believe that I may have abused protocols throughout the implementation, as I was too focused on dependency inversion and ended up creating a lot of empty protocols. A better solution may have just been to use classic OOP inheritance.

If I could redo the entire application, I would not make the mistake of splitting up the view model, as I ended up spending a lot of time and effort in merely refactoring the application. I would also try to understand protocols better and use them more effectively, as currently, protocols are causing more problems than they are solving them. Another change I would possibly make is to better understand design patterns, especially anti-patterns. I initially did not know that the singleton design pattern was an anti-pattern and ended up abusing it in my initial design. Had I known better starting out, I would have avoided this implementation.