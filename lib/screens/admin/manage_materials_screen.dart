import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/course.dart';
import '../../models/module.dart';
import '../../models/material.dart';

class ManageMaterialsScreen extends StatefulWidget {
  final Course course;
  final Module module;

  const ManageMaterialsScreen({
    super.key,
    required this.course,
    required this.module,
  });

  @override
  State<ManageMaterialsScreen> createState() => _ManageMaterialsScreenState();
}

class _ManageMaterialsScreenState extends State<ManageMaterialsScreen> {
  final _databaseService = DatabaseService();
  List<Material> _materials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  void _loadMaterials() async {
    try {
      final materials =
          await _databaseService.getMaterialsByModule(widget.module.id);
      setState(() {
        _materials = materials;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load materials: $e')),
        );
      }
    }
  }

  void _showAddMaterialDialog() {
    final urlController = TextEditingController();
    MaterialType selectedType = MaterialType.link;
    final authService = Provider.of<AuthService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Material'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<MaterialType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Material Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: MaterialType.pdf,
                    child: Text('PDF Document'),
                  ),
                  DropdownMenuItem(
                    value: MaterialType.note,
                    child: Text('Note'),
                  ),
                  DropdownMenuItem(
                    value: MaterialType.link,
                    child: Text('Link'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL or Content',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/file.pdf',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (urlController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter URL or content'),
                    ),
                  );
                  return;
                }

                try {
                  await _databaseService.createMaterial(
                    departmentId: widget.course.departmentId,
                    courseId: widget.course.id,
                    moduleId: widget.module.id,
                    type: selectedType,
                    url: urlController.text.trim(),
                    uploadedBy: authService.currentUser?.uid ?? '',
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Material added successfully'),
                      ),
                    );
                    _loadMaterials();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add material: $e')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course: ${widget.course.name}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Module: ${widget.module.title}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _materials.isEmpty
                    ? const Center(
                        child: Text(
                          'No materials yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
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
                              title: Text(
                                _getMaterialTitle(material),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                _getMaterialTypeLabel(material.type),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMaterialDialog,
        child: const Icon(Icons.add),
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
    final uri = Uri.tryParse(material.url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return material.url.length > 50
        ? '${material.url.substring(0, 50)}...'
        : material.url;
  }
}
