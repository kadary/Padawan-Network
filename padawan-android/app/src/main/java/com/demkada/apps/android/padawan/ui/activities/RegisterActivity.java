package com.demkada.apps.android.padawan.ui.activities;

/**
 * Created by kadary on 02/12/2014.
 * Register Activity
 */


import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.demkada.apps.android.padawan.R;
import com.demkada.apps.android.padawan.utils.json.JSONParser;

import org.json.JSONException;
import org.json.JSONObject;


public class RegisterActivity extends Activity {

    /**
     * Keep track of the login task to ensure we can cancel it if requested.
     */
    private UserRegisterTask mAuthTask = null;

    // UI references.
    private EditText mFirstNameView;
    private EditText mLastNameView;
    private EditText mPasswordConfirmationView;
    private View mProgressView;
    private View mRegisterFormView;

    //Custom JSON PArser
    JSONParser jsonParser = new JSONParser();

    //Login URL
    private static final String SIGNUP_URL = "http://padawan-esiea.herokuapp.com/users";

    //JSON element ids from repsonse of api:
    private static final String TAG_SUCCESS = "success";
    private static final String TAG_MESSAGE = "message";

    Bundle extras = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_resgister);

        extras = getIntent().getExtras();



        // Set up the register form.
        mFirstNameView = (EditText) findViewById(R.id.firstName);
        mLastNameView = (EditText) findViewById(R.id.lastName);
        mPasswordConfirmationView = (EditText) findViewById(R.id.passwordConfirmation);
        mPasswordConfirmationView
                .setOnEditorActionListener(new TextView.OnEditorActionListener() {
                    @Override
                    public boolean onEditorAction(TextView textView, int id,
                                                  KeyEvent keyEvent) {
                        if (id == R.id.regsister || id == EditorInfo.IME_NULL) {
                            attemptRegister();
                            return true;
                        }
                        return false;
                    }
                });

        Button mEmailSignUpButton = (Button) findViewById(R.id.user_sign_up_button);
        mEmailSignUpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                attemptRegister();
            }
        });

        mRegisterFormView = findViewById(R.id.register_form);
        mProgressView = findViewById(R.id.register_progress);
    }

    /**
     * Attempts to sign in or register the account specified by the login form.
     * If there are form errors (invalid email, missing fields, etc.), the
     * errors are presented and no actual login attempt is made.
     */
    public void attemptRegister() {
        if (mAuthTask != null) {
            return;
        }

        // Reset errors.
        mPasswordConfirmationView.setError(null);

        // Store values at the time of the register attempt.
        String firstName = mFirstNameView.getText().toString();
        String lastName = mLastNameView.getText().toString();
        String email = extras.getString("email");
        String password = extras.getString("password");
        String passwordConfirmation = mPasswordConfirmationView.getText().toString();

        boolean cancel = false;
        View focusView = null;

        // Check for a valid password, if the user entered one.
        if (!TextUtils.isEmpty(passwordConfirmation) && !isPasswordValid(passwordConfirmation)) {
            mPasswordConfirmationView.setError(getString(R.string.error_incorrect_password_signup));
            focusView = mPasswordConfirmationView;
            cancel = true;
        }

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            focusView.requestFocus();
        } else {
            // Show a progress spinner, and kick off a background task to
            // perform the user login attempt.
            showProgress(true);
            mAuthTask = new UserRegisterTask(firstName, lastName, email, password, passwordConfirmation);
            mAuthTask.execute((Void) null);
        }
    }


    private boolean isPasswordValid(String passwordToConfirm) {
        String password = extras.getString("password");
        return passwordToConfirm.equals(password);
    }

    /**
     * Shows the progress UI and hides the login form.
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    public void showProgress(final boolean show) {
        // On Honeycomb MR2 we have the ViewPropertyAnimator APIs, which allow
        // for very easy animations. If available, use these APIs to fade-in
        // the progress spinner.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
            int shortAnimTime = getResources().getInteger(
                    android.R.integer.config_shortAnimTime);

            mRegisterFormView.setVisibility(show ? View.GONE : View.VISIBLE);
            mRegisterFormView.animate().setDuration(shortAnimTime)
                    .alpha(show ? 0 : 1)
                    .setListener(new AnimatorListenerAdapter() {
                        @Override
                        public void onAnimationEnd(Animator animation) {
                            mRegisterFormView.setVisibility(show ? View.GONE
                                    : View.VISIBLE);
                        }
                    });

            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mProgressView.animate().setDuration(shortAnimTime)
                    .alpha(show ? 1 : 0)
                    .setListener(new AnimatorListenerAdapter() {
                        @Override
                        public void onAnimationEnd(Animator animation) {
                            mProgressView.setVisibility(show ? View.VISIBLE
                                    : View.GONE);
                        }
                    });
        } else {
            // The ViewPropertyAnimator APIs are not available, so simply show
            // and hide the relevant UI components.
            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mRegisterFormView.setVisibility(show ? View.GONE : View.VISIBLE);
        }
    }


    /**
     * Represents an asynchronous login/registration task used to authenticate
     * the user.
     */
    public class UserRegisterTask extends AsyncTask<Void, Void, Boolean> {

        private final String mFirstName;
        private final String mLastName;
        private final String mEmail;
        private final String mPassword;
        private final String mPasswordConfirmation;

        UserRegisterTask(String firstName, String lastName, String email, String password, String passwordConfirmation) {
            mFirstName = firstName;
            mLastName = lastName;
            mEmail = email;
            mPassword = password;
            mPasswordConfirmation = passwordConfirmation;
        }

        @Override
        protected Boolean doInBackground(Void... params) {
            int success;
            JSONObject user = new JSONObject();
            JSONObject userInfo = new JSONObject();
            //List loginParams = new ArrayList();

            JSONObject json;
            if (jsonParser.isDataAvailable(getApplicationContext())) {

                try {
                    // Building Parameters

                    //loginParams.add(new BasicNameValuePair("password", mPassword));
                    userInfo.put("first_name", mFirstName);
                    userInfo.put("last_name", mLastName);
                    userInfo.put("email", mEmail);
                    userInfo.put("password", mPassword);
                    userInfo.put("password_confirmation", mPasswordConfirmation);
                    user.put("user", userInfo);
                    //loginParams.add(new BasicNameValuePair("user", user.toString()));

                    //Log.i("UserInfo", user.toString());


                    Log.d("request!", "starting");
                    // getting product details by making HTTP request
                    json = jsonParser.makeHttpRequest(SIGNUP_URL, "POST", user.toString());

                    // check the log for json response
                    //Log.d("Sign UP attempt", json.toString());

                    // json success tag
                    success = json.getInt(TAG_SUCCESS);
                    if (success == 1) {
                        Log.d("Register Successful!", json.toString());
                        Intent intent = new Intent(RegisterActivity.this, MainActivity.class);
                        finish();
                        startActivity(intent);
                        return true;
                    } else {
                        Log.d("Sign up Failure!", json.getString(TAG_MESSAGE));
                        return false;
                    }
                } catch (JSONException e) {
                    return false;
                }
            }

            else
                return false;
        }

        @Override
        protected void onPostExecute(final Boolean success) {
            mAuthTask = null;
            showProgress(false);

            if (success) {
                finish();
            } else {
                mPasswordConfirmationView
                        .setError(getString(R.string.error_on_signup));
                mPasswordConfirmationView.requestFocus();
            }
        }

        @Override
        protected void onCancelled() {
            mAuthTask = null;
            showProgress(false);
        }
    }
}
