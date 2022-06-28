trigger OrderTrigger on Order (before update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            OrderTriggerHandler.ActivateOrderStatus(Trigger.new, Trigger.old);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isDelete) {
            OrderTriggerHandler.UncheckedActivatedBox(Trigger.old);
        }
    }
}