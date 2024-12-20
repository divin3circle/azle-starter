#!/bin/bash

#credits
echo "==================================="
echo "Azle🚀 + React⚛️ Setup Script"
echo "Credits: ⭐️divin3circle⭐️"
echo "==================================="

# project name
echo "📝Enter project name: "
read -p "👉" project_name
echo "Setting up $project_name for you..."

echo ""
# main project directory
mkdir $project_name
cd $project_name
mkdir frontend backend declarations
npm install @types/node
echo "{
  \"compilerOptions\": {
    \"typeRoots\": [\"./node_modules/@types\"],
    \"esModuleInterop\": true
  }
}" > tsconfig.json

# backend setup
cd backend
echo ""
echo "👨‍💻 Setting up backend..."
npx azle new .
npm install
echo ""
echo "∞ Starting local internet computer replica..."
dfx start --clean --background
dfx deploy
CANISTER_ID=$(dfx canister id hello_world)
echo "1/3 => ✅Backend setup complete!"
cd ..

echo "📝Setting up declarations files"
cd declaration
echo "📝 Creating declarations file..."
echo "import fs from \"fs\";" > generateActor.js
echo "import path from \"path\";" >> generateActor.js
echo "" >> generateActor.js
echo "// Path to the .did file generated by Azle (replace with actual path)" >> generateActor.js
echo "const didFilePath = path.join(" >> generateActor.js
echo "  __dirname," >> generateActor.js
echo "  \"..\",">> generateActor.js
echo "  \"backend\"," >> generateActor.js
echo "  \".azle\"," >> generateActor.js
echo "  \"hello_world\"," >> generateActor.js
echo "  \"hello_world.did\"" >> generateActor.js
echo "); // Adjust path as necessary" >> generateActor.js
echo "" >> generateActor.js
echo "// Read the .did file" >> generateActor.js
echo "const didFile = fs.readFileSync(didFilePath, \"utf-8\");" >> generateActor.js
echo "" >> generateActor.js
echo "// Parse the .did file into JSON (assuming a format like 'service: () -> {...}')" >> generateActor.js
echo "const serviceDefinition = JSON.parse(\`{\${didFile}}\`).service;" >> generateActor.js
echo "" >> generateActor.js
echo "// Start generating the actor code" >> generateActor.js
echo "let actorCode = \`" >> generateActor.js
echo "import { Actor, HttpAgent } from '@dfinity/agent';" >> generateActor.js
echo "import { Principal } from '@dfinity/principal';" >> generateActor.js
echo "" >> generateActor.js
echo "const agent = new HttpAgent({ host: 'http://127.0.0.1:4943' });" >> generateActor.js
echo "" >> generateActor.js
echo "if (process.env.NODE_ENV === 'development') {" >> generateActor.js
echo "  agent.fetchRootKey();" >> generateActor.js
echo "}" >> generateActor.js
echo "" >> generateActor.js
echo "const actor = Actor.createActor(" >> generateActor.js
echo "  ({ IDL }) => {" >> generateActor.js
echo "    return IDL.Service({" >> generateActor.js
echo "\`;" >> generateActor.js
echo "" >> generateActor.js
echo "// Loop through the service methods and generate their corresponding IDL" >> generateActor.js
echo "Object.keys(serviceDefinition).forEach((methodName) => {" >> generateActor.js
echo "  const method = serviceDefinition[methodName];" >> generateActor.js
echo "" >> generateActor.js
echo "  // If the method is a query" >> generateActor.js
echo "  if (method.includes(\"query\")) {" >> generateActor.js
echo "    const returnType = method.split(\" -> \")[1].split(\" \")[0];" >> generateActor.js
echo "    actorCode += \`" >> generateActor.js
echo "      \${methodName}: IDL.Func([], [IDL.\${returnType}], { query: true })," >> generateActor.js
echo "    \`;" >> generateActor.js
echo "  }" >> generateActor.js
echo "" >> generateActor.js
echo "  // If the method is an update" >> generateActor.js
echo "  else if (method.includes(\"->\")) {" >> generateActor.js
echo "    const args = method.split(\"(\")[1].split(\")\")[0];" >> generateActor.js
echo "    const returnType = method.split(\"->\")[1].trim();" >> generateActor.js
echo "    actorCode += \`" >> generateActor.js
echo "      \${methodName}: IDL.Func([IDL.\${args}], [\${returnType === \"()\" ? \"IDL.Void\" : \"IDL.\" + returnType}], [])," >> generateActor.js
echo "    \`;" >> generateActor.js
echo "  }" >> generateActor.js
echo "});" >> generateActor.js
echo "" >> generateActor.js
echo "actorCode += \`" >> generateActor.js
echo "    });" >> generateActor.js
echo "  }," >> generateActor.js
echo "  { agent, canisterId: Principal.fromText('${CANISTER_ID}') }" >> generateActor.js
echo ");" >> generateActor.js
echo "" >> generateActor.js
echo "export default actor;" >> generateActor.js
echo "\`;" >> generateActor.js
echo "" >> generateActor.js
echo "// Write the generated actor code to a file in the frontend folder" >> generateActor.js
echo "fs.writeFileSync(" >> generateActor.js
echo "  path.join(__dirname, \"frontend\", \"src\", \"actor.js\")," >> generateActor.js
echo "  actorCode" >> generateActor.js
echo ");" >> generateActor.js
echo "" >> generateActor.js
echo "console.log(\"Generated actor.js with backend methods!\");" >> generateActor.js
node ./generateActor.js

#frontend setup
echo ""
echo "👨‍💻 Setting up frontend..."
cd frontend
npm create vite@latest . -- --template react -y
npm install @dfinity/agent @dfinity/principal @types/node process node-libs-browser global
# install taiwlindcss and postcss
npm install -D tailwindcss postcss autoprefixer
# create & modify tailwind.config.js configuration file
npx tailwindcss init -p
echo ""
echo "2/3 => ✅Frontend setup complete!"

#update app.tsx, tailwindcss config file & vite.config.js
echo ""
echo "📝 Updating files Azle backend logic..."
echo 'import { useState, useEffect } from "react";
import { Actor, HttpAgent } from "@dfinity/agent";
import { Principal } from "@dfinity/principal";

const canisterId = Principal.fromText('$CANISTER_ID');

const App = () => {
  const [message, setMessageState] = useState("Nothing here yet");
   const [isLoading, setIsLoading] = useState(false);
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
      setIsLoading(true);
      const messageFromCanister = await actor.getMessage();
      setMessageState(messageFromCanister);
      setIsLoading(false);
    } catch (error) {
      setIsLoading(false);
      console.error("Error fetching message:", error);
    }
  };

  const setMessage = async () => {
    try {
      setIsLoading(true);
      await actor.setMessage(inputMessage);
      setInputMessage("");
      getMessage();
      setIsLoading(false);
    } catch (error) {
      setIsLoading(false);
      console.error("Error setting message:", error);
    }
  };

  useEffect(() => {
    getMessage();
  }, []);

  return (
     <div className="relative flex items-center justify-center h-screen w-full flex-col gap-4 px-4 font-mono">
      {isLoading && (
        <div className="absolute inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex items-center justify-center z-10">
          <div className="text-white">Setting message...</div>
        </div>
      )}
      <div className="flex flex-col items-center justify-center gap-4 mb-12">
        <div className="flex items-center gap-2">
          <img
            src="https://raw.githubusercontent.com/demergent-labs/azle/main/logo/logo.svg"
            alt="Azle Logo"
            className="w-24 h-24"
          />
          <img src={viteLogo} alt="React Logo" className="w-24 h-24" />
        </div>
        <h1 className="text-3xl font-bold my-6">Azle + React Starter</h1>
        <h1 className="text-xl leading-relaxed font-bold w-full text-center">
          Message from the canister
        </h1>
        <h1 className="text-normal leading-relaxed w-full text-center">
          {message}
        </h1>
        <input
          type="text"
          value={inputMessage}
          onChange={(e) => setInputMessage(e.target.value)}
          className="py-2 px-4 border border-gray-300 rounded-md"
        />
        <button
          onClick={setMessage}
          className="py-2 px-8 bg-black text-white rounded-md"
        >
          Set Message
        </button>
      </div>
      <h1 className="text-gray-500">
        Start by editing{" "}
        <span className="bg-gray-100 p-2 rounded-md font-semibold">
          App.jsx
        </span>{" "}
        for frontend.
      </h1>
      <h1 className="text-gray-500">
        And{" "}
        <span className="bg-gray-100 p-2 rounded-md font-semibold">
          index.ts
        </span>{" "}
        for backend(Azle).
      </h1>
      <a
        href="https://github.com/divin3circle/azle-starter"
        className="text-sm mt-8 text-blue-500 underline"
        target="_blank"
      >
        Github(Documentation)
      </a>
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

echo "/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}; " > tailwind.config.js

echo "@tailwind base;
@tailwind components;
@tailwind utilities; " > src/index.css

echo ""
echo "3/3 => ✅Files update complete""
echo ""
echo "⚠️Remeber to input your canister-id in App.tsx!!""
echo "ℹYour canister-id can be gotten after running dfx deploy in the backend directory"
cd ..


# additional instructions to the user
echo "==============================="
echo "🚀Setup complete!"
echo "Run 'dfx start' in the backend directory and 'npm run dev' in the frontend directory."
echo "Check readme for more details https://github.com/divin3circle/azle-starter"
echo "==============================="
