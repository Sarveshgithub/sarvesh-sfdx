({
    doInit: function(component, event, helper) {
        
        var action = component.get('c.getMyMap');
        
        action.setCallback(this,function(response){
            console.log('data::',response.getReturnValue())
            alert(JSON.stringify(response.getReturnValue()));
            component.set('v.myMap',response.getReturnValue());
        });
        $A.enqueueAction(action);
    }

})