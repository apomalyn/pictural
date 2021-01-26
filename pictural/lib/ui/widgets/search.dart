import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pictural/ui/utils/app_theme.dart';

typedef SearchFunction = Future Function(String);

class SearchBar<T> extends StatefulWidget {
  final SearchFunction searchFunction;

  final Function listItemBuilder;

  const SearchBar(
      {Key key, @required this.searchFunction, @required this.listItemBuilder})
      : super(key: key);

  _SearchBarState createState() => _SearchBarState<T>();
}

class _SearchBarState<T> extends State<SearchBar> {
  final TextEditingController _controller = new TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer _timer;

  /// Last query done.
  String _lastQuery = "";

  /// Indicate if the [widget.searchFunction] is currently running
  bool _isLoading = false;

  /// Result of the search.
  List<T> _searchResult;

  @override
  void initState() {
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: AppTheme.instance.useMobileLayout
            ? 500
            : AppTheme.instance.size.width * 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Search a friend",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))
                        : SizedBox(),
                  )),
            ),
            if (_searchResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: _searchResult.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResult.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) =>
                            widget.listItemBuilder(_, _searchResult[index]))
                    : Center(
                        child: Text("Sorry we didn't found anything"),
                      ),
              )
          ],
        ),
      );

  void _onChanged() {
    if (_timer?.isActive ?? false) _timer.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () async {
      if (_controller.text.isNotEmpty) {
        if (_controller.text != _lastQuery) {
          _lastQuery = _controller.text;
          setState(() {
            _isLoading = true;
          });
          var searchResult = await widget.searchFunction(_lastQuery);
          setState(() {
            _isLoading = false;
            _searchResult = searchResult;
          });
        }
      } else if (_lastQuery.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _searchResult = null;
        });
      }
    });
  }
}
