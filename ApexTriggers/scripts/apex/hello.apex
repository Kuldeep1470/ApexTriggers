for (Account account : [SELECT Id, Name, ParentId, Parent.Name, Parent.Parent.Name FROM Account]) {
    System.debug(account.Name +'-------->'+ account.Parent.Name +'------->' + account.Parent.Parent.Name);
}