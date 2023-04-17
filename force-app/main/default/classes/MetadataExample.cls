public class MetadataExample {

    public class MyCallback implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            // Deployment was successful
        } else {
            // Deployment was not successful
        }
    }
}
    
    public void updateMetadata () {
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = 'MyNamespace__MyMetadataTypeName.MyMetadataRecordName';
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'customField__c';
        customField.value = 'New value';
        customMetadata.values.add(customField);
        Metadata.DeployContainer deployContainer = new Metadata.DeployContainer();
        deployContainer.addMetadata(customMetadata);
        MyCallback callback = new MyCallback();
        Metadata.Operations.enqueueDeployment(deployContainer, callback);
        Id asyncResultId = Metadata.Operations.enqueueDeployment(deployContainer, callback);}
}