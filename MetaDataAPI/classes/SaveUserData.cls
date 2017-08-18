public class SaveUserData {
    List<UserDetail__c> usd=new List<UserDetail__c>();
    public UserDetail__c uds {get; set;}
    public String name{get; set;}
    public String username{get; set;}
    public String pwd{get; set;}
    public String email{get; set;}
    public String repwd{get; set;}
    public list<UserDetail__c> checkUsername;
    public SaveUserData()
    {
        uds=new UserDetail__c();   
    }
    /*public void validate()
{
if(pwd!=repwd)
{

}

}*/
    public PageReference saveData()
    {
        uds.Name=name;
        
        uds.username__c=username;
        uds.Email__c=email;
        uds.Passwordd__c=pwd;
        checkUserName=[select username__c from UserDetail__c where username__c =: username ];
        if(checkUserName.size()>0)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Username already exist'));
        }
        
        else
        {
            if( uds.Passwordd__c == repwd)
        {
            usd.add(uds);
            //System.debug(uds);
            insert uds;
            PageReference retURL = new PageReference('/apex/Home');
            retURL.setRedirect(true);
            return retURL;
        }
            else
            {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Password does not match'));  
            }
            
        }
        return null;
    }
}