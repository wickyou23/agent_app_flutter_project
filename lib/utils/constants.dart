const appName = 'Verik Router';
const regexPassword = r'^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}$';
const regexEmail = r'[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}';
const List<String> regexPhoneNumer = [
  r'^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$',
  r'^\s*(?:\+?(\d{1,3}))?[- (]*(\d{3})[- )]*(\d{3})[- ]*(\d{4})(?: *[x/#]{1}(\d+))?\s*$'
];
const regexE164PhoneNumber = r'^\+[1-9]\d{1,14}$';
const regexIpv4 =
    r'\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b';
const regexMAC = r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$';
const regex952Hostname =
    r'^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$';
const regexIPAddress =
    r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$';
const regexOpenVPNServerUsernameOrPassword = r'^(?=.{8,64}$)[a-zA-Z0-9_\-.@]+$';

const tagGetXStateViewModel = 'TAG_GETX_STATE_VIEW_MODEL';
const maxWidthForTableDevice = 450.0;
