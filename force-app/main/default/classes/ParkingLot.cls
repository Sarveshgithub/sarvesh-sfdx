public class ParkingLot {
    class ParkedVicheal{
        String type;
        DateTime entryTime;
        private ParkedVicheal(String type){
            this.type = type;
            this.entryTime = System.now();
        }
    }
    private  Map<String, Integer> availableSlotsPerType;
    private  Map<String, Double> pricePerType;
    private Map<String, String> vichalType;
    private Map<String, DateTime> vichalEntryTime;
    private Map<String,ParkedVicheal> parkedVichealDetail = new Map<String,ParkedVicheal>(); 
    
    public ParkingLot(Map<String, Integer> availableSlotsPerType, Map<String, Double> pricePerType) {
        // Implement initializer
        this.availableSlotsPerType = availableSlotsPerType;
        this.pricePerType = pricePerType;
    }
    public Map<String,ParkedVicheal> getDetail(){
        return parkedVichealDetail;
    }
    public Boolean onEnter(String plate, String type) {
        // Implement onEnter
        Boolean isAvailable;
        isAvailable = checkAvailabily(type);
        if(isAvailable){
            parkedVichealDetail.put(plate, new ParkedVicheal(type));
            decrementSlots(type);
        }
        return isAvailable; 
    }
    
    public Double onExit(String plate) {
        // Implement onExit
        Double parkingPrice = getPrice(plate);
        incrementSlots(parkedVichealDetail.get(plate).type);
        parkedVichealDetail.remove(plate);
        return parkingPrice;
    }
    
    private Boolean checkAvailabily(String type){
        if(availableSlotsPerType.containskey(type) && availableSlotsPerType.get(type) > 0){
            return true;
        }
        return false;
    }
    
    private void incrementSlots(String type){
        if(availableSlotsPerType.containskey(type)){
            availableSlotsPerType.put(type, availableSlotsPerType.get(type) + 1);
        }
    }
    
    private void decrementSlots(String type){
        if(availableSlotsPerType.containskey(type)){
            availableSlotsPerType.put(type, availableSlotsPerType.get(type) - 1);
        }
    }
    
    private Double getPrice(String plate){
        DateTime entryTime = parkedVichealDetail.get(plate).entryTime;
        String type = parkedVichealDetail.get(plate).type;
        Double totalMinutes = Double.valueOf((entryTime.getTime() - System.now().getTime())/1000/60);
        return totalMinutes * pricePerType.get(type);
    }
    
}