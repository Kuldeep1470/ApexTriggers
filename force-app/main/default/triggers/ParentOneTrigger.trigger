trigger ParentOneTrigger on ParentOne__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            ParentOneTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when AFTER_INSERT {
            ParentOneTriggerHandler.afterInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            ParentOneTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when AFTER_UPDATE {
            ParentOneTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when BEFORE_DELETE {
            ParentOneTriggerHandler.beforeDelete(Trigger.old);
        }
        
        when AFTER_DELETE {
            ParentOneTriggerHandler.beforeDelete(Trigger.old);    
        }
    }

}