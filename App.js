import * as React from 'react';
import * as WebBrowser from 'expo-web-browser';
import * as Facebook from 'expo-auth-session/providers/facebook';
import * as AuthSession from 'expo-auth-session';
import {
  ActivityIndicator,
  Button,
  StyleSheet,
  Text,
  View,
} from 'react-native';

WebBrowser.maybeCompleteAuthSession();

const accessTokenURL = 'http://localhost:3000/api/v1/auth/facebook/callback';
const redirect = AuthSession.makeRedirectUri();
console.log(`Callback URL: ${redirect}`);

export default function App() {
  const [username, setUsername] = React.useState();
  const [loading, setLoading] = React.useState(false);
  const [error, setError] = React.useState();
  const loginButtonID = "loginButton";
  const logoutButtonID = "logoutButton";

  const onLogout = React.useCallback(() => {
    setUsername();
    setLoading(false);
    setError();
  }, []);

  const [authRequest, authResponse, promptAsync] = Facebook.useAuthRequest({
    clientId: '1703247659862136',
    responseType: AuthSession.ResponseType.Code
  });

  const onLogin = React.useCallback(async (authRes) => {
    setLoading(true);

    try {
      if (authRes?.params && authRes?.params.denied) {
        return setError('AuthSession failed, user did not authorize the app');
      };

      const accessParams = toQueryString( { code: authRes.params.code } );
      const response = await fetch(accessTokenURL + accessParams);
      const data = await response.json();

      if (data.status) {
        setUsername(data.response_data.name);
        setError();
      } else {
        setError(data.response_data);
      };
    } catch (error) {
      console.log('Something went wrong...', error);
      setError(error.message);
    } finally {
      setLoading(false);
    }
  }, []);

  return (
    <View style={styles.container}>
      {username !== undefined ? (
        <View>
          <Text style={styles.title}>Hi {username}!</Text>
          <Button
            testID="logoutButton"
            title="Logout to try again"
            onPress={onLogout}
          />
        </View>
      ) : (
        <View>
          <Text  id={loginButtonID} style={styles.title}>Facebook login</Text>
          <Button
            testID="loginButton"
            disabled={!authRequest}
            title="Login with Facebook"
            onPress={() => {
              promptAsync().then((authRes) => {
                console.log(authRes);
                onLogin(authRes);
              });
            }}
          />
        </View>
      )}

      {error !== undefined && <Text style={styles.error}>Error: {error}</Text>}

      {loading && (
        <View style={[StyleSheet.absoluteFill, styles.loading]}>
          <ActivityIndicator color="#fff" size="large" animating />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  loading: {
    backgroundColor: 'rgba(0,0,0,0.4)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: 20,
    textAlign: 'center',
    marginTop: 40,
  },
  error: {
    fontSize: 16,
    textAlign: 'center',
    marginTop: 40,
  },
});

function toQueryString(params) {
  return (
    '?' +
    Object.entries(params)
      .map(
        ([key, value]) =>
          `${encodeURIComponent(key)}=${encodeURIComponent(value)}`
      )
      .join('&')
  );
}
