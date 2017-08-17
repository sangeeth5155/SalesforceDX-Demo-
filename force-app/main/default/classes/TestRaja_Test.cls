@isTest
private class TestRaja_Test {
  
    static testmethod void checkCredentialMethod()
    {
        UserDetail__c u = new UserDetail__c();
        u.username__c = 'Priya';
        u.Passwordd__c = 'test123';
        INSERT u;
        
        Test.StartTest(); 
        
          LoginUser_AC loignIns = new LoginUser_AC(); 
          loignIns.username = 'Priya';
          loignIns.password = 'test123';
          loignIns.getUserDetails();	
        
        Test.StopTest();
        
    }
    static testmethod void checkAdminMethod()
    { 
         UserDetail__c u = new UserDetail__c();
         u.username__c = 'Priya';
         u.Passwordd__c = 'test123';
         INSERT u;
        
         Test.StartTest(); 
        
          LoginUser_AC loignIns = new LoginUser_AC(); 
          loignIns.username = 'Admin';
          loignIns.password = 'Admin123';
          loignIns.getUserDetails();
        
        Test.StopTest();
    }
}