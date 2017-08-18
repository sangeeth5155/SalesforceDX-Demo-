@isTest
private class UserTestDashboard {
     static testmethod void checkBoard()
    {
          UserDetail__c u = new UserDetail__c();
        u.Name='Raja';
        u.Email__c='rja@gmail.com';
        u.username__c='raja';
        u.Passwordd__c='raja';
        insert u;
        UserDashBoard usb=new UserDashBoard();
        usb.name=u.Name;
        usb.email=u.Email__c;
        usb.username=u.username__c;
        usb.password=u.Passwordd__c;
        usb.userid=u.Id;
        usb.createdDate=u.CreatedDate;
        usb.getAllUsers();
        usb.usersall();
        usb.showUserData();
    }

}