# Code Review for Programming Exercise 1 #
REDACTED  
REDACTED  
## Description ##

For this assignment, you will be giving feedback on the completeness of Exercise 1. In order to do so, we will be giving you a rubric to give feedback on. For the feedback, please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to review the code and project files that were given out by the instructor.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.

## Due Date and Submission Information ##

A successful submission should consist of a copy of this markdown document template that is modified with your peer-review. The file name should be the same as it is in the template: PeerReview-Exercise1.md. You also need to include your name and email address in the Peer-reviewer Information section below. This review document should be placed into the base folder of the repo you are reviewing in the master branch. This branch should be on the origin of the repository you are reviewing.

If you are in the rare situation where there are two peer-reviewers on a single repository, append your UC Davis user name before the extension of your review file. An example: PeerReview-Exercise1-username.md. Both reviewers should submit their reviews in the master branch.  

## Solution Assessment ##

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect. Place an x character inside of the square braces next to the appropriate label.

The following are the criteria by which you should assess your peer's solution of the exercise's stages.

#### Perfect #### 
    Can't find any flaws in relation to the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not really converging to a solution. Pervasive Major flaws. Objective largely unmet.


### Stage 1 - Position Locking###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
Camera is always centered directly over the player.

### Stage 2 - framing with horizontal auto-scroll###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
Camera moves at a consistant speed and player is restrained to only moved within a defined bound. If player doesnt move it gets moved my the moving camera on its edge. Also appropiate export variables are there to adjust the speed of the autoscrolling camera.

### Stage 3 - position lock and lerp smoothing ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justifaction ##### 
Has all of the required exported fields those being follow_speed, catch_up_speed, and leash_distance. Camera works as intended.

### Stage 4 - lerp smoothing target focus###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justifaction ##### 
Has all of ther required exports all which work as intended. The camera leads the player diection and jumps back to the player when the player stops moving.

### Stage 5 - 4-way speedup push zone ###

- [] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justifaction ##### 
Has all of the required exports fields which all work as intended. The push box also successfully works. Only small issue is that when you switch to the camera the camera is not initially focused on the player until the player gets within the range of the box.

## Code Style ##


### Code Style Review ###

Following this style guide: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html

#### Style Guide Infractions ####
Your code is generally well-organized and mostly follows Godot's GDScript style guide, ensuring readability and maintainability. For example I noitced they made good use of whitespace such as using two spaces to seperate funciton definitions.

#### Style Guide Exemplars ####

Student used snake_case for all variables and fields.
Student kept each line to a single statement and under 100 characters
Student followed all style guide rules, from what I can tell.



