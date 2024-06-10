var notificationSound = new Audio('ford.ogg');
var notificationSound2 = new Audio('pop.ogg');

window.addEventListener('message', function(event) {
  var data = event.data;
  
  if (data.event == "turnOn") {
    // Move image off-screen with opacity fade-in
    var imageContainer = document.querySelector('.image-container');
    imageContainer.style.transform = 'translateY(-200%)';
    imageContainer.style.opacity = 0;
    imageContainer.style.transition = 'transform 1s ease-in-out, opacity 0.5s ease-in-out';
    setTimeout(function() {
      document.getElementById("tcImgCont").style.display = "none";
    }, 500);
  

  } else if (data.event == "turnOff") {
    // Move image on-screen with opacity fade-out
    document.getElementById("tcImgCont").style.display = "block";
    setTimeout(function() {
      var imageContainer = document.querySelector('.image-container');
      imageContainer.style.transform = 'translateY(0)';
      imageContainer.style.opacity = 1;
      imageContainer.style.transition = 'transform 1s ease-in-out, opacity 1.9s ease-in-out';

      setTimeout(function() {
        notificationSound.play();
      }, 500);
    }, 50);
    
    
  } else if (data.event == "launchControlPressGas") {
    var gasimgcont = document.getElementById("gas-imgcont");
	  gasimgcont.style.display = "flex";
	  gasimgcont.style.height = "100px";
	  gasimgcont.style.width = "400px";
	  gasimgcont.style.top = "70%";
	  gasimgcont.style.position = "absolute";
	  gasimgcont.style.transform = "translateX(100%)";
	  gasimgcont.style.opacity = "0";
	  gasimgcont.style.left = "50.5%";
	  notificationSound2.play();

  setTimeout(function() {
    gasimgcont.style.transform = "translateX(0%)";
    gasimgcont.style.opacity = "1";
    gasimgcont.style.transition = "all 1s ease-in-out";
    notificationSound2.play();
  }, 200);
  setTimeout(function() {
    // Hide or remove the notification element
    gasimgcont.style.opacity = "0";
    gasimgcont.style.display = "none"; // or removeChild(burnoutImg) if you want to remove the element from the DOM
  }, 5000); // 5000 milliseconds = 5 seconds
    
} else if (data.event == "launchControlEBrake") {
  var ebrakeImg = document.getElementById("ebrake-img");
  ebrakeImg.style.display = "flex";
  ebrakeImg.style.height = "100px";
  ebrakeImg.style.width = "400px";
  ebrakeImg.style.top = "80%";
  ebrakeImg.style.position = "absolute";
  ebrakeImg.style.transform = "translateX(100%)";
  ebrakeImg.style.opacity = "0";

  setTimeout(function() {
    ebrakeImg.style.transform = "translateX(0%)";
    ebrakeImg.style.opacity = "1";
    ebrakeImg.style.transition = "all 1s ease-in-out";
    notificationSound2.play();
  }, 200);
  setTimeout(function() {
    // Hide or remove the notification element
    ebrakeImg.style.opacity = "0";
    ebrakeImg.style.display = "none"; // or removeChild(burnoutImg) if you want to remove the element from the DOM
  }, 5000); // 5000 milliseconds = 5 seconds

} else if (data.event == "burnout") {
  var burnoutImg = document.getElementById("burnout-img");
  burnoutImg.style.display = "flex";
  burnoutImg.style.height = "100px";
  burnoutImg.style.width = "400px";
  burnoutImg.style.top = "80%";
  burnoutImg.style.position = "absolute";
  burnoutImg.style.transform = "translateX(100%)";
  burnoutImg.style.opacity = "0";

  setTimeout(function() {
    burnoutImg.style.transform = "translateX(0%)";
    burnoutImg.style.opacity = "1";
    burnoutImg.style.transition = "all 1s ease-in-out";
    notificationSound2.play();
  }, 200);
  setTimeout(function() {
    // Hide or remove the notification element
    burnoutImg.style.opacity = "0";
    burnoutImg.style.display = "none"; // or removeChild(burnoutImg) if you want to remove the element from the DOM
  }, 5000); // 5000 milliseconds = 5 seconds

} else if (data.event == "bump") {
  var bumpImg = document.getElementById("bump-img");
  bumpImg.style.display = "flex";
  bumpImg.style.height = "100px";
  bumpImg.style.width = "400px";
  bumpImg.style.top = "80%";
  bumpImg.style.position = "absolute";
  bumpImg.style.transform = "translateX(100%)";
  bumpImg.style.opacity = "0";

  setTimeout(function() {
    bumpImg.style.transform = "translateX(0%)";
    bumpImg.style.opacity = "1";
    bumpImg.style.transition = "all 1s ease-in-out";
    notificationSound2.play();
  }, 200);
  setTimeout(function() {
    // Hide or remove the notification element
    bumpImg.style.opacity = "0";
    bumpImg.style.display = "none"; // or removeChild(burnoutImg) if you want to remove the element from the DOM
  }, 5000); // 5000 milliseconds = 5 seconds
  
} else if (data.event == "launchControlFailed") {
  var gasimgcont = document.getElementById("gas-imgcont");
  var ebrakeImg = document.getElementById("ebrake-img");
  ebrakeImg.style.transform = "translateX(100%)";
  ebrakeImg.style.opacity = "0";
  ebrakeImg.style.transition = "all 1s ease-in-out";
  gasimgcont.style.transform = "translateX(100%)";
  gasimgcont.style.opacity = "0";
  gasimgcont.style.transition = "all 1s ease-in-out";

  setTimeout(function() {
    ebrakeImg.style.display = "none";
	gasimgcont.style.display = "none";
  }, 1000);
}

});



/*function moveUp(image-container) {
  if (image-container) {
    image.style.transition = 'top 1s ease-in-out';
    image.style.top = '-50px';
    image.style.display = 'none';
    tractionControlOn = true;
  }
}*/

