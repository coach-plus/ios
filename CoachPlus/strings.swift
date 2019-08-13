// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum L10n {
  /// Actions
  public static let actions = L10n.tr("MainLocalization", "Actions")
  /// Are you sure that you want to leave %s?
  public static func areYouSureThatYouWantToLeaveTeamName(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("MainLocalization", "Are_you_sure_that_you_want_to_leave_team_name", p1)
  }
  /// Awesome!
  public static let awesome = L10n.tr("MainLocalization", "Awesome")
  /// Back
  public static let back = L10n.tr("MainLocalization", "Back")
  /// Can't find the email? Trigger a new email in the user settings
  public static let canTFindTheMailTriggerANewEmailInTheUserSettings = L10n.tr("MainLocalization", "Can_t_find_the_mail_trigger_a_new_email_in_the_user_settings")
  /// Cancel
  public static let cancel = L10n.tr("MainLocalization", "Cancel")
  /// Change Password
  public static let changePassword = L10n.tr("MainLocalization", "Change_Password")
  /// Confirmation email sent
  public static let confirmationEmailSent = L10n.tr("MainLocalization", "Confirmation_email_sent")
  /// Continue
  public static let `continue` = L10n.tr("MainLocalization", "Continue")
  /// Create Event
  public static let createEvent = L10n.tr("MainLocalization", "Create_Event")
  /// Create news
  public static let createNews = L10n.tr("MainLocalization", "Create_News")
  /// Create Team
  public static let createTeam = L10n.tr("MainLocalization", "Create_Team")
  /// Delete
  public static let delete = L10n.tr("MainLocalization", "Delete")
  /// Delete Event
  public static let deleteEvent = L10n.tr("MainLocalization", "Delete_Event")
  /// Delete Team
  public static let deleteTeam = L10n.tr("MainLocalization", "Delete_Team")
  /// Description
  public static let description = L10n.tr("MainLocalization", "Description")
  /// Did attend
  public static let didAttend = L10n.tr("MainLocalization", "Did_attend")
  /// Did not attend
  public static let didNotAttend = L10n.tr("MainLocalization", "Did_not_attend")
  /// Do really want to join %s?
  public static func doReallyWantToJoinX(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("MainLocalization", "Do_really_want_to_join_x", p1)
  }
  /// Do you really want to delete this event?
  public static let doYouReallyWantToDeleteThisEvent = L10n.tr("MainLocalization", "Do_you_really_want_to_delete_this_event")
  /// Do you really want to delete %s?
  public static func doYouReallyWantToDeleteX(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("MainLocalization", "Do_you_really_want_to_delete_x", p1)
  }
  /// Do you want to delete the messsage?
  public static let doYouWantToDeleteTheMesssage = L10n.tr("MainLocalization", "do_you_want_to_delete_the_messsage")
  /// Done
  public static let done = L10n.tr("MainLocalization", "Done")
  /// Edit
  public static let edit = L10n.tr("MainLocalization", "Edit")
  /// Edit Event
  public static let editEvent = L10n.tr("MainLocalization", "Edit_Event")
  /// Edit Team
  public static let editTeam = L10n.tr("MainLocalization", "Edit_Team")
  /// Email
  public static let email = L10n.tr("MainLocalization", "Email")
  /// End
  public static let end = L10n.tr("MainLocalization", "End")
  /// End date must be after start date
  public static let endDateMustBeAfterStartDate = L10n.tr("MainLocalization", "End_date_must_be_after_start_date")
  /// Error
  public static let error = L10n.tr("MainLocalization", "Error")
  /// Event Name
  public static let eventName = L10n.tr("MainLocalization", "Event_Name")
  /// Events
  public static let events = L10n.tr("MainLocalization", "Events")
  /// Firstname
  public static let firstname = L10n.tr("MainLocalization", "Firstname")
  /// Forgot Password
  public static let forgotPassword = L10n.tr("MainLocalization", "Forgot_Password")
  /// Planned Events
  public static let futureEvents = L10n.tr("MainLocalization", "Future_Events")
  /// Whoops. There was an error on our side
  public static let internalServerError = L10n.tr("MainLocalization", "Internal_server_error")
  /// Invite to team
  public static let inviteToTeam = L10n.tr("MainLocalization", "Invite_to_team")
  /// Join Team
  public static let joinTeam = L10n.tr("MainLocalization", "Join_Team")
  /// Join this private team
  public static let joinThisPrivateTeam = L10n.tr("MainLocalization", "Join_this_private_team")
  /// Join this public team
  public static let joinThisPublicTeam = L10n.tr("MainLocalization", "Join_this_public_team")
  /// You joined this team
  public static let joinedTeamSuccessfully = L10n.tr("MainLocalization", "Joined_team_successfully")
  /// Joining team..
  public static let joiningTeam = L10n.tr("MainLocalization", "Joining_team")
  /// Lastname
  public static let lastname = L10n.tr("MainLocalization", "Lastname")
  /// Leave Team
  public static let leaveTeam = L10n.tr("MainLocalization", "Leave_Team")
  /// You left this team
  public static let leftTeamSuccessfully = L10n.tr("MainLocalization", "Left_team_successfully")
  /// Loading
  public static let loading = L10n.tr("MainLocalization", "Loading")
  /// Location
  public static let location = L10n.tr("MainLocalization", "Location")
  /// Login
  public static let login = L10n.tr("MainLocalization", "Login")
  /// Logout
  public static let logout = L10n.tr("MainLocalization", "Logout")
  /// Make Coach
  public static let makeCoach = L10n.tr("MainLocalization", "Make_Coach")
  /// Make user
  public static let makeUser = L10n.tr("MainLocalization", "Make_user")
  /// Member
  public static let member = L10n.tr("MainLocalization", "Member")
  /// Members
  public static let members = L10n.tr("MainLocalization", "Members")
  /// Message
  public static let message = L10n.tr("MainLocalization", "Message")
  /// Name is required
  public static let nameIsRequired = L10n.tr("MainLocalization", "Name_is_required")
  /// New News
  public static let newNews = L10n.tr("MainLocalization", "New_News")
  /// New Password
  public static let newPassword = L10n.tr("MainLocalization", "New_Password")
  /// New passwords do not match
  public static let newPasswordsDoNotMatch = L10n.tr("MainLocalization", "New_passwords_do_not_match")
  /// New Team
  public static let newTeam = L10n.tr("MainLocalization", "New_Team")
  /// News
  public static let news = L10n.tr("MainLocalization", "News")
  /// No
  public static let no = L10n.tr("MainLocalization", "No")
  /// No Description
  public static let noDescription = L10n.tr("MainLocalization", "No_Description")
  /// No Events found
  public static let noEventsFound = L10n.tr("MainLocalization", "No_Events_found")
  /// No images found
  public static let noImagesFound = L10n.tr("MainLocalization", "No_images_found")
  /// Could not connect to the server
  public static let noInternetConnection = L10n.tr("MainLocalization", "No_internet_connection")
  /// No Location
  public static let noLocation = L10n.tr("MainLocalization", "No_Location")
  /// No News
  public static let noNews = L10n.tr("MainLocalization", "No_News")
  /// Old Password
  public static let oldPassword = L10n.tr("MainLocalization", "Old_Password")
  /// Old password, new password and repeated password are required
  public static let oldPasswordNewPasswordAndPasswordRepeatAreRequired = L10n.tr("MainLocalization", "Old_password_new_password_and_password_repeat_are_required")
  /// 1 Member
  public static let oneMember = L10n.tr("MainLocalization", "one_Member")
  /// I will not attend
  public static let participateNo = L10n.tr("MainLocalization", "Participate_no")
  /// I will attend
  public static let participateYes = L10n.tr("MainLocalization", "Participate_yes")
  /// Participation
  public static let participation = L10n.tr("MainLocalization", "Participation")
  /// Password
  public static let password = L10n.tr("MainLocalization", "Password")
  /// Passwords must match
  public static let passwordsMustMatch = L10n.tr("MainLocalization", "Passwords_must_match")
  /// Past Events
  public static let pastEvents = L10n.tr("MainLocalization", "Past_Events")
  /// Personal Settings
  public static let personalSettings = L10n.tr("MainLocalization", "Personal_Settings")
  /// %s is in the following Teams
  public static func playerIsInTheFollowingTeams(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("MainLocalization", "player_is_in_the_following_Teams", p1)
  }
  /// Please check your emails and verify your email address
  public static let pleaseCheckYourMailsAndVerifyYourEmailAddress = L10n.tr("MainLocalization", "Please_check_your_mails_and_verify_your_email_address")
  /// Please enter a location
  public static let pleaseEnterALocation = L10n.tr("MainLocalization", "Please_enter_a_location")
  /// Please enter a name
  public static let pleaseEnterAName = L10n.tr("MainLocalization", "Please_enter_a_name")
  /// Please enter a start date
  public static let pleaseEnterAStartDate = L10n.tr("MainLocalization", "Please_enter_a_start_date")
  /// Please enter a team name
  public static let pleaseEnterATeamName = L10n.tr("MainLocalization", "Please_enter_a_team_name")
  /// Please enter an end date
  public static let pleaseEnterAnEndDate = L10n.tr("MainLocalization", "Please_enter_an_end_date")
  /// Please enter your email address
  public static let pleaseEnterYourEmailAddress = L10n.tr("MainLocalization", "Please_enter_your_email_address")
  /// Please fill in this field
  public static let pleaseFillInThisField = L10n.tr("MainLocalization", "Please_fill_in_this_field")
  /// Please fill in your email address and we will send you a new Password
  public static let pleaseFillInYourEmailAddressAndWeWillSendYouANewPassword = L10n.tr("MainLocalization", "Please_fill_in_your_email_address_and_we_will_send_you_a_new_password")
  /// Please select an action
  public static let pleaseSelectAnAction = L10n.tr("MainLocalization", "Please_select_an_action")
  /// Please set participation
  public static let pleaseSetParticipation = L10n.tr("MainLocalization", "Please_set_participation")
  /// Private Team
  public static let privateTeam = L10n.tr("MainLocalization", "Private_Team")
  /// Public Team
  public static let publicTeam = L10n.tr("MainLocalization", "Public_Team")
  /// Register
  public static let register = L10n.tr("MainLocalization", "Register")
  /// Successfully sent a reminder
  public static let reminderSent = L10n.tr("MainLocalization", "reminder_sent")
  /// Remove from team
  public static let removeFromTeam = L10n.tr("MainLocalization", "Remove_from_team")
  /// Repeat new Password
  public static let repeatNewPassword = L10n.tr("MainLocalization", "Repeat_new_Password")
  /// Repeat Password
  public static let repeatPassword = L10n.tr("MainLocalization", "Repeat_Password")
  /// Request new Password
  public static let requestNewPassword = L10n.tr("MainLocalization", "Request_new_Password")
  /// Requesting new Password
  public static let requestingNewPassword = L10n.tr("MainLocalization", "Requesting_new_Password")
  /// Resend E-Mail
  public static let resendEMail = L10n.tr("MainLocalization", "Resend_E_Mail")
  /// Save
  public static let save = L10n.tr("MainLocalization", "Save")
  /// Saved
  public static let saved = L10n.tr("MainLocalization", "Saved")
  /// Select beginning date
  public static let selectBeginningDate = L10n.tr("MainLocalization", "Select_beginning_date")
  /// Select beginning time
  public static let selectBeginningTime = L10n.tr("MainLocalization", "Select_beginning_time")
  /// Select end date
  public static let selectEndDate = L10n.tr("MainLocalization", "Select_end_date")
  /// Select end time
  public static let selectEndTime = L10n.tr("MainLocalization", "Select_end_time")
  /// Select Team
  public static let selectTeam = L10n.tr("MainLocalization", "Select_Team")
  /// Send reminder
  public static let sendReminder = L10n.tr("MainLocalization", "Send_reminder")
  /// Set Attendance
  public static let setAttendance = L10n.tr("MainLocalization", "Set_Attendance")
  /// Show all Events
  public static let showAllEvents = L10n.tr("MainLocalization", "Show_all_Events")
  /// Start
  public static let start = L10n.tr("MainLocalization", "Start")
  /// Success
  public static let success = L10n.tr("MainLocalization", "Success")
  /// Successfully joined %s
  public static func successfullyJoinedX(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("MainLocalization", "Successfully_joined_x", p1)
  }
  /// Successfully left team %s
  public static func successfullyLeftTeamX(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("MainLocalization", "Successfully_left_team_x", p1)
  }
  /// Successfully requested a new password
  public static let successfullyRequestedANewPassword = L10n.tr("MainLocalization", "Successfully_requested_a_new_password")
  /// Team deleted
  public static let teamDeleted = L10n.tr("MainLocalization", "Team_deleted")
  /// Team Name
  public static let teamName = L10n.tr("MainLocalization", "Team_Name")
  /// Teams
  public static let teams = L10n.tr("MainLocalization", "Teams")
  /// The announcement was created
  public static let theAnnouncementWasCreatedSuccessfully = L10n.tr("MainLocalization", "The_announcement_was_created_successfully")
  /// The announcement was deleted
  public static let theAnnouncementWasDeletedSuccessfully = L10n.tr("MainLocalization", "The_announcement_was_deleted_successfully")
  /// The credentials are not correct
  public static let theCredentialsAreNotCorrect = L10n.tr("MainLocalization", "The_credentials_are_not_correct")
  /// The email address is required
  public static let theEmailAddressIsRequired = L10n.tr("MainLocalization", "The_email_address_is_required")
  /// Your email address is already in use
  public static let theEmailAddressWasAlreadyRegistered = L10n.tr("MainLocalization", "The_email_address_was_already_registered")
  /// Your email address is already confirmed
  public static let theEmailAddressWasAlreadyVerified = L10n.tr("MainLocalization", "The_email_address_was_already_verified")
  /// The event could not be found
  public static let theEventCouldNotBeFound = L10n.tr("MainLocalization", "The_event_could_not_be_found")
  /// The event has already started
  public static let theEventHasAlreadyStarted = L10n.tr("MainLocalization", "The_event_has_already_started")
  /// The event has not started yet
  public static let theEventHasNotStartedYet = L10n.tr("MainLocalization", "The_event_has_not_started_yet")
  /// The event was created
  public static let theEventWasCreatedSuccessfully = L10n.tr("MainLocalization", "The_event_was_created_successfully")
  /// The event was deleted
  public static let theEventWasDeletedSuccessfully = L10n.tr("MainLocalization", "The_event_was_deleted_successfully")
  /// The event was updated
  public static let theEventWasUpdatedSuccessfully = L10n.tr("MainLocalization", "The_event_was_updated_successfully")
  /// The image is missing
  public static let theImageIsMissing = L10n.tr("MainLocalization", "The_image_is_missing")
  /// The last coach cannot leave the team
  public static let theLastCoachCantLeaveTheTeam = L10n.tr("MainLocalization", "The_last_coach_cant_leave_the_team")
  /// The membership could not be found
  public static let theMembershipCouldNotBeFound = L10n.tr("MainLocalization", "The_membership_could_not_be_found")
  /// The reminder was sent
  public static let theReminderWasSentSuccessfully = L10n.tr("MainLocalization", "The_reminder_was_sent_successfully")
  /// The role is invalid
  public static let theRoleIsInvalid = L10n.tr("MainLocalization", "The_role_is_invalid")
  /// The role was updated successfully
  public static let theRoleWasUpdatedSuccessfully = L10n.tr("MainLocalization", "The_role_was_updated_successfully")
  /// The team already exists
  public static let theTeamAlreadyExists = L10n.tr("MainLocalization", "The_team_already_exists")
  /// The team could not be found
  public static let theTeamCouldNotBeFound = L10n.tr("MainLocalization", "The_team_could_not_be_found")
  /// The team was deleted
  public static let theTeamWasDeletedSuccessfully = L10n.tr("MainLocalization", "The_team_was_deleted_successfully")
  /// The team was updated
  public static let theTeamWasUpdatedSuccessfully = L10n.tr("MainLocalization", "The_team_was_updated_successfully")
  /// The team's name must be at least 3 characters long
  public static let theTeamsNameMustBeAtLeastThreeCharactersLong = L10n.tr("MainLocalization", "The_teams_name_must_be_at_least_three_characters_long")
  /// The token is invalid
  public static let theTokenIsNotValid = L10n.tr("MainLocalization", "The_token_is_not_valid")
  /// The user could not be found
  public static let theUserCouldNotBeFound = L10n.tr("MainLocalization", "The_user_could_not_be_found")
  /// You are already part of this team
  public static let theUserIsAlreadyMemberOfThisTeam = L10n.tr("MainLocalization", "The_user_is_already_member_of_this_team")
  /// You are not a member of this team
  public static let theUserIsNotACoachOfThisTeam = L10n.tr("MainLocalization", "The_user_is_not_a_coach_of_this_team")
  /// The user was removed from the team
  public static let theUserWasRemovedUserSuccessfully = L10n.tr("MainLocalization", "The_user_was_removed_user_successfully")
  /// The confirmation link has expired
  public static let theVerificationTokenCouldNotBeFound = L10n.tr("MainLocalization", "The_verification_token_could_not_be_found")
  /// There are no planned events
  public static let thereAreNoPlannedEvents = L10n.tr("MainLocalization", "There_are_no_planned_events")
  /// There was an error loading this team
  public static let thereWasAnErrorLoadingThisTeam = L10n.tr("MainLocalization", "There_was_an_error_loading_this_team")
  /// This team is not available
  public static let thisTeamIsNotAvailable = L10n.tr("MainLocalization", "This_team_is_not_available")
  /// to
  public static let to = L10n.tr("MainLocalization", "to")
  /// Trying to join team...
  public static let tryingToJoinTeam = L10n.tr("MainLocalization", "Trying_to_join_team")
  /// You do not have the required rights to perform this action
  public static let unauthorized = L10n.tr("MainLocalization", "Unauthorized")
  /// Update Event
  public static let updateEvent = L10n.tr("MainLocalization", "Update_Event")
  /// Update Profile
  public static let updateProfile = L10n.tr("MainLocalization", "Update_Profile")
  /// Update Team
  public static let updateTeam = L10n.tr("MainLocalization", "Update_Team")
  /// User Profile was updated successfully
  public static let userProfileWasUpdatedSuccessfully = L10n.tr("MainLocalization", "User_Profile_was_updated_successfully")
  /// User Settings
  public static let userSettings = L10n.tr("MainLocalization", "User_Settings")
  /// Verification failed
  public static let verificationFailed = L10n.tr("MainLocalization", "Verification_failed")
  /// Wrong password
  public static let wrongPassword = L10n.tr("MainLocalization", "Wrong_password")
  /// %d Members
  public static func xMembers(_ p1: Int) -> String {
    return L10n.tr("MainLocalization", "x_Members", p1)
  }
  /// Yes
  public static let yes = L10n.tr("MainLocalization", "Yes")
  /// You
  public static let you = L10n.tr("MainLocalization", "You")
  /// You already have teams. Go ahead and select one.
  public static let youAlreadyHaveTeamsGoAheadAndSelectOne = L10n.tr("MainLocalization", "You_already_have_teams_Go_ahead_and_select_one")
  /// You are in the following Teams
  public static let youAreInTheFollowingTeams = L10n.tr("MainLocalization", "You_are_in_the_following_Teams")
  /// You are not verified
  public static let youAreNotVerified = L10n.tr("MainLocalization", "You_are_not_verified")
  /// You are now verified
  public static let youAreNowVerified = L10n.tr("MainLocalization", "You_are_now_verified")
  /// You can now select who participated
  public static let youCanNowSelectWhoParticipated = L10n.tr("MainLocalization", "You_can_now_select_who_participated")
  /// You do not have a team yet
  public static let youDoNotHaveATeamYet = L10n.tr("MainLocalization", "You_do_not_have_a_team_yet")
  /// You do not have a team yet. Go ahead and create one using the '+' on the top right.
  public static let youDoNotHaveATeamYetGoAheadAndCreateOneUsingTheOnTheTopRight = L10n.tr("MainLocalization", "You_do_not_have_a_team_yet_Go_ahead_and_create_one_using_the_on_the_top_right")
  /// Your participation was updated
  public static let yourParticipationWasUpdatedSuccessfully = L10n.tr("MainLocalization", "Your_participation_was_updated_successfully")
  /// Your registration was successful
  public static let yourRegistrationWasSuccessful = L10n.tr("MainLocalization", "Your_registration_was_successful")
  /// Your team is private and you can invite people
  public static let yourTeamIsPrivateAndYouCanInvitePeople = L10n.tr("MainLocalization", "Your_team_is_private_and_you_can_invite_people")
  /// Your team is public and everyone can join it
  public static let yourTeamIsPublicAndEveryoneCanJoinIt = L10n.tr("MainLocalization", "Your_team_is_public_and_everyone_can_join_it")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
