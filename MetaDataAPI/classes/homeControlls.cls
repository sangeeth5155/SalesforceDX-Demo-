public class homeControlls {
    public PageReference validateAndRedirect(){

      //Write your logic here and redirect
      PageReference retURL = new PageReference('/apex/SignupPage');
      retURL.setRedirect(true);
      return retURL;

 }
    public PageReference loginRedirect(){

      //Write your logic here and redirect
      PageReference retURL = new PageReference('/apex/Login_VF');
      retURL.setRedirect(true);
      return retURL;

 }

}