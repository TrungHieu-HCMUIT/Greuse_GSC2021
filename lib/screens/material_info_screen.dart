import 'package:flutter/material.dart';

class MaterialInfoScreen extends StatefulWidget {
  static const id = 'material_info_screen';
  @override
  _MaterialInfoScreenState createState() => _MaterialInfoScreenState();
}

class _MaterialInfoScreenState extends State<MaterialInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return InfoSection();
  }
}

class InfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
          icon: ImageIcon(AssetImage('assets/icons/back.png')),
          color: Colors.teal[400],
        ),
        title: Text(
          'Material Info',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal[400],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 30, 24, 24),
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Paper
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Paper",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Phế liệu phổ biến, thời gian phân hủy ngắn (từ vài tuần đến vài tháng), khả năng tái chế cao tuy nhiên thường bị vứt bỏ sau khi sử dụng, không có quy trình thu gom hợp lí.",
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Image.network(
                      'https://i0.wp.com/www.ecoideaz.com/wp-content/uploads/2015/10/Paper_bowl.jpg?fit=900%2C764&ssl=1',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  SizedBox(height: 14.0),
                  Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 16.0,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Giấy Carton: loại giấy cứng, nhiều lớp, chế biến đơn giản nên có giá thành thấp, dùng nhiều trong đóng gói sản phẩm, thời gian phân hủy khoảng 2 tuần.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 16.0,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Giấy báo: loại giấy kraft nâu, mềm, mỏng, độ bền thấp.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 16.0,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Giấy văn phòng và giấy học sinh: được sử dụng nhiều trong văn phòng và trường học, dùng cho các hoạt động viết, vẽ, in ấn, photo…',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              // Plastic
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      'https://vesinhnha.com.vn/wp-content/uploads/2019/03/cach-tai-che-chai-nhua.png',
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Plastic",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Bền, nhẹ, được sản xuất và sử dụng nhiều trong cuộc sống hằng ngày, giá thành rẻ, thời gian phân hủy lâu (từ vài chục đến vài trăm năm), một số loại nhựa sử dụng lâu sẽ không tốt cho sức khỏe.",
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  SizedBox(height: 14.0),
                  Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 16.0,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Nhựa PET: là loại nhựa dùng 1 lần, có độ bền cao, trong suốt, thường được dùng làm các vỏ chai đựng nước, ly nhựa, nắp nhựa,... không nên tái sử dụng nhiều lần, thời gian phân hủy ~200 năm.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 34.0),
              // Aluminium Can
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Aluminium",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Được sử dụng nhiều, phế liệu thu mua số lượng lớn, tuy nhiên khó định giá do nhiều yếu tố.",
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Image.network(
                      'https://media.tietkiemnangluong.com.vn/Images/Upload//User/haiyen/2015/4/9/vo_lon.jpg',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  SizedBox(height: 14.0),
                  Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 16.0,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Nhôm dẻo: loại nhôm được sử dụng làm lon đựng nước, bền, nhẹ, sản xuất và tiêu dùng số lượng lớn, thời gian phân hủy 100~500 năm, khả năng tái chế tốt.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 34.0),
                  // Glass
                  Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://i.khoahoc.tv/photos/image/2019/03/29/chai-thuy-tinh-650.jpg',
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Glass",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Có giá trị sử dụng cao, ứng dụng trong nhiều lĩnh vực, nguy hiểm khi vứt bỏ không đúng quy định, khả năng tái chế và tái sử dụng tốt, thời gian phân hủy lớn hoặc không phân hủy.",
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Divider(),
                  SizedBox(height: 15.0),
                ],
              ),
              Text(
                'Awards',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[400],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
