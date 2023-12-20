# Vending machine management web app for vending route driver

## Features:
- Show item list
- Update amount and price of item
- Add new item to item list
- Remove item from list

## Installation

### Prerequisites

- Python 3.10
- Pip (Python package installer)
- venv (virtual environment)

### Installation

1. At folder containing README file, set up virtual environment

        python -m venv venv

2. Activate virtual environment to avoid conflicts with other existing packages

        venv\Scripts\activate (for windows)

        source venv/bin/activate (for unix/macos)

3. Install dependencies to run web app

        pip install -r requirements.txt

4. Run web app, web app will run locally on port 8501 (http://localhost:8501)

        streamlit run app.py