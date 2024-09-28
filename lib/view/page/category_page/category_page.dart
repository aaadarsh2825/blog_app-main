import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';
import 'package:blog_tuto_ap/view/page/home_page/category_response_ob.dart';
import 'package:flutter/material.dart';
import 'package:blog_tuto_ap/view/page/profile_page/profile_page.dart';
import 'package:blog_tuto_ap/view/page/upload_post_page/upload_post_page.dart';
import 'package:blog_tuto_ap/view/widget/post_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'category_bloc.dart';

class CategoryPage extends StatefulWidget {
  final CategoryOb ob;

  CategoryPage(this.ob);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryBloc _bloc = CategoryBloc();
  final RefreshController _refreshController = RefreshController();
  List<BlogOb> _blogList = [];

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
    _bloc.blogStream.listen((ResponseOb resp) {
      if (resp.message == MsgState.data) {
        _handleResponse(resp);
      }
    });
  }

  void _fetchBlogs() {
    _bloc.getBlog(widget.ob.id.toString());
  }

  void _handleResponse(ResponseOb resp) {
    if (resp.pageLoad == PageLoad.first) {
      _refreshController.refreshCompleted();
      _blogList = resp.data; // Initial load
    } else if (resp.pageLoad == PageLoad.nextPage) {
      _refreshController.loadComplete();
      _blogList.addAll(resp.data); // Load more data
    } else if (resp.pageLoad == PageLoad.noMore) {
      _refreshController.loadNoData(); // No more data available
    }
  }

  @override
  void dispose() {
    _bloc.dispose(); // Dispose of the bloc to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: NeumorphicAppBar(
        title: Text(widget.ob.name),
      ),
      body: StreamBuilder<ResponseOb>(
        stream: _bloc.blogStream,
        initialData: ResponseOb(message: MsgState.loading),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          ResponseOb resp = snapshot.data!;
          if (resp.message == MsgState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (resp.message == MsgState.error) {
            return Center(child: Text("Something went wrong"));
          }

          return SmartRefresher(
            enablePullUp: _blogList.length > 4,
            onRefresh: _fetchBlogs,
            onLoading: () => _bloc.getLoadMoreBlog(widget.ob.id.toString()),
            controller: _refreshController,
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _blogList.length,
              itemBuilder: (context, index) {
                return PostWidget(_blogList[index], catName: widget.ob.name);
              },
            ),
          );
        },
      ),
    );
  }
}
