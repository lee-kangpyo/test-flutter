class Order {
  String? ordNo;

  String? sCstNa;
  String? sMngNa;
  String? sMngHpNo;
  String? sZipAddr;
  String? sAddr;
  String? sZipNo;

  setSender(map) {
    this.sCstNa = map["sCstNa"];
  }


  String? pCstNa;
  String? pMngNa;
  String? pMngHpNo;
  String? pZipAddr;
  String? pAddr;
  String? pZipNo;
  String? userId;


  Order({this.ordNo, this.sCstNa, this.sMngNa, this.sMngHpNo, this.sZipAddr, this.sAddr, this.sZipNo, this.pCstNa, this.pMngNa, this.pMngHpNo, this.pZipAddr, this.pAddr, this.pZipNo, this.userId});

  toJson() {
    return {
      "ordNo": ordNo,

      "sCstNa": sCstNa,
      "sMngNa": sMngNa,
      "sMngHpNo": sMngHpNo,
      "sZipAddr": sZipAddr,
      "sAddr": sAddr,
      "sZipNo": sZipNo,

      "pCstNa": pCstNa,
      "pMngNa": pMngNa,
      "pMngHpNo": pMngHpNo,
      "pZipAddr": pZipAddr,
      "pAddr": pAddr,
      "pZipNo": pZipNo,
      "userId": userId,
    };
  }

}