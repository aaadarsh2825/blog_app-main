import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/view/page/category_page/category_page.dart';
import 'package:blog_tuto_ap/view/page/profile_page/profile_page.dart';
import 'package:blog_tuto_ap/view/page/upload_post_page/upload_post_page.dart';
import 'package:blog_tuto_ap/view/widget/category_widget.dart';
import 'package:blog_tuto_ap/view/widget/post_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'blog_response_ob.dart';
import 'category_response_ob.dart';
import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController();
  final HomeBloc _bloc = HomeBloc();
  List<BlogOb> _list = [];

  @override
  void initState() {
    super.initState();
    _bloc.getCategory();
    _bloc.getBlog();
    _initializeBlogStream();
  }

  void _initializeBlogStream() {
    _bloc.blogStream().listen((ResponseOb resp) {
      if (resp.message == MsgState.data) {
        _handleBlogResponse(resp);
      }
    });
  }

  void _handleBlogResponse(ResponseOb resp) {
    switch (resp.pageLoad) {
      case PageLoad.first:
        _refreshController.refreshCompleted();
        break;
      case PageLoad.nextPage:
        _refreshController.loadComplete();
        break;
      case PageLoad.noMore:
        _refreshController.loadNoData();
        break;
    }

    if (resp.pageLoad == PageLoad.first) {
      _list = resp.data;
    } else {
      _list.addAll(resp.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildCategorySection(),
          Expanded(child: _buildBlogSection()),
        ],
      ),
    );
  }

  NeumorphicAppBar _buildAppBar(BuildContext context) {
    return NeumorphicAppBar(
      title: Text("Blog App"),
      leading: NeumorphicButton(
        child: Icon(Icons.person),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage()));
        },
      ),
      actions: [
        NeumorphicButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => UploadPostPage())).then((b) {
              if (b == true) {
                _bloc.getBlog();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Container(
      height: 80,
      child: StreamBuilder<ResponseOb>(
        stream: _bloc.categoryStream(),
        initialData: ResponseOb(message: MsgState.loading),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ResponseOb resp = snapshot.data!;
            if (resp.message == MsgState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (resp.message == MsgState.error) {
              return Center(child: Text("Something went wrong!"));
            } else {
              List<CategoryOb> categories = resp.data;
              return ListView(
                padding: EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                children: categories.map((ob) => CategoryWidget(ob)).toList(),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildBlogSection() {
    return StreamBuilder<ResponseOb>(
      stream: _bloc.blogStream(),
      initialData: ResponseOb(message: MsgState.loading),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ResponseOb resp = snapshot.data!;
          if (resp.message == MsgState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (resp.message == MsgState.error) {
            return Center(child: Text("Something went wrong!"));
          } else {
            return SmartRefresher(
              enablePullUp: _list.length > 4,
              onRefresh: () {
                _bloc.getBlog();
              },
              onLoading: () {
                _bloc.getLoadMoreBlog();
              },
              controller: _refreshController,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: _list.map((ob) => PostWidget(ob)).toList(),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
