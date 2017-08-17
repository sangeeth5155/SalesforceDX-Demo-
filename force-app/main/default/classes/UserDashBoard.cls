public class UserDashBoard {
    public String name{get;set;}
    public String email{get;set;}
    public String username{get;set;}
    public String password{get;set;}
    public Id userid{get;set;}
    public DateTime createdDate{get;set;}
    public  List<UserDetail__c> users{get;set;}
    public void getAllUsers()
    {
      users=[select Name,username__c,Passwordd__c,Email__c,CreatedDate from UserDetail__c limit 10];
        /*for(UserDetail__c userdetails:users)
        {
            name=userdetails.Name;
            email=userdetails.Email__c;
            username=userdetails.username__c;
            password=userdetails.Passwordd__c;
            createdDate=userdetails.CreatedDate;
        }*/
    }
    public List<UserDetail__c> usersall()
    {
        return users;
    }
    public void showUserData()
    {
Id myId = ApexPages.currentPage().getParameters().get('userid');
        System.debug(myId);
        
    }
}