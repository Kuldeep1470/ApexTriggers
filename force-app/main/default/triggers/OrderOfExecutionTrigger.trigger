trigger OrderOfExecutionTrigger on order_of_execution__c (before insert, before update, before delete, after insert, after delete, after update) {
	switch on Trigger.operationType {
        
        when BEFORE_INSERT {
            OrderOfExecutionTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when AFTER_INSERT {
            OrderOfExecutionTriggerHandler.afterInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            OrderOfExecutionTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when AFTER_UPDATE {
            OrderOfExecutionTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when BEFORE_DELETE {
            OrderOfExecutionTriggerHandler.beforeDelete(Trigger.old);
        }
        
        when AFTER_DELETE {
            OrderOfExecutionTriggerHandler.afterDelete(Trigger.old);    
        }
   
    }
}