# Azle React Template

This template sets up a full-stack application with:

- **Azle Backend**: A simple Hello World canister.
- **React Frontend**: A React app that interacts with the Azle backend.

## How to Use

1.Clone the repository:

```bash
   git clone https://github.com/divin3circle/azle-starter.git
   cd azle-starter
```

2.Run the setup script:

```bash
./setup.sh
```

3.Go to the backend directory in your project and start the canister:

```bash
cd name-of-your-project-dir/backend
dfx start --clean --background
dfx deploy
```

4.Edit your canister id in App.jsx

```js
const canisterId = Principal.fromText("your-canister-id"); // Replace with actual canister ID
//use the canister id you given after running dfx deploy on the backend dir
```

5.Go to the frontend directory and start the React app:

```bash
cd frontend
npm run dev
```
