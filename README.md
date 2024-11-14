# Azle React Template

This template sets up a full-stack application with:
- **Azle Backend**: A simple Hello World canister.
- **React Frontend**: A React app that interacts with the Azle backend.

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/azle-react-template.git
   cd azle-react-template
   ```
2. Run the setup script:
```bash
./setup.sh
```
3. Go to the backend directory and start the canister:
```bash
cd backend
dfx start --clean
dfx deploy #on another terminal
```
4. Go to the frontend directory and start the React app:
```bash
cd frontend
npm run dev
```
