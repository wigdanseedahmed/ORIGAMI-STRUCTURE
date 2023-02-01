class AppUrl {
  static const String liveBaseURL = "https://remote-ur/api/v1";
  static const String localBaseURL = "http://172.20.172.221:1000";

  // "http://192.168.8.126:1000"; for Canar
  // "http://172.20.10.2:1000"; for iphone 13
  // "http://172.20.10.5:1000"; for iphone 6S
  // "http://172.20.172.221:1000"; for work
  // "http://172.20.172.221:1000"; for work + MacIntel
  // "http://172.20.10.4:1000"; for iphone 6S + MacIntel


  static const String baseURL = localBaseURL; //liveBaseURL;
  static const String imageBaseURL = "$baseURL/image";
  static const String hardSkillBaseURL = "$baseURL/hardSkill";
  static const String userBaseURL = "$baseURL/user";
  static const String projectBaseURL = "$baseURL/project";
  static const String softSkillBaseURL = "$baseURL/softSkill";
  static const String taskBaseURL = "$baseURL/task";

  /// HARD SKILL ///

  /// Get a list of hardSkills from the DB

  static const String getHardSkills = "$hardSkillBaseURL/hardSkills";

  // router.get('/hardSkills', getHardSkills);

  static const String getHardSkillByHardSkill =
      "$hardSkillBaseURL/hardSkill/";

  // router.get('/hardSkill/:hardSkill', getHardSkillByHardSkill);

  /// Add new hardSkill to the DB

  static const String createHardSkill = "$hardSkillBaseURL/createHardSkill";

// router.post('/createHardSkill', createHardSkill);

  /// Update a hardSkill in the DB

  static const String updateHardSkillByID = "$hardSkillBaseURL/update/id/";

  // router.put('/update/id/:id', updateHardSkillByID);

  static const String updateHardSkillByHardSkill =
      "$hardSkillBaseURL/update/hardSkill/";

// router.put('/update/hardSkill/:hardSkill', updateHardSkillByHardSkill);

  /// Delete a hardSkill from the DB
  static const String deleteHardSkillByID = "$hardSkillBaseURL/delete/id/";

// router.delete('/delete/id/:id', deleteHardSkillByID);

  static const String deleteHardSkillByHardSkill =
      "$hardSkillBaseURL/delete/hardSkill/";

// router.delete('/delete/hardSkill/:hardSkill', deleteHardSkillByHardSkill);

  /// Projects ///

  ///  Adding and Uploading Image
  static const String addAndUpdateProjectImage = "$projectBaseURL/add/image";

  //router.route("/add/image").patch(middleware.checkToken, uploadImage.single("img"), addAndUpdateProjectImage);

  /// Get a list of projects from the DB
  static const String getProjects = "$projectBaseURL/projects";

  //router.get('/projects', getProjects);

  static const String getProjectByProjectName =
      "$projectBaseURL/getProjectByProjectName/";

  //router.get('/getProjectByProjectName/:projectName', getProjectByProjectName);

  /// Check if project exists
  static const String checkProjectExistsByProjectName =
      "$projectBaseURL/projects/checkIfProjectExistsUsingProjectName/";

  //router.get('/proejcts/checkIfProjectExistsUsingProjectName/:projectName', checkProjectExistsByProjectName)

  /// Add new project to the DB
  static const String createProject = "$projectBaseURL/createProject";

  //router.post('/projects', createProject);

  /// Update a project in the DB
  static const String updateProjectByID = "$projectBaseURL/projects/id/";

  //router.put('/projects/id/:id', updateProjectByID);

  static const String updateProjectByProjectName =
      "$projectBaseURL/projects/projectName/";

  //router.put('/projects/projectName/:projectName', updateProjectByProjectName);

  /// Delete a project from the DB
  static const String deleteProjectByID = "$projectBaseURL/projects/id/";

  //router.delete('/projects/id/:id', deleteProjectByID);

  static const String deleteProjectByProjectName =
      "$projectBaseURL/projects/projectName/";

  //router.delete('/projects/projectName/:projectName', deleteProjectByProjectName);

  /// SOFT SKILL ///

  /// Get a list of softSkills from the DB

  static const String getSoftSkills = "$softSkillBaseURL/softSkills";

  // router.get('/softSkills', getSoftSkills);

  static const String getSoftSkillBySoftSkill =
      "$softSkillBaseURL/softSkill/";

  // router.get('/softSkill/:softSkill', getSoftSkillBySoftSkill);

  /// Add new softSkill to the DB

  static const String createSoftSkill = "$softSkillBaseURL/createSoftSkill";

// router.post('/createSoftSkill', createSoftSkill);

  /// Update a softSkill in the DB

  static const String updateSoftSkillByID = "$softSkillBaseURL/update/id/";

  // router.put('/update/id/:id', updateSoftSkillByID);

  static const String updateSoftSkillBySoftSkill =
      "$softSkillBaseURL/update/softSkill/";

// router.put('/update/softSkill/:softSkill', updateSoftSkillBySoftSkill);

  /// Delete a softSkill from the DB
  static const String deleteSoftSkillByID = "$softSkillBaseURL/delete/id/";

// router.delete('/delete/id/:id', deleteSoftSkillByID);

  static const String deleteSoftSkillBySoftSkill =
      "$softSkillBaseURL/delete/softSkill/";

// router.delete('/delete/softSkill/:softSkill', deleteSoftSkillBySoftSkill);

  /// Tasks ///


  /// Adding and update user files
  static const String addAndUpdateTaskFiles =  "$taskBaseURL/addFiles/";
  //router.post("/task/addFiles/:taskName", upload.single("myFile"), addAndUpdateTaskFiles);

  /// Get a list of tasks from the DB
  static const String tasks = "$taskBaseURL/tasks";

  //router.get('/tasks', getTasks);

  static const String getTaskByTaskName = '$taskBaseURL/task/';

  //router.get('/task/:taskName', getTaskByTaskName);

  /// Check if task exists
  static const String checkTaskExistsByProjectName =
      "$taskBaseURL/tasks/checkIfTaskExistsUsingTaskName/";

  //router.get('/tasks/checkIfTaskExistsUsingTaskName/:taskName', checkTaskExistsByProjectName)

  /// Add new task to the DB
  static const String createTask = '$taskBaseURL/createTask';

  //router.post('/tasks', createTask);

  /// Update a task in the DB
  static const String updateTaskByID = '$taskBaseURL/update/id/';

  //router.put('/update/id/:id', updateTaskByID);

  static const String updateTaskByTaskName = '$taskBaseURL/update/taskName/';

  //router.put('/update/taskName/:taskName', updateTaskByTaskName);

  /// Delete a task from the DB
  static const String deleteTaskByID = '$taskBaseURL/delete/id/';

  //router.delete('/delete/id/:id', deleteTaskByID);

  static const String deleteTaskByTaskName = '$taskBaseURL/delete/taskName/';

  //router.delete('/delete/taskName/:taskName', deleteTaskByTaskName);

  /// USER ///

  /// Adding and Uploading Image
  static const String addAndUpdateProfileImage = "$userBaseURL/add/image/";

  //router.route("/add/image/:email").patch(middleware.checkToken, uploadImage.single("img"), addAndUpdateProfileImage);

  static const String users = "$userBaseURL/users";

  static const String checkEmail = "$userBaseURL/users/checkEmail/";

  static const String checkUsername = "$userBaseURL/users/checkUsername/";

  static const String login = "$userBaseURL/login";

  static const String register = "$userBaseURL/register";

  static const String forgotPasswordUpdateWithEmail =
      "$userBaseURL/users/forgetPassword/email/";

  static const String forgotPasswordUpdateWithUsername =
      "$userBaseURL/users/forgetPassword/username/";

  static const String getUserUsingEmail =
      "$userBaseURL/users/getUserUsingEmail/";

  static const String getUserUsingUsername =
      "$userBaseURL/users/getUserUsingUsername/";

  static const String updateUserInformationByEmail =
      "$userBaseURL/users/updateUserInformationByEmail/";

  static const String updateUserInformationByUsername =
      "$userBaseURL/users/forgetPassword/username/";
}

///https://www.youtube.com/watch?v=czed-wa21IU

class AppLocalPath {
  static const String localBaseURL =
      '/Users/izzy/StudioProjects/origami_structure';

  static const String baseURL = localBaseURL;
  static const String login = "$baseURL/session.json";
  static const String register = "$baseURL/registration.json";
  static const String forgotPassword = "$baseURL/forgot-password";

  static const String task = '$baseURL/jsonFile/task_data.json';
  static const String project = '$baseURL/jsonFile/project_data.json';
  static const String user = '$baseURL/jsonFile/user_data.json';
  static const String board = '$baseURL/jsonFile/board_data.json';
}
