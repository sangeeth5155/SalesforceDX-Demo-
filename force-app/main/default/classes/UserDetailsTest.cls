/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UserDetailsTest
 {
  static testMethod void myUnitTest()
   {
        // TO DO: implement unit test
        test.startTest();
        UserDetail__c userdetails= new UserDetail__c();
        SaveUserData sua= new SaveUserData();
        sua.name='Ram';
       sua.username='ram';
       sua.email='ram@gmail.com';
      sua.pwd='Raja';
      sua.repwd='Raja';
      sua.saveData();
           System.assertEquals('Ram',sua.name);
             PageReference pgeref = new PageReference('https://c.ap4.visual.force.com/apex/LoginUserDetail_VF');
        Test.setCurrentPage(pgeref);
         pgeref.getParameters().put('id',userdetails.id);
         LoginUser_AC login=new LoginUser_AC();
         login.username='ram';
         login.password='Raja';
         System.assertNotEquals(null,login.getUserDetails());
         test.stopTest();
    }
}