# Molatech Disbursements Service

Welcome to the Molatech Disbursements Service! This system is designed to automate the calculation of merchant disbursements and Molatech commissions for new and existing orders. It processes historical data from CSV files and is prepared to handle future incoming orders efficiently.

---

## 🚀 Getting Started

Follow these steps to set up and run the Molatech Disbursements Service on your local machine.

### Prerequisites

Ensure you have the following tools installed:

* **Git**: For cloning the repository.

* **Ruby on Rails**: The latest stable version is recommended.

* **PostgreSQL**: The primary database used by the application.

* **Redis**: Used for background jobs and caching.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone git@github.com:fcrosa/molatech.git
    cd molatech
    ```

2.  **Install Ruby gems:**

    ```bash
    bundle install
    ```

3.  **Set up the database:**

    ```bash
    bin/rails db:create
    bin/rails db:migrate
    ```

4.  **Import initial data:**

    * **Merchants:**
        ```bash
        rails runner script/import_merchants.rb
        ```
    * **Orders:**
        ```bash
        rails runner script/import_orders.rb
        ```

---

## ⚙️ Usage & Operations

This section details how to interact with and manage the Molatech Disbursements Service.
The service is scheduled to run automatically every day at midnight (12:00 AM). This means that at exactly that time each day, the function ScheduleDisbursements.call will be executed.

The configuration for this schedule is defined in the file config/schedule.rb. This file uses a tool to define automated tasks that run at regular intervals.

In summary:

What does the service do? It calculates and schedules disbursements automatically.



### Scheduler Configuration

When does it run? Every day at 12:00 AM.

Where is it configured? in:

```bash
config/schedule.rb
```

If you want to change the frequency or timing, you can modify this file and adjust the schedule to meet your requirements.

### Generating the Annual Report

To generate the comprehensive yearly report for all disbursements, execute the following command:

```bash
rails runner script/generate_yearly_report.rb
```

### Run the worker locally

If you want to test the worker locally, you must enter the Rails console by running
```bash
rails c
```
Initialize the worker
```bash
dworker = DisbursementWorker.new
```
Run
```bash
merchant_reference ="merchant_name"
dworker.perform(merchant_reference)
```

---

## 📝 License

This project is open-sourced under the **MIT License**. See the `LICENSE` file for more details.

Feel free to open an issue on the repository if you encounter any problems or have suggestions for improvements!
