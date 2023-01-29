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

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

Your answer here
