trigger ContractTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ContactTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            ContactTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.old);
        } else if (Trigger.isDelete) {
            ContactTriggerHandler.handleBeforeDelete(Trigger.old);
        }
        // Add conditions for other "before" events as needed
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            ContactTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.old);
        } else if (Trigger.isDelete) {
            ContactTriggerHandler.handleAfterDelete(Trigger.old);
        } else if (Trigger.isUndelete) {
            ContactTriggerHandler.handleAfterUndelete(Trigger.new);
        }
        // Add conditions for other "after" events as needed
    }
}