@isTest
private class HomeTest {
    
    static testmethod void checkRedirect()
    {
        homeControlls hcs=new homeControlls();
        hcs.validateAndRedirect();
        hcs.loginRedirect();
    }

}