trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            UserTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when AFTER_INSERT {
            UserTriggerHandler.afterInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            UserTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when AFTER_UPDATE {
            UserTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when BEFORE_DELETE {
            UserTriggerHandler.beforeDelete(Trigger.old);
        }
        
        when AFTER_DELETE {
            UserTriggerHandler.beforeDelete(Trigger.old);    
        }
    }

}