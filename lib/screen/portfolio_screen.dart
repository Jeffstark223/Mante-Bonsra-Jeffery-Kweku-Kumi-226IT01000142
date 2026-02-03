import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INFT 425 - [Jeffery Bonsra]'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
             
              if (constraints.maxWidth > 600) {
                
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildLeftColumn(),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _buildRightColumn(),
                    ),
                  ],
                );
              } else {
                
                return Column(
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 20),
                    _buildAboutSection(),
                    const SizedBox(height: 20),
                    _buildSkillsSection(),
                    const SizedBox(height: 20),
                    _buildEducationSection(),
                    const SizedBox(height: 20),
                    _buildProjectsSection(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  
  Widget _buildHeaderSection() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
              'hero-a.jpg'), 
        ),
        const SizedBox(height: 16),
        const Text(
          '[Jeffery Bonsra]',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1), 
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'BSc. Computer Science',
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF616161), 
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            const Text('kumikweku18@gmail.com'),
            const SizedBox(width: 16),
            Icon(Icons.phone, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            const Text('+233 557757831'),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Me',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'I am a passionate Computer Science student at Valley View University with strong interest in mobile application development. Currently in Level 300, I have completed courses in Object-Oriented Programming, Data Structures, and Web Technologies. I enjoy creating responsive and user-friendly applications using Flutter.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    final List<String> skills = [
      'Dart/Flutter',
      'Java',
      'JavaScript',
      'Python',
      'Git/GitHub',
      'Firebase',
      'REST APIs',
      'UI/UX Design'
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Technical Skills',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Colors.blue[50],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Academic History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final courses = [
                  'INFT 205 - Object-Oriented Programming',
                  'INFT 305 - Data Structures & Algorithms',
                  'INFT 315 - Database Systems',
                  'INFT 325 - Web Technologies'
                ];
                return ListTile(
                  leading: const Icon(Icons.book, color: Colors.blue),
                  title: Text(courses[index]),
                );
              },
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.school, color: Colors.green),
              title: Text('Valley View University'),
              subtitle: Text('BSc. Computer Science | Current: Level 300'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Projects & Experience',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildProjectTile(
              'E-Commerce Mobile App',
              'Developed a Flutter-based e-commerce application with Firebase backend, user authentication, and real-time cart functionality.',
              ['Flutter', 'Firebase', 'Provider'],
            ),
            const Divider(),
            _buildProjectTile(
              'Student Portal System',
              'Created a web-based student portal using React.js and Node.js for course registration and grade viewing.',
              ['React.js', 'Node.js', 'MongoDB'],
            ),
            const Divider(),
            _buildProjectTile(
              'Weather Forecast App',
              'Built a mobile app that displays real-time weather data using OpenWeatherMap API with location services.',
              ['Flutter', 'REST API', 'Geolocation'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTile(String title, String description, List<String> tech) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: tech.map((t) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                t,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  
  Widget _buildLeftColumn() {
    return Column(
      children: [
        _buildHeaderSection(),
        const SizedBox(height: 20),
        _buildSkillsSection(),
      ],
    );
  }

 
  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildAboutSection(),
        const SizedBox(height: 20),
        _buildEducationSection(),
        const SizedBox(height: 20),
        _buildProjectsSection(),
      ],
    );
  }
}