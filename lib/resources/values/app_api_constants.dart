class ApiConstants {
  ApiConstants._();
  static const String headerAuthorization = 'authorization';

  // 1. Measurement
  static const String getMeasurementEstimate = 'estimate';
  static const String getMeasurementDetailList = '/GetMeasurmentDtlsList';
  static const String getEcgPpgDetailList = '/GetEcgAndPpgData';
  static const String deleteEstimateDetailByID = '/DeleteEstimateDtlsByID';
  static const String setMeasurementUnit = '/SetMeasuremetnUnit';

  // 2. Chat
  static const String accessChattedWith = '/AccessChattedWith';
  static const String accessChatHistoryTwoUsers = '/AccessChatHistoryTwoUsers';
  static const String accessCreateChatGroup = 'AccessCreateChatGroup';
  static const String accessChatHistoryGroup = '/AccessChatHistoryGroup';
  static const String accessGroupParticipants = '/AccessGroupParticipants';
  static const String accessSendGroup = '/AccessSendGroup';
  static const String accessGetMyGroupList = '/AccessGetMyGroupList';
  static const String accessDeleteChatGroup = '/AccessDeleteChatGroup';
  static const String accessAddParticipant = '/AccessAddParticipant';
  static const String accessRemoveParticipant = '/AccessRemoveParticipant';

  // 3. Library
  static const String libraryMyDriveListByUserID =
      '/LibraryMyDriveListByUserID';
  static const String sharedWithByUserID = '/SharedWithByUserID';
  static const String libraryBinListByUserID = '/LibraryBinListByUserID';
  static const String createFolder = '/CreateFolder';
  static const String deleteLibraryByID = '/DeleteLibraryByID';
  static const String deleteLibraryPermanentlyByID =
      '/DeleteLibraryPermanentlyByID';
  static const String uploadFileIntoDrive = '/UploadFileIntoDrive';
  static const String updateLinkedAccess = '/UpdateLinkedAccess';
  static const String moveDrive = '/MoveDrive';
  static const String deleteShared = '/DeleteShared';
  static const String saveAndUpdateSharedWith = '/SaveandUpdateSharedWith';

  // 4. Contact
  static const String getContactList = '/GetContactList';
  static const String deleteContactByUserId = '/DeleteContactByUserId';
  static const String getSendingInvitationList = '/GetSendingInvitationList';
  static const String getPendingInvitationList = '/GetPendingInvitationList';
  static const String acceptOrRejectInvitation = '/AcceptOrRejectInvitation';
  static const String searchLeads = '/SearchLeads';
  static const String sendInvitation = '/SendInvitation';

  // 5. Mail
  static const String getMessageDetailByMessageId =
      '/GetMessagedetlsByMessageid';
  static const String sendResponseByMessageIDAndTypeID =
      '/SendResponseByMessageIDAndTypeID';
  static const String emptyMessagesFromTrash = '/EmptyMessagesFromTrash';
  static const String markAsReadByMessageTypeID = '/MarkAsReadByMessageTypeID';
  static const String markAsReadByMessageID = '/MarkAsReadByMessageID';
  static const String multipleMessageDeleteFromTrash =
      '/MultipleMessageDeleteFromTrash';
  static const String multipleDeleteMessages = '/MultipleDeleteMessages';
  static const String deleteMessageById = '/DeleteMessagebyId';
  static const String restoreMessageByID = '/RestoreMessageByID';
  static const String sendMessage = '/Sendmessage';
  static const String getMessageListByMessageTypeId =
      '/GetMessagelistByMessageTypeid';

  // 6. User
  static const String forgetUserID = '/ForgetUserID';
  static const String resetPasswordUsingUserName =
      '/ResetPasswordUsingUserName';
  static const String forgetPassword = '/ForgetPassword';
  static const String forgetPasswordChooseMedium =
      '/ForgetPasswordChooseMedium';
  static const String forgetPasswordUsingUserName =
      '/ForgetPasswordUsingUserName';
  static const String verifyOTP = '/VerifyOTP';
  static const String changePasswordByUserID = '/ChangePasswordByUserID';
  static const String getUSerDetailsByUserID = '/GetUSerDetailsByUserID';
  static const String editUser = '/EditUser';
  static const String checkDuplicateUserIDAndEmail= '/CheckDuplicateUserIDAndEmail';

  // 7. Tag
  static const String storeTagRecordDetails = '/StoreTagRecordDtls';
  static const String editTagRecordDetails = '/EditTagRecordDtls';
  static const String deleteTagLabelByID = '/DeleteTagLabelByID';
  static const String addTagLabel = '/AddTagLabel';
  static const String editTagLabel = '/EditTagLabel';
  static const String getTagRecordList = '/GetTagRecordList';
  static const String getTagLabelList = '/GetTagLabelList';
  static const String deleteTagRecordByID = '/DeleteTagRecordByID';

  // 8. Calendar
  static const String deleteEventByEventID = '/DeleteEventByEventID';
  static const String getEventDetailsByUserIDAndEventID =
      '/GetEventDetailsByUserIDAndEventID';
  static const String calendarEventData = '/CalendarEventData';
  static const String getEventListByUserID = '/GetEventListByUserID';

  // 9. User Vital Status
  static const String getUserVitalStatus = '/GetUserVitalStatus';
  static const String saveUserVitalStatus = '/SaveUserVitalStatus'; // (*)

  // 10. Weight
  static const String getWeightMeasurementList = '/GetWeightMeasurementList';
  static const String storeWeightMeasurement = '/StoreWeightMeasurement';

  // 11. Sleep
  static const String getSleepRecordDetailList = '/GetSleepRecordDtlsList';
  static const String storeSleepRecordDetails = '/StoreSleepRecordDtls'; // (*)

  // 12. Motion
  static const String getMotionRecordList = '/GetMotionRecordList';
  static const String storeMotionRecordDetails = '/StoreMotionRecordDtls';

  // 13. Device Info
  static const String storeDeviceInfo = '/StoreDeviceInfo';

  // 14. Auth
  static const String userLogin = '/userlogin';
  static const String userRegistration = '/UserRegistation';

  // 15. Firmware
  static const String getFirmwareVersionList = '/GetFirmwareVersionList';

  // 16. Save and Get Preference
  static const String getPreferenceSettings = '/GetPreferenceSettings';
  static const String storePreferenceSettings = '/StorePreferenceSettings';

  // 17. Dashboard Data
  static const String getDashboardData = '/GetDashboardData';
  static const String getAllMeasurementCountData = '/GetMeasurementCountData';

  // 18. Activity Tracker
  static const String storeRecognitionActivity = '/StoreRecognitionActivity';
  static const String getRecognitionActivityList =
      '/GetRecognitionActivityList';

  // 19. Heart Rate
  static const String getHrData = '/GetHRDataList';
  static const String storeHrData = '/SaveHRData'; // (*)

  // 20. Health Kit & Google Fit
  static const String getThirdPartyDataType = '/GetThirdpartydataTypeList';
  static const String saveThirdPartyDataType = '/SaveThirdpartydataType';

  // 21. BloodPressure
  static const String getBloodPressureData = '/GetBPDataList';
  static const String storeBloodPressureData = '/SaveBPData';

  //22. Survey EndPoints
  static const String createNewSurvey = '/AddNewSurvey';
  static const String surveyListByUserID = '/GetSurveyListByUserID';
  static const String surveySharedWithMe = '/GetSurveySharedwithMe';
  static const String surveyDetailBySurveyID = '/GetSurveySharedDeatlsByID';
  static const String shareSurveyWithContacts = '/ShareSurveyToContacts';

  //23. HRZone
  static const String getHRZoneList = '/GetHRZoneList';
  static const String postSaveHRZone = '/SaveHRZone';
  static const String updateEditHRZone = '/EditHRZone';

  //23. Device Settings
  static const String getDeviceSettings = '/GetDeviceSettings';
  static const String updateDeviceSettings = '/UpdateDeviceSettings';
  static const String getAllLatestMeasurementTimestamp = '/GetAllLatestMeasurementTimestamp';

  /// Query Variable
  static const String userName = 'UserName';
  static const String password = 'Password';
  static const String deviceToken = 'DeviceToken';
  static const String userID = 'UserID';
  static const String eventId = 'EventID';
  static const String fromUserId = 'fromuserId';
  static const String toUserId = 'touserId';
  static const String groupName = 'groupName';
  static const String memberIds = 'memberIds';
  static const String membersIDs = 'MembersIDs';
  static const String contactFromUserID = 'ContactFromUserID';
  static const String contactToUserId = 'ContactToUserId';
  static const String contactID = 'ContactID';
  static const String isAccepted = 'IsAccepted';
  static const String loggedInUserID = 'LoggedinUserID';
  static const String searchText = 'SearchText';
  static const String inviteeUserID = 'InviteeUserID';
  static const String pageNumber = 'PageNumber';
  static const String pageSize = 'PageSize';
  static const String libraryID = 'LibraryID';
  static const String messageID = 'MessageID';
  static const String loggedInEmailID = 'LogedInEmailID';
  static const String messageId = 'MessageId';
  static const String messageTypeId = 'MessageTypeid';
  static const String email = 'Email';
  static const String userId = 'UserId';
  static const String oldPassword = 'OldPassword';
  static const String newPassword = 'NewPassword';
  static const String tagLabelID = 'TagLabelID';
  static const String tagRecordId = 'TagRecordId';
  static const String iD = 'ID';
  static const String emailOrUserID = 'EmailOrUserID';
  static const String type = 'Type';
}
