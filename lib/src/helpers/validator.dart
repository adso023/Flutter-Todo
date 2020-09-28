bool checkMinLength(String password) => password.length >= 8;

bool checkNumberInclusion(String password) =>
    RegExp(r'[0-9]').hasMatch(password);

bool checkSymbolInclusion(String password) =>
    RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

bool checkMixCase(String password) => RegExp(r'[a-zA-Z]').hasMatch(password);

bool checkBoth(String one, String two) => one == two;
