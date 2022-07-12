trigger OrderTrigger on Order (before update, after delete, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            OrderTriggerHandler.ActivateOrderStatus(Trigger.new, Trigger.old);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            OrderTriggerHandler.CheckAccountsActiveField(Trigger.new);
        }
        if (Trigger.isDelete) {
            OrderTriggerHandler.UncheckedActivatedBox(Trigger.old);
        }
    }
}