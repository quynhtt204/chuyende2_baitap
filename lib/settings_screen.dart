import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundOn = false;
  bool autoSave = false;
  double volume = 0.5;
  int highScore = 3500;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  // LOAD dữ liệu
  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundOn = prefs.getBool('soundOn') ?? false;
      autoSave = prefs.getBool('autoSave') ?? false;
      volume = prefs.getDouble('volume') ?? 0.5;
    });
  }

  // SAVE dữ liệu
  void saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundOn', soundOn);
    await prefs.setBool('autoSave', autoSave);
    await prefs.setDouble('volume', volume);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đã lưu cấu hình thành công!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Cài Đặt", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Trải nghiệm âm thanh"),
                  _buildSettingsCard([
                    SwitchListTile(
                      secondary: Icon(soundOn ? Icons.volume_up : Icons.volume_off, color: Colors.indigo),
                      title: Text("Hiệu ứng âm thanh"),
                      subtitle: Text("Bật/tắt âm thanh trong trò chơi"),
                      value: soundOn,
                      onChanged: (value) => setState(() => soundOn = value),
                      activeColor: Colors.indigo,
                    ),
                    Divider(height: 1, indent: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.graphic_eq, color: Colors.indigo, size: 24),
                              SizedBox(width: 16),
                              Text("Âm lượng", style: TextStyle(fontSize: 16)),
                              Spacer(),
                              Text("${(volume * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                            ],
                          ),
                          Slider(
                            value: volume,
                            onChanged: (value) => setState(() => volume = value),
                            activeColor: Colors.indigo,
                            inactiveColor: Colors.indigo.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(height: 24),
                  _buildSectionTitle("Hệ thống & Lưu trữ"),
                  _buildSettingsCard([
                    SwitchListTile(
                      secondary: Icon(Icons.cloud_upload, color: Colors.indigo),
                      title: Text("Tự động lưu"),
                      subtitle: Text("Lưu tiến trình game tự động"),
                      value: autoSave,
                      onChanged: (value) => setState(() => autoSave = value),
                      activeColor: Colors.indigo,
                    ),
                  ]),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: saveSettings,
                      icon: Icon(Icons.save_rounded),
                      label: Text("LƯU CẤU HÌNH", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            child: Icon(Icons.emoji_events, size: 45, color: Colors.amber),
          ),
          SizedBox(height: 12),
          Text(
            "ĐIỂM CAO NHẤT",
            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
          ),
          Text(
            "$highScore",
            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(children: children),
    );
  }
}