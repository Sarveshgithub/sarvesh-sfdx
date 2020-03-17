@isTest
public with sharing class DataTableController_Test {
    public DataTableController_Test() {

    }


    @IsTest
    static void getRecords_Test(){
        
        Test.startTest();
        System.runAs(UserInfo.getUserId()){
            DataTableController.getRecords('Select id from contact limit 10');
        }
        Test.stopTest();
        
    }

    @IsTest
    static void countRecords_Test(){
        Test.startTest();
        System.runAs(UserInfo.getUserId()){
            DataTableController.countRecords('Contact');
            DataTableController.countRecords(null);
        }
        Test.stopTest();
        
    }
}
