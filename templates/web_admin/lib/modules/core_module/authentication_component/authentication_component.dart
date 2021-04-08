import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:core_module/core_module.dart';

@Component(
  selector: 'authentication-component',
  templateUrl: 'authentication_component.html',
  styleUrls: ['authentication_component.css'],
  directives: [
    formDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialInputComponent,
  ],
)
class AuthenticationComponent {
  final bloc = CoreAuthenticationBloc();

  void authenticate() => bloc.add(CoreAuthenticationEvent.authenticate);

}
