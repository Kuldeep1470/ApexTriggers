trigger PositionTrigger on Position__c (before insert, before update, before delete, after insert, after update, after delete) {
    switch on Trigger.operationType {
        
        when BEFORE_INSERT {
            PositionTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when AFTER_INSERT {
            PositionTriggerHandler.afterInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            PositionTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when AFTER_UPDATE {
            PositionTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when BEFORE_DELETE {
            PositionTriggerHandler.beforeDelete(Trigger.old);
        }
        
        when AFTER_DELETE {
            PositionTriggerHandler.beforeDelete(Trigger.old);    
        }
}
}