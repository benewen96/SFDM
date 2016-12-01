trigger USSI_Verification_Code on USSI_Student__c (after update) {
    List<USSI_Student__c> studentList = new List<USSI_Student__c>();
    for(USSI_Student__c student : Trigger.new) {
        //Timestamp is updated when a user clicks the verification button
        if(student.USSI_Timestamp__c != Trigger.oldMap.get(student.Id).USSI_Timestamp__c ){
            studentList.add(student);
        } 
    }
    sendEmail(studentList);
    
    //Send a verification code to a list of students
    void sendEmail(List<USSI_Student__c> students) {
        //A list of email messages to be sent
        List<Messaging.SingleEmailMessage> lstmail = new List<Messaging.SingleEmailMessage>();
        for(Integer i = 0; i < students.size(); i++){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.subject= 'Welcome to US intern project portal';
            mail.setHtmlBody('Hello ' + students.get(i).USSI_Full_Name__c + ', <br><br>Please visit the following website,' + 
                             ' <a href="https://cirr-ussi.herokuapp.com">https://cirr-ussi.herokuapp.com</a>, to view all the projects on offer and prioritise the top ten projects of your' + 
                             ' interest.<br><br> Your login credentials for the portal are as follows:<br>' + 
							'Email: <b>' + students.get(i).USSI_Email_Address__c + '</b> <br>Verification Code: <b>'
                             + Integer.valueOf(students.get(i).USSI_Verification_Code__c) + ' </b>'
                             + '<br><br>Thanks and Kind Regards,<br><br>IT Summer Intern Programme Team<br>Eli Lilly and Company');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setToAddresses(new String[]{students.get(i).USSI_Email_Address__c});
            mail.setSenderDisplayName('IT Summer Intern Programme Team');
            mail.setSaveAsActivity(false);
            lstmail.add(mail);
        }
        //Messaging.sendEmail has a governor limit of 10 so have to be careful
        Messaging.sendEmail(lstmail);
    }  
    
}