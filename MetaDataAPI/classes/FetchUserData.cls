public class FetchUserData {
    public String recname{set;get;}
    public String username{set;get;}
    public String email{set;get;}
    public boolean hideEditButton{set;get;}
    public boolean enableEditing{set;get;}
    public boolean showUpdate{set;get;}
    public String myEvent{set;get;}
    
    public List<UserDetail__c> getRecordVal{set;get;}
    //public UserDetail__c userUpdate;
    public String recid;
    PageReference retURL;
    public FetchUserData()
    {
        hideEditButton=true;
        enableEditing=true;
        showUpdate=false;
        myEvent='';
    }
    public void getRecordValues()
    {
        recid=ApexPages.currentPage().getParameters().get('id');
        System.debug(recid);
        getRecordVal=[select Name,email__c,username__c,passwordd__c from UserDetail__c where id =: recid];
        for(UserDetail__c detailpagerecs:getRecordval )
        {
            recname=detailpagerecs.Name;
            email=detailpagerecs.Email__c;
            username=detailpagerecs.username__c;
        }
        
    }
    /*public List<UserDetail__c> retrieveData()
{
return getRecordVal;
}*/
    public void hideData()
    {
        hideEditButton=false;
        enableEditing=false;
        showUpdate=true;
        myEvent='onclick';
    }
    public PageReference updateMyEditedRecord()
    {
        System.debug('recid------------'+recid);
        UserDetail__c userUpdate =[select Name,Email__c,username__c from UserDetail__c where id =:recid];
        userUpdate.Name = recname;
        userUpdate.Email__c=email;
        userUpdate.username__c=username;
        System.debug(recname+'******************* '+email+' *********'+username);
        update userUpdate;
         retURL = new PageReference('/apex/LoginUserDetail_VF?id='+recid);
         retURL.setRedirect(true);
        return retURL;
        
    }
     public PageReference Logout()
    {
        retURL = new PageReference('/apex/Home');
         retURL.setRedirect(true);
         return retURL;
    }
 /*   public PageReference remove(){
       
        /*PageReference pageRef = new PageReference('/default/secur/logout.jsp');
        pageRef.setRedirect(true);
        String getmySession=Userinfo.getSessionId();
        
        System.debug(getmySession);*/
         /*Cache.Session.remove('session_value');
        
       return null;
        
    }    */
}