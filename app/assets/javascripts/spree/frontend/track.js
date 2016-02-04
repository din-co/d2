function track(args) {
  trackKissmetrics(args);
  trackIntercom(args);
  // trackGoogle(args);
  // trackFacebook(args);
}


// Kissmetrics
function trackKissmetrics(args) {
  _kmq.push(['record', args.name, args.metadata]);
}

// Intercom
function trackIntercom(args) {
  Intercom('trackEvent', args.name, args.metadata);
}

// Google Analytics
// function trackGA(args) {
// }

// Facebook
// function trackFacebook(args) {
// }
