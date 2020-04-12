@isTest
public with sharing class EmailServiceHandler_Test{
	@TestSetup
	static void makeData(){
		Insert new List<Contact>{new Contact(FirstName = 'Sarvesh', LastName = 'Kumar'), new Contact(FirstName = 'Test', LastName = 'test')};
	}

	@IsTest
	private static void test_sendEmail(){
		EmailServiceHandler.sendEmail();
	}
}