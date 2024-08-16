import 'package:flutter/material.dart';
import 'package:project_app1/widgets/bottomnav.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn All About Trafficking',
          style: TextStyle(
            color: Colors.lightGreen.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Container(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'What is Human Trafficking?',
              'Human trafficking is a serious crime and a violation of human rights. It involves the use of force, fraud, or coercion to obtain some type of labor or commercial sex act.',
            ),
            _buildSection('Types of Human Trafficking', [
              'Sex Trafficking',
              'Labor Trafficking',
              'Child Trafficking',
            ]),
            _buildSection('Warning Signs', [
              'Poor physical health',
              'Lack of control over personal schedule',
              'Inconsistent or rehearsed story',
              'Signs of physical abuse',
            ]),
            _buildSection(
              'How to Help',
              '1. Learn to recognize the signs\n'
                  '2. Report suspicious activity\n'
                  '3. Support organizations fighting trafficking\n'
                  '4. Raise awareness in your community',
            ),
            _buildStoriesSection(),
            _buildVideosSection(),
            _buildResourcesSection(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        defaultSelectedIndex: 2,
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreen.shade800,
          ),
        ),
        SizedBox(height: 16),
        content is List
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    content.map((item) => _buildBulletPoint(item)).toList(),
              )
            : Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen.shade800,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Survivor Stories',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreen.shade800,
          ),
        ),
        SizedBox(height: 16),
        _buildStoryCard(
          'Hannah\'s Story',
          'Things Survivors Wish You Knew: Hannah\'s Story...',
          'https://dressember.org/blog/hannahs-story',
        ),
        _buildStoryCard(
          'A story of Survival and Hope',
          'The following story was shared with Native Hope via email by J. Dakotah...',
          'https://blog.nativehope.org/story-of-survival-and-hope-sex-trafficking-survivor',
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStoryCard(String title, String preview, String url) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.lightGreen.shade800)),
        subtitle: Text(preview, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Icon(Icons.arrow_forward, color: Colors.lightGreen.shade800),
        onTap: () => _launchURL(url),
      ),
    );
  }

  Widget _buildVideosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Educational Videos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreen.shade800,
          ),
        ),
        SizedBox(height: 16),
        _buildVideoCard(
          'Understanding Human Trafficking',
          'A comprehensive overview of human trafficking...',
          'https://youtu.be/X05nsp2gDAs?si=IEoqEUC5C8R7Ovkp',
        ),
        _buildVideoCard(
          'Recognizing the Signs',
          'Learn how to identify potential trafficking situations...',
          'https://youtu.be/u-5XFBFq11o?si=4HbpqfJcr8-gmZyY',
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildVideoCard(String title, String description, String url) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(title,
                style: TextStyle(color: Colors.lightGreen.shade800)),
            subtitle:
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          ButtonBar(
            children: [
              TextButton(
                child: Text(
                  'Watch Video',
                  style: TextStyle(color: Colors.lightGreen.shade800),
                ),
                onPressed: () => _launchURL(url),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Resources',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreen.shade800,
          ),
        ),
        SizedBox(height: 16),
        _buildResourceLink(
          'National Human Trafficking Hotline',
          'https://humantraffickinghotline.org/',
        ),
        _buildResourceLink(
          'UNICEF - Child Trafficking',
          'https://www.unicef.org/protection/trafficking',
        ),
        _buildResourceLink(
          'ILO - Forced Labour',
          'https://www.ilo.org/global/topics/forced-labour/lang--en/index.htm',
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResourceLink(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: () => _launchURL(url),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open the link')),
      );
    }
  }
}
