import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/data/weather_repository.dart';

class CitySearchButton extends StatefulWidget {
  final Function(String) onCitySelected;
  const CitySearchButton({super.key, required this.onCitySelected});

  @override
  State<CitySearchButton> createState() => _CitySearchButtonState();
}

class _CitySearchButtonState extends State<CitySearchButton> {
  final TextEditingController _controller = TextEditingController();
  final WeatherRepository _repo = WeatherRepository();
  List<String> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;

  void _searchCities(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() => _suggestions = []);
        return;
      }

      setState(() => _isLoading = true);
      try {
        final results = await _repo.searchCities(query);
        setState(() => _suggestions = results);
      } catch (e) {
        setState(() => _suggestions = []);
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.transparent,
              child: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xff2E335A), Color(0xff1C1B33)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Şehir Ara",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _controller,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Şehir adı giriniz",
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color.fromARGB(50, 255, 255, 255)
                                : Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (query) async {
                            if (query.isEmpty) {
                              setStateDialog(() => _suggestions = []);
                              return;
                            }

                            setStateDialog(() => _isLoading = true);
                            try {
                              final results = await _repo.searchCities(query);
                              setStateDialog(() => _suggestions = results);
                            } catch (e) {
                              setStateDialog(() => _suggestions = []);
                            } finally {
                              setStateDialog(() => _isLoading = false);
                            }
                          },
                        ),
                        if (_isLoading)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        if (_suggestions.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 200,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey[900]?.withOpacity(0.9)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListView.builder(
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                final city = _suggestions[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  title: Text(
                                    city,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.location_city,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                  hoverColor: isDark
                                      ? Colors.blueGrey[700]
                                      : Colors.grey[400],
                                  onTap: () {
                                    widget.onCitySelected(city);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
