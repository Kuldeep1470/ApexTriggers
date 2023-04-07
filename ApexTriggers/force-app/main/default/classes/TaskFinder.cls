public with sharing class TaskFinder {
    public static void getOpportunityRelatedTasks(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        List<Task> tasks = new List<Task>();
        for (Opportunity opportunity : opportunities) {
            if (opportunity.StageName != opportunityMap.get(opportunity.Id).StageName) {
                Task task = new Task();
                task.OwnerId = UserInfo.getUserId();
                task.Priority = 'High';
                task.Subject = 'Test subject';
                task.WhatId = opportunity.Id;
                task.ActivityDate = System.today();
                tasks.add(task);
            }
        }
        if (!tasks.isEmpty()) {
            update tasks;
        }
    }
}