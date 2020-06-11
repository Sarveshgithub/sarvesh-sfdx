@istest
public with sharing class ToDoController_Test{
	@TestSetup
	static void makeData(){
		insert new List<Task>{new Task(Description = 'test0', Status = 'Not Started', Subject = 'Other', Priority = 'Normal', OwnerId = UserInfo.getUserId()), new Task(Description = 'test0', Status = 'Not Started', Subject = 'Other', Priority = 'Normal', OwnerId = UserInfo.getUserId())};
	}

	@istest
	private static void fetchTask_test(){
		System.assert(ToDoController.fetchTask().size() == 2);
	}

	@istest
	private static void createTask_test(){
		System.assert(ToDoController.createTask('newTask', 'Not Started') == true);
	}

	@istest
	private static void updateTask_test(){
		Id taskId = [SELECT Id
		             from Task
		             limit 1][0].Id;
		System.assert(ToDoController.updateTask(taskId, 'newTask', 'Not Started') == true);
	}

	@istest
	private static void deleteTask_test(){
		Id taskId = [SELECT Id
		             from Task
		             limit 1][0].Id;
		System.assert(ToDoController.deleteTask(taskId) == true);
	}
}