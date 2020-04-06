@isTest public class TestClassQueueMigration {
    @isTest private
        static void testQueue(){
            String queueName = getQueueIdByName('Test');
            system.assertEquals('Test', queueName);
        }
      
       private
           static String getQueueIdByName(String queueName){
               return [SELECT
                       Queue.Id,
                       Queue.Name
                       FROM
                       QueueSObject
                       WHERE
                       Queue.Type = :LeadConstant.OBJECT_NAME_QUEUE
                       AND Queue.Name = :queueName LIMIT 1].Queue.Name;
           }
   }