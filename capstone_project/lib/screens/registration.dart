import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: new Text('Account'),
                    content: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //USERNAME
                          TextFormField(
                            controller: _usernameController,
                            key: ValueKey('username'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Please provide valid name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Fullname'),
                          ),
                          //TEXT FORM EMAIL
                          TextFormField(
                            controller: _emailController,
                            key: ValueKey('email'),
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Pelase enter a valid email address!';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email address',
                            ),
                          ),
                          // Contact
                          TextFormField(
                            controller: _phoneController,
                            key: ValueKey('phone'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 11) {
                                return 'Please provide valid phone';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Phone number (09XX XXX XXXX)'),
                          ),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            key: ValueKey('password'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 characters long!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          SizedBox(height: 12.0),
                          TextFormField(
                            // controller: _passwordController,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(labelText: 'Repeat password'),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Address'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Home Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Postcode'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Mobile Number'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Mobile Number'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
