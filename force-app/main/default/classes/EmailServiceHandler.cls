public with sharing class EmailServiceHandler{
	public static void sendEmail(){
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = new String[]{'sarveshkumar574@gmail.com'};
		message.subject = 'Subject Test Message';
		message.plainTextBody = 'This is the message body.';
		message.setHtmlBody(getTableEmailBody());
		Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
		if (results[0].success){
			System.debug('The email was sent successfully.');
		} else{
			System.debug('The email failed to send: ' + results[0].errors[0].message);
		}
	}

	public static string getTableEmailBody(){
		String htmlBody = '';
		htmlBody += '<p>Below is the present list of contact data in your org</p>';
		//open table..
		htmlBody += '<table border="1" style="border-collapse: collapse"><caption>Contact Data</caption><tr><th>RecordId</th><th>FirstName</th><th>LastName</th></tr>';
		//iterate over list and output columns/data into table rows...
		for (Contact con : [SELECT 
		                          Id, 
		                          Name, 
		                          FirstName, 
		                          LastName
		                    FROM Contact
		                    Limit 10]){
			String firstname = con.FirstName;
			if (con.FirstName == null){
				firstname = '[Not Provided]';
			}
			String lastName = con.LastName;
			if (con.LastName == null){
				lastName = '[Not Provided]';
			}
			htmlBody += '<tr><td><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + con.Id + '">' + con.Name + '</a></td><td>' + firstname + '</td><td>' + lastName + '</td></tr>';
		}
		//close table...
		htmlBody += '</table>';
		return htmlBody;
	}
}