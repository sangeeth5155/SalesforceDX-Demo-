@isTest
private class TestFetchData 
{    
 
    
    static testMethod void testFetch() {
      UserDetail__c u = new UserDetail__c();
        u.Name='Raja';
        u.Email__c='rja@gmail.com';
        u.username__c='raja';
        u.Passwordd__c='raja';
        insert u;
        Test.StartTest();       
        FetchUserData fuse= new FetchUserData();
          Test.setCurrentPageReference(new PageReference('Page.LoginUserDetail_VF'));
        Apexpages.currentPage().getparameters().put('id',u.id);
       System.debug(Apexpages.currentPage().getparameters().put('id',u.id));
        //string recid=fuse.recid;
       fuse.getRecordValues();        
        //fuse.hideData();        
        Test.stopTest();
        
    }
   static testMethod void updateUsers()
    {
       UserDetail__c u = new UserDetail__c();
        u.Name='Hari';
        u.Email__c='hari@gmail.com';
        u.username__c='hari';
        u.Passwordd__c='hari';
        insert u;       
        Test.StartTest();
        FetchUserData fuse= new FetchUserData();
        Test.setCurrentPageReference(new PageReference('Page.LoginUserDetail_VF'));
        Apexpages.currentPage().getparameters().put('id',u.id);
        fuse.getRecordValues();
        System.debug(fuse.recid);
        fuse.recname='Raja.M';
        fuse.email='mraja@gmail.com';
        fuse.username='raj';        
        fuse.updateMyEditedRecord();
        
    }
     static testMethod void hideusers()
     {
         Test.StartTest(); 
         FetchUserData fuse= new FetchUserData();
         fuse.hideData();
     }
    static testMethod void logoutUsers()
     {
         Test.StartTest(); 
         FetchUserData fuse= new FetchUserData();
         fuse.Logout();
     }
}