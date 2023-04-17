trigger JunctionTrigger on Junction__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            JunctionTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when AFTER_INSERT {
            JunctionTriggerHandler.afterInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            JunctionTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when AFTER_UPDATE {
            JunctionTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when BEFORE_DELETE {
            JunctionTriggerHandler.beforeDelete(Trigger.old);
        }
        
        when AFTER_DELETE {
            JunctionTriggerHandler.beforeDelete(Trigger.old);    
        }
    }

}