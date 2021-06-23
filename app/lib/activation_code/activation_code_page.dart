import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone/activation_code/src/bloc/enter_activation_code_bloc_factory.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone_widgets/theme.dart';
import 'src/widgets/enter_activation_code_text_field.dart';

Future<dynamic> openEnterActivationCodePage(BuildContext context) {
  final blocFactory = BlocProvider.of<EnterActivationCodeBlocFactory>(context);
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        bloc: blocFactory.createBloc(),
        child: _EnterActivationCodePage(),
      ),
      settings: RouteSettings(name: _EnterActivationCodePage.tag),
    ),
  );
}

class _EnterActivationCodePage extends StatelessWidget {
  const _EnterActivationCodePage({Key key}) : super(key: key);

  static const tag = "enter-activation-code-page";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColorBrightness: Brightness.dark),
      child: Scaffold(
        appBar: const _EnterActivationCodeAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _EnterActivationCodeDescription(),
          ),
        ),
        bottomNavigationBar: ContactSupport(),
      ),
    );
  }
}

class _EnterActivationCodeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _EnterActivationCodeAppBar({Key key, this.withBackIcon = true})
      : super(key: key);
  final bool withBackIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Aktivierungscode eingeben",
        style: TextStyle(color: Colors.white),
      ),
      automaticallyImplyLeading: withBackIcon,
      centerTitle: true,
      backgroundColor:
          isDarkThemeEnabled(context) ? null : Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      actions: const [],
      bottom: const EnterActivationCodeTextField(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(190);
}

class _EnterActivationCodeDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
