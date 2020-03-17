@isTest
public with sharing class DataTableController_Test {
    public DataTableController_Test() {

    }


    @IsTest
    static void getRecords_Test(){
        
        Test.startTest();
        User testUser = [Select id from user where id = :UserInfo.getUserId()];
        System.runAs(testUser){
            DataTableController.getRecords('Select id from contact limit 10');
        }
        Test.stopTest();
        
    }

    @IsTest
    static void countRecords_Test(){
        User testUser = [Select id from user where id = :UserInfo.getUserId()];
        Test.startTest();
        System.runAs(testUser){
            DataTableController.countRecords('Contact');
            DataTableController.countRecords(null);
        }
        Test.stopTest();
        
    }
}
