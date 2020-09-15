class Dispositivo {
    Dispositivo({
        this.id,
        this.nombreDispositivo,
        this.chipId,
        
    });

    int id;
    String nombreDispositivo;
    String chipId;
    

    factory Dispositivo.fromJson(Map<String, dynamic> json) => Dispositivo(
        id: json["id"],
        nombreDispositivo: json["description"],
        chipId: json["mac_address"],
        
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombreDispositivo": nombreDispositivo,
        "chipId": chipId,
        
        "description": nombreDispositivo,
        "mac_address": chipId,
    };
}
