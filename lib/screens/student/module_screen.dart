import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/database_service.dart';
import '../../models/module.dart';
import '../../models/material.dart';
import '../../models/past_question.dart';
import 'practice_screen.dart';

class ModuleScreen extends StatefulWidget {
  final Module module;

  const ModuleScreen({super.key, required this.module});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final _databaseService = DatabaseService();
  List<Material> _materials = [];
  bool _isLoadingMaterials = true;
  int _questionsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
    _loadQuestionsCount();
  }

  void _loadMaterials() async {
    try {
      final materials =
          await _databaseService.getMaterialsByModule(widget.module.id);
      setState(() {
        _materials = materials;
        _isLoadingMaterials = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMaterials = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load materials: $e')),
        );
      }
    }
  }

  void _loadQuestionsCount() async {
    try {
      final pastQuestions =
          await _databaseService.getPastQuestionsByModule(widget.module.id);
      final aiQuestions = await _databaseService
          .getApprovedAIQuestionsByModule(widget.module.id);
      setState(() {
        _questionsCount = pastQuestions.length + aiQuestions.length;
      });
    } catch (e) {
      // Silently fail for question count
    }
  }

  void _openMaterial(Material material) async {
    final uri = Uri.parse(material.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the material')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.module.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.module.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Practice Button
            if (_questionsCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(
                          module: widget.module,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.quiz),
                  label: Text('Practice Questions ($_questionsCount)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Materials Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Learning Materials',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _isLoadingMaterials
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _materials.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'No materials available yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _materials.length,
                        itemBuilder: (context, index) {
                          final material = _materials[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Icon(
                                _getMaterialIcon(material.type),
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(_getMaterialTitle(material)),
                              subtitle: Text(
                                  _getMaterialTypeLabel(material.type)),
                              trailing: const Icon(Icons.open_in_new),
                              onTap: () => _openMaterial(material),
                            ),
                          );
                        },
                      ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _getMaterialIcon(MaterialType type) {
    switch (type) {
      case MaterialType.pdf:
        return Icons.picture_as_pdf;
      case MaterialType.link:
        return Icons.link;
      default:
        return Icons.note;
    }
  }

  String _getMaterialTypeLabel(MaterialType type) {
    switch (type) {
      case MaterialType.pdf:
        return 'PDF Document';
      case MaterialType.link:
        return 'External Link';
      default:
        return 'Note';
    }
  }

  String _getMaterialTitle(Material material) {
    // Extract filename from URL or show URL
    final uri = Uri.tryParse(material.url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return material.url;
  }
}
