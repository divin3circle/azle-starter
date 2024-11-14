#!/bin/bash

#credits
echo "==================================="
echo "Azle🚀 + React⚛️ Setup Script"
echo "Credits: ⭐️divin3circle⭐️"
echo "==================================="

# project name
echo "📝Enter project name: "
read project_name

# main project directory
mkdir $project_name
cd $project_name
mkdir frontend backend

# backend setup
echo "⚙️Setting up backend..."
cd backend
npx azle new .
npm install
echo "1/3 => ✅Backend setup complete!"
cd ..

#frontend setup
echo "👨‍💻Setting up frontend..."
cd frontend
npm create vite@latest . -- --template react -y
npm install @dfinity/agent @dfinity/principal @types/node process node-libs-browser global
echo "2/3 => ✅Frontend setup complete!"

#update app.tsx & vite.config.js
echo "Updating files Azle backend logic..."
echo 'import { useState, useEffect } from "react";
import { Actor, HttpAgent } from "@dfinity/agent";
import { Principal } from "@dfinity/principal";

const canisterId = Principal.fromText("bkyz2-fmaaa-aaaaa-qaaaq-cai"); // Replace with actual canister ID

const App = () => {
  const [message, setMessageState] = useState("Nothing here yet");
  const [inputMessage, setInputMessage] = useState("");

  // Initialize the HttpAgent and Actor
  const agent = new HttpAgent({ host: "http://127.0.0.1:4943" });

  if (process.env.NODE_ENV === "development") {
    agent.fetchRootKey();
  }

  const actor = Actor.createActor(
    ({ IDL }) => {
      return IDL.Service({
        getMessage: IDL.Func([], [IDL.Text], []),
        setMessage: IDL.Func([IDL.Text], [], []),
      });
    },
    { agent, canisterId }
  );

  const getMessage = async () => {
    try {
      const messageFromCanister = await actor.getMessage();
      setMessageState(messageFromCanister);
    } catch (error) {
      console.error("Error fetching message:", error);
    }
  };

  const setMessage = async () => {
    try {
      await actor.setMessage(inputMessage);
      setInputMessage("");
      getMessage();
    } catch (error) {
      console.error("Error setting message:", error);
    }
  };

  useEffect(() => {
    getMessage();
  }, []);

  return (
    <div>
      <h1>Message: {message}</h1>
      <input
        type="text"
        value={inputMessage}
        onChange={(e) => setInputMessage(e.target.value)}
      />
      <button onClick={setMessage}>Set Message</button>
    </div>
  );
};

export default App; ' > src/App.jsx

echo "import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  define: {
    global: 'globalThis',
  },

  plugins: [react()],
}); " > vite.config.js
echo "3/3 => ✅Files update complete""
echo "⚠️Remeber to input your canister-id in App.tsx!!""
echo "ℹYour canister-id can be gotten after running dfx deploy in the backend directory"
cd ..

# initialize git repository
git init
git add .
git commit -m "Initial commit with Azle backend and React frontend setup"

# additional instructions to the user
echo "==============================="
echo "🚀Setup complete!"
echo "Run 'dfx start' in the backend directory and 'npm run dev' in the frontend directory."
echo "Check readme for more details https://github.com/divin3circle/azle-starter"
echo "==============================="
