public class LoginUser_AC 
{
    public String username{get; set;}
    public String password{get; set;}
   PageReference retURL;
    public PageReference getUserDetails()
    {
        List<UserDetail__c> userdetail=[select id,name,username__c,Passwordd__c from UserDetail__c];
        for(UserDetail__c validate :  userdetail)
        {
            if(validate.username__c == username && validate.Passwordd__c == password)
            {
     	           retURL = new PageReference('/apex/LoginUserDetail_VF?id='+validate.Id);                  
                retURL.setRedirect(true);              
            }
            else if(username=='Admin' && password =='Admin123')
            {
                 retURL = new PageReference('/apex/UsersList_VF');
                                            retURL.setRedirect(true);
            }   
            else
            {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Username Password Error'));  
            }
        }
        return retURL;
    }
      
}