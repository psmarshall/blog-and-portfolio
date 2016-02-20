---
layout:   post
title:    "Image Storage with Firebase"
date:     2016-02-19 17:02:25
comments: true
---
Firebase acts as a super low-friction way to add a backend to your mobile or web-app, so I put it to the test to see if I could use it to store images for a new project.

First we need to configure our Android Activity to hit our Firebase backend. Turns out this is two lines. Nice!

{% highlight java %}
public class DemoActivity extends AppCompatActivity {

    private Firebase firebase;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Firebase.setAndroidContext(this);
        firebase = new Firebase("https://*firebase-url*.firebaseio.com/");
        ...
    }
}
{% endhighlight %}

There is a lot of other stuff that goes on in my demo now which opens the camera, gets the user to take a photo and saves it to file on the device. Once all that is done, we should upload the file to Firebase. I'm sure there must be a better way to get it into base64 but here goes:

{% highlight java %}
private void storeImageToFirebase() {
    BitmapFactory.Options options = new BitmapFactory.Options();
    options.inSampleSize = 8; // shrink it down otherwise we will use stupid amounts of memory
    Bitmap bitmap = BitmapFactory.decodeFile(mCurrentPhotoUri.getPath(), options);
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);
    byte[] bytes = baos.toByteArray();
    String base64Image = Base64.encodeToString(bytes, Base64.DEFAULT);

    // we finally have our base64 string version of the image, save it.
    firebase.child("pic").setValue(base64Image);
    System.out.println("Stored image with length: " + bytes.length);
}
{% endhighlight %}

So we've stored out picture to our backend using three lines to do it. Pretty neat. What about if we want to pull it out again and display it back to the user when they open the app?

{% highlight java %}
private void previewStoredFirebaseImage() {
    firebase.child("pic").addValueEventListener(new ValueEventListener() {
        @Override
        public void onDataChange(DataSnapshot snapshot) {
            String base64Image = (String) snapshot.getValue();
            byte[] imageAsBytes = Base64.decode(base64Image.getBytes(), Base64.DEFAULT);
            mThumbnailPreview.setImageBitmap(
                    BitmapFactory.decodeByteArray(imageAsBytes, 0, imageAsBytes.length)
            );
            System.out.println("Downloaded image with length: " + imageAsBytes.length);
        }

        @Override
        public void onCancelled(FirebaseError error) {}
    });
}
{% endhighlight %}

We set up an event listener that will get fired straight away with the result from the backend, as well as whenever the data changes on the server. We pull the data down and create a bitmap from it, and update our ImageView to display it, pretty awesome. We needed to use a few more lines here, but I chalk that up mostly to Java's boilerplateyness for registering callbacks.

My impressions are that Firebase can do some pretty cool stuff pretty damn quickly. Next time I need to quickly prototype something like at a hackathon, I'll definitely give Firebase a go. I don't know how it would fare if your backend needs to do stuff other than act as a simple layer over your database, but for basic CRUD it seems spot-on the money.