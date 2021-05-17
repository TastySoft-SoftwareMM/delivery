import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

Future showMultiGiftDialog(List giftList, List getPromoStockList, context) async {
    for (var a = 0; a < giftList.length; a++) {
      for(var ab = 0; ab < giftList[a]["giftInfoList"].length; ab++) {
        List<Map<String, Object>> list = [];
        for (var b = 0; b < giftList[a]["giftInfoList"][ab].length; b++) {
          if(giftList[a]["giftInfoList"][ab][b]["discountItemRuleType"] == "Total Item") {
            double qty = double.parse((giftList[a]["giftInfoList"][ab][b]["discountItemQty"]/giftList[a]["giftInfoList"].length).toInt().toString());

            if(ab == giftList[a]["giftInfoList"].length -1) {
              
              qty = double.parse((giftList[a]["giftInfoList"][ab][b]["discountItemQty"]/giftList[a]["giftInfoList"].length).toInt().toString()) + 
              giftList[a]["giftInfoList"][ab][b]["discountItemQty"]%giftList[a]["giftInfoList"].length;

            }

            double orQty = 0.0;

            if(giftList[a]["giftInfoList"][ab][b]["discountItemEndType"] == "OR") {
              orQty = double.parse((qty ~/ giftList[a]["giftInfoList"][ab].length).toInt().toString());
            } else {
              if(b-1 > -1) {
                if(giftList[a]["giftInfoList"][ab][b-1]["discountItemEndType"] == "OR") {
                  orQty = double.parse((qty ~/ giftList[a]["giftInfoList"][ab].length).toInt().toString()) + (qty%giftList[a]["giftInfoList"][ab].length);
                }
              }
            }

            list.add({
              "discountItemEndType": giftList[a]["giftInfoList"][ab][b]["discountItemEndType"],
              "discountStockCode": giftList[a]["giftInfoList"][ab][b]["discountStockCode"],
              "discountItemDesc": giftList[a]["giftInfoList"][ab][b]["discountItemDesc"],
              "discountItemQty": giftList[a]["giftInfoList"][ab][b]["discountItemEndType"] == "OR" ||
                                  giftList[a]["giftInfoList"][ab][b-1]["discountItemEndType"] == "OR" ? 
                                  orQty : qty,
              "discountItemType": giftList[a]["giftInfoList"][ab][b]["discountItemType"],
              "discountItemRuleType": giftList[a]["giftInfoList"][ab][b]["discountItemRuleType"],
              "discountTotalQty" : giftList[a]["giftInfoList"][ab][b]["discountItemQty"],
              "discountStockSyskey": giftList[a]["giftInfoList"][ab][b]["discountStockSyskey"],
              "discountItemSyskey": giftList[a]["giftInfoList"][ab][b]["discountItemSyskey"],
              "discountGiftCode": giftList[a]["giftInfoList"][ab][b]["discountGiftCode"],
              "checkValue": true
            });

          } else {
            list.add({
              "discountItemEndType": giftList[a]["giftInfoList"][ab][b]["discountItemEndType"],
              "discountStockCode": giftList[a]["giftInfoList"][ab][b]["discountStockCode"],
              "discountItemDesc": giftList[a]["giftInfoList"][ab][b]["discountItemDesc"],
              "discountItemQty": giftList[a]["giftInfoList"][ab][b]["discountItemQty"],
              "discountItemType": giftList[a]["giftInfoList"][ab][b]["discountItemType"],
              "discountItemRuleType": giftList[a]["giftInfoList"][ab][b]["discountItemRuleType"],
              "discountStockSyskey": giftList[a]["giftInfoList"][ab][b]["discountStockSyskey"],
              "discountItemSyskey": giftList[a]["giftInfoList"][ab][b]["discountItemSyskey"],
              "discountGiftCode": giftList[a]["giftInfoList"][ab][b]["discountGiftCode"],
              "checkValue": true
            });
          }

          if (b == giftList[a]["giftInfoList"][ab].length - 1) {
            giftList[a]["giftInfoList"][ab] = list;

            for(var c = 0; c < giftList[a]["giftInfoList"][ab].length; c++) {
              giftList[a]["giftQty"] = giftList[a]["giftQty"] + giftList[a]["giftInfoList"][ab][c]["discountItemQty"];
            }
          }
        }
      }
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0))),
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Color(0xffe53935),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            "Gift List",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 160,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView(
                          children: <Widget>[
                            for(var x = 0; x < giftList.length; x++)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    for(var y = 0; y < giftList[x]["stockList"].length; y++)
                                    Text(
                                      getPromoStockList.where((element) => element["itemSyskey"] == giftList[x]["stockList"][y]).toList().length == 0 ? "" :
                                      "${getPromoStockList.where((element) => element["itemSyskey"] == giftList[x]["stockList"][y]).toList()[0]["itemDesc"]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        color: Color(0xffe53935)),
                                    ),
                                  ],
                                ),
                                if(giftList[x]["giftInfoList"].length != 0)
                                if(giftList[x]["giftInfoList"][0].length != 0)
                                if(giftList[x]["giftInfoList"][0][0].length != 0)
                                if(giftList[x]["giftInfoList"][0][0]["discountItemRuleType"] == "Total Item")
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 5),
                                    Text(
                                      "Total Gift Qty (${giftList[x]["giftQty"].toInt()}/${giftList[x]["giftInfoList"][0][0]["discountTotalQty"].toInt()})",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xffe53935)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Table(
                                  border: TableBorder.all(
                                    color: Colors.grey[300],
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                  children: [
                                    for (var a = 0; a < giftList[x]["giftInfoList"].length; a++)
                                      TableRow(children: [
                                        Column(
                                          children: <Widget>[
                                            if (giftList[x]["giftInfoList"][a].length == 1)
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                                        child: SizedBox(
                                                          height: 24.0,
                                                          width: 24.0,
                                                          child: Checkbox(
                                                            value: giftList[x]["giftInfoList"][a][0]
                                                                ["checkValue"],
                                                            activeColor: Color(0xffe53935),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                print(value);
                                                                giftList[x]["giftInfoList"][a][0]["checkValue"] =
                                                                    true;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                                          child: Text(
                                                            '${giftList[x]["giftInfoList"][a][0]["discountItemDesc"]}'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if(giftList[x]["giftInfoList"][a][0]["discountItemRuleType"] == "Total Item")
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              if(giftList[x]["giftInfoList"][a][0]["discountItemQty"] <= 1) {
                                                                //
                                                              } else {
                                                                giftList[x]["giftInfoList"][a][0]["discountItemQty"]--;
                                                                giftList[x]["giftQty"]--;
                                                              }
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Icon(
                                                              const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                                              color: Colors.white,
                                                              size: 19,
                                                            ),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffe53935),
                                                          borderRadius: BorderRadius.circular(3),
                                                          border: Border(
                                                            top: BorderSide(width: 0.5, color: Colors.white),
                                                            bottom: BorderSide(width: 0.5, color: Colors.white),
                                                            left: BorderSide(width: 0.5, color: Colors.white),
                                                            right: BorderSide(width: 0.5, color: Colors.white),
                                                          ),
                                                        ),
                                                        height: 27,
                                                        width: 27,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          _showIntDialog(giftList[x]["giftInfoList"][a][0]["discountItemQty"].toInt(), context).then((value) {
                                                            setState(() {
                                                              giftList[x]["giftInfoList"][a][0]["discountItemQty"] = 0.0;
                                                              giftList[x]["giftQty"] = 0.0;
                                                              for(var i = 0; i < giftList[x]["giftInfoList"].length; i++) {
                                                                giftList[x]["giftQty"] = giftList[x]["giftQty"] + giftList[x]["giftInfoList"][i][0]["discountItemQty"];
                                                              }

                                                              if(value >= (giftList[x]["giftInfoList"][a][0]["discountTotalQty"] - giftList[x]["giftQty"])) {
                                                                value = (giftList[x]["giftInfoList"][a][0]["discountTotalQty"] - giftList[x]["giftQty"]);
                                                              }

                                                              giftList[x]["giftInfoList"][a][0]["discountItemQty"] = value;

                                                              giftList[x]["giftQty"] = 0.0;

                                                              for(var i = 0; i < giftList[x]["giftInfoList"].length; i++) {
                                                                giftList[x]["giftQty"] = giftList[x]["giftQty"] + giftList[x]["giftInfoList"][i][0]["discountItemQty"];
                                                              }
                                                            });
                                                          });
                                                        },                                                                                                                         
                                                        child: Container(
                                                          child: Center(child: Text("${giftList[x]["giftInfoList"][a][0]["discountItemQty"].toInt()}")),
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(width: 0.5, color: Colors.grey),
                                                              bottom: BorderSide(width: 0.5, color: Colors.grey),
                                                              left: BorderSide(width: 0.5, color: Colors.white),
                                                              right: BorderSide(width: 0.5, color: Colors.white),
                                                            ),
                                                          ),
                                                          height: 27,
                                                          width: 45,
                                                        ),
                                                      ),
                                                      Container(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              if(giftList[x]["giftQty"] >= giftList[x]["giftInfoList"][a][0]["discountTotalQty"]) {
                                                                //
                                                              } else {
                                                                giftList[x]["giftInfoList"][a][0]["discountItemQty"]++;
                                                                giftList[x]["giftQty"]++;
                                                              }
                                                            });
                                                          },
                                                          child: Center(child: Icon(Icons.add, size: 19, color: Colors.white)),
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Color(0xffe53935),
                                                          border: Border(
                                                            top: BorderSide(width: 0.5, color: Colors.white),
                                                            bottom: BorderSide(width: 0.5, color: Colors.white),
                                                            left: BorderSide(width: 0.5, color: Colors.white),
                                                            right: BorderSide(width: 0.5, color: Colors.white),
                                                          ),
                                                        ),
                                                        height: 27,
                                                        width: 27,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            if (giftList[x]["giftInfoList"][a].length > 1)
                                            for (var b = 0; b < giftList[x]["giftInfoList"][a].length; b++)
                                            Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 12),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                                        child: SizedBox(
                                                          height: 24.0,
                                                          width: 24.0,
                                                          child: Checkbox(
                                                            value: giftList[x]["giftInfoList"][a][b]
                                                                ["checkValue"],
                                                            activeColor: Color(0xffe53935),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                print(value);
                                                                giftList[x]["giftInfoList"][a][b]["checkValue"] = value;
                                                                if(value == false) {
                                                                  if(giftList[x]["giftInfoList"][a][b]["discountItemEndType"] == "OR") {
                                                                    if(giftList[x]["giftInfoList"][a][b+1]["checkValue"] == false) {
                                                                      giftList[x]["giftInfoList"][a][b]["checkValue"] = true;
                                                                    }
                                                                  } else {
                                                                    if(b-1 > -1) {
                                                                      if(giftList[x]["giftInfoList"][a][b-1]["discountItemEndType"] == "OR") {
                                                                        if(giftList[x]["giftInfoList"][a][b-1]["checkValue"] == false) {
                                                                          giftList[x]["giftInfoList"][a][b]["checkValue"] = true;
                                                                        }
                                                                      }
                                                                    }
                                                                  }
                                                                }

                                                                if(giftList[x]["giftInfoList"][a][b]["checkValue"] == false) {
                                                                  giftList[x]["giftQty"] = giftList[x]["giftQty"] - giftList[x]["giftInfoList"][a][b]["discountItemQty"];
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                                          child: Text(
                                                              '${giftList[x]["giftInfoList"][a][b]["discountItemDesc"]}'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if(giftList[x]["giftInfoList"][a][0]["discountItemRuleType"] == "Total Item")
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              if(giftList[x]["giftInfoList"][a][b]["discountItemQty"] <= 1) {
                                                                //
                                                              } else if(giftList[x]["giftInfoList"][a][b]["checkValue"] == false) {
                                                                giftList[x]["giftInfoList"][a][b]["discountItemQty"]--;
                                                              } else {
                                                                giftList[x]["giftInfoList"][a][b]["discountItemQty"]--;
                                                                giftList[x]["giftQty"]--;
                                                              }
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Icon(
                                                              const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                                              color: Colors.white,
                                                              size: 19,
                                                            ),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffe53935),
                                                          borderRadius: BorderRadius.circular(3),
                                                          border: Border(
                                                            top: BorderSide(width: 0.5, color: Colors.white),
                                                            bottom: BorderSide(width: 0.5, color: Colors.white),
                                                            left: BorderSide(width: 0.5, color: Colors.white),
                                                            right: BorderSide(width: 0.5, color: Colors.white),
                                                          ),
                                                        ),
                                                        height: 27,
                                                        width: 27,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          _showIntDialog(giftList[x]["giftInfoList"][a][b]["discountItemQty"].toInt(), context).then((value) {
                                                            setState(() {
                                                              if(giftList[x]["giftInfoList"][a][b]["checkValue"] == false) {
                                                                giftList[x]["giftInfoList"][a][b]["discountItemQty"] = value;
                                                              } else {
                                                                giftList[x]["giftInfoList"][a][b]["discountItemQty"] = 0.0;
                                                                giftList[x]["giftQty"] = 0.0;
                                                                for(var i = 0; i < giftList[x]["giftInfoList"].length; i++) {
                                                                  giftList[x]["giftQty"] = giftList[x]["giftQty"] + giftList[x]["giftInfoList"][i][0]["discountItemQty"];
                                                                }

                                                                if(value >= (giftList[x]["giftInfoList"][a][b]["discountTotalQty"] - giftList[x]["giftQty"])) {
                                                                  value = (giftList[x]["giftInfoList"][a][b]["discountTotalQty"] - giftList[x]["giftQty"]);
                                                                }

                                                                giftList[x]["giftInfoList"][a][b]["discountItemQty"] = value;

                                                                giftList[x]["giftQty"] = 0.0;

                                                                for(var i = 0; i < giftList[x]["giftInfoList"].length; i++) {
                                                                  giftList[x]["giftQty"] = giftList[x]["giftQty"] + giftList[x]["giftInfoList"][i][0]["discountItemQty"];
                                                                }
                                                              }
                                                            });
                                                          });
                                                        },                                                                                                                         
                                                        child: Container(
                                                          child: Center(child: Text("${giftList[x]["giftInfoList"][a][b]["discountItemQty"].toInt()}")),
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(width: 0.5, color: Colors.grey),
                                                              bottom: BorderSide(width: 0.5, color: Colors.grey),
                                                              left: BorderSide(width: 0.5, color: Colors.white),
                                                              right: BorderSide(width: 0.5, color: Colors.white),
                                                            ),
                                                          ),
                                                          height: 27,
                                                          width: 45,
                                                        ),
                                                      ),
                                                      Container(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              if(giftList[x]["giftQty"] >= giftList[x]["giftInfoList"][a][b]["discountTotalQty"]) {
                                                                //
                                                              } else if(giftList[x]["giftInfoList"][a][b]["checkValue"] == false) {
                                                                giftList[x]["giftInfoList"][a][b]["discountItemQty"]++;
                                                              } else {
                                                                giftList[x]["giftInfoList"][a][b]["discountItemQty"]++;
                                                                giftList[x]["giftQty"]++;
                                                              }
                                                            });
                                                          },
                                                          child: Center(child: Icon(Icons.add, size: 19, color: Colors.white)),
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Color(0xffe53935),
                                                          border: Border(
                                                            top: BorderSide(width: 0.5, color: Colors.white),
                                                            bottom: BorderSide(width: 0.5, color: Colors.white),
                                                            left: BorderSide(width: 0.5, color: Colors.white),
                                                            right: BorderSide(width: 0.5, color: Colors.white),
                                                          ),
                                                        ),
                                                        height: 27,
                                                        width: 27,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ]),
                                  ],
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButton(
                              color: Color(0xffe53935),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Center(
                                    child: Text(
                                      'OK',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                List arrangeList = [];
                                for(var a = 0; a < giftList.length; a++) {
                                  if(giftList[a]["giftInfoList"][0][0]["discountItemRuleType"] == "Total Item") {
                                    if((giftList[a]["giftInfoList"][0][0]["discountTotalQty"].toInt() - giftList[a]["giftQty"].toInt()) != 0) {
                                      Fluttertoast.showToast(
                                        msg: "Need ${giftList[a]["giftInfoList"][0][0]["discountTotalQty"].toInt() - giftList[a]["giftQty"].toInt()} more Gift!",
                                        toastLength:
                                            Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    } else {
                                    
                                      for(var ab = 0; ab < giftList[a]["giftInfoList"].length; ab++) {
                                        List list = [];
                                        for(var b = 0; b < giftList[a]["giftInfoList"][ab].length; b++) {
                                          List<Map<String, Object>> giftInfoList = [];
                                          if(giftList[a]["giftInfoList"][ab][b]["checkValue"] == true) {
                                            giftInfoList = [
                                              {
                                                "discountItemEndType": giftList[a]["giftInfoList"][ab][b]["discountItemEndType"],
                                                "discountStockCode": giftList[a]["giftInfoList"][ab][b]["discountStockCode"],
                                                "discountItemDesc": giftList[a]["giftInfoList"][ab][b]["discountItemDesc"],
                                                "discountItemQty": giftList[a]["giftInfoList"][ab][b]["discountItemQty"],
                                                "discountItemType": giftList[a]["giftInfoList"][ab][b]["discountItemType"],
                                                "discountStockSyskey": giftList[a]["giftInfoList"][ab][b]["discountStockSyskey"],
                                                "discountItemSyskey": giftList[a]["giftInfoList"][ab][b]["discountItemSyskey"],
                                                "discountGiftCode": giftList[a]["giftInfoList"][ab][b]["discountGiftCode"],
                                                "discountItemRuleType": giftList[a]["giftInfoList"][ab][b]["discountItemRuleType"]
                                              }
                                            ];
                                          }

                                          list.add(giftInfoList);

                                          if (b == giftList[a]["giftInfoList"][ab].length - 1) {
                                            giftList[a]["giftInfoList"][ab] = list;
                                          }
                                        }
                                      }


                                      if(a == giftList.length-1) {
                                        for(var dd = 0; dd < giftList.length; dd++) {
                                          arrangeList.add({
                                            "giftInfoList" : giftList[dd]["giftInfoList"][0],
                                            "stockList" : giftList[dd]["stockList"],
                                            "discountDetailSyskey" : giftList[dd]["discountDetailSyskey"]
                                          });

                                          if(dd == giftList.length -1) {
                                            giftList = arrangeList;
                                            Navigator.pop(context, giftList);
                                          }
                                        }
                                      }
                                            
                                    }
                                  } else {
                                    for(var ab = 0; ab < giftList[a]["giftInfoList"].length; ab++) {
                                      List<Map<String, Object>> list = [];
                                      for(var b = 0; b < giftList[a]["giftInfoList"][ab].length; b++) {
                                        if(giftList[a]["giftInfoList"][ab][b]["checkValue"] == true) {
                                        list.add({
                                          "discountItemEndType": giftList[a]["giftInfoList"][ab][b]["discountItemEndType"],
                                          "discountStockCode": giftList[a]["giftInfoList"][ab][b]["discountStockCode"],
                                          "discountItemDesc": giftList[a]["giftInfoList"][ab][b]["discountItemDesc"],
                                          "discountItemQty": giftList[a]["giftInfoList"][ab][b]["discountItemQty"],
                                          "discountItemType": giftList[a]["giftInfoList"][ab][b]["discountItemType"],
                                          "discountStockSyskey": giftList[a]["giftInfoList"][ab][b]["discountStockSyskey"],
                                          "discountItemSyskey": giftList[a]["giftInfoList"][ab][b]["discountItemSyskey"],
                                          "discountGiftCode": giftList[a]["giftInfoList"][ab][b]["discountGiftCode"],
                                          "discountItemRuleType": giftList[a]["giftInfoList"][ab][b]["discountItemRuleType"]
                                        });
                                        }

                                        if (b == giftList[a]["giftInfoList"][ab].length - 1) {
                                          giftList[a]["giftInfoList"][ab] = list;
                                        }
                                      }
                                    }
                                    if(a == giftList.length-1) {
                                      for(var dd = 0; dd < giftList.length; dd++) {
                                        arrangeList.add({
                                          "giftInfoList" : giftList[dd]["giftInfoList"],
                                          "stockList" : giftList[dd]["stockList"],
                                          "discountDetailSyskey" : giftList[dd]["discountDetailSyskey"]
                                        });

                                        if(dd == giftList.length -1) {
                                          giftList = arrangeList;
                                          Navigator.pop(context, giftList);
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  NumberPicker integerNumberPicker;

  Future _showIntDialog(var currentPrice, context) async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 1,
          maxValue: 99999,
          step: 1,
          initialIntegerValue: currentPrice,
        );
      },
    ).then((num value) {
      if (value != null) {
        currentPrice = value;
      }
    });
    return currentPrice;
  }