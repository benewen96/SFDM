@isTest
public class TEST_USSI_Verification_Code {
    //create user of sys admin
    static User getUser(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new user();
        u.LastName = 'Test Coe';
        u.Email = 'test1@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test123434@test.com';
        u.CommunityNickname = 'test122';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId.Id;
        u.TimeZoneSidKey = 'GMT';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        return u;
    }
    
    //Basic test to test sending a single email
    static testmethod void testEmailOnDeferred(){
        User u = getUser();
        System.runAs(u){
            
            Test.startTest();
            Integer emailbefore = Limits.getEmailInvocations();
            USSI_Student__c student_intern = 
                new USSI_Student__c(USSI_First_Name__c='Test Data', USSI_Last_Name__c='Test Data',
                                    USSI_University__c='Test Data', USSI_Degree_Program__c='Test Data',
                                    USSI_Email_Address__c='test@example.com', USSI_Phone_Number__c='075444444444',
                                    USSI_Preferred_Contact__c='Email', USSI_Expected_Graduation__c=Date.today(),
                                    USSI_Verification_Code__c=12345, USSI_TimeStamp__c=Date.today());
            insert student_intern;
            //update timestamp to trigger the apex
            student_intern.USSI_TimeStamp__c = Date.today().addMonths(1); 
            update student_intern;
            System.assertEquals(emailbefore+1, Limits.getEmailInvocations());
            Test.stopTest();
        }
    }
    
    //Advance test to send email to multiple people
    static testmethod void testMassEmailSending(){
        User u = getUser();
        System.runAs(u){
            Integer emailbefore = Limits.getEmailInvocations();
            Test.startTest();
            //Number of times to invoke trigger
            for(Integer j = 0; j < 5; j++){
                List<USSI_Student__c> students = new List<USSI_Student__c>();
                //Number of emails sent per trigger
                for(Integer i = 0; i < 10; i++){
                    USSI_Student__c student_intern = 
                        new USSI_Student__c(USSI_First_Name__c='Test Data', USSI_Last_Name__c='Test Data',
                                            USSI_University__c='Test Data', USSI_Degree_Program__c='Test Data',
                                            USSI_Email_Address__c='test@example.com', USSI_Phone_Number__c='075444444444',
                                            USSI_Preferred_Contact__c='Email', USSI_Expected_Graduation__c=Date.today(),
                                            USSI_Verification_Code__c=12345, USSI_TimeStamp__c=Date.today());
                    insert student_intern;
                    //update timestamp to trigger the apex
                    student_intern.USSI_TimeStamp__c = Date.today().addMonths(1);
                    students.add(student_intern);
                }
                update students;
            }
            
            //Invocation is incremented per trigger invoke
            System.assertEquals(emailbefore+5, Limits.getEmailInvocations());
            Test.stopTest();
        }
    }
}