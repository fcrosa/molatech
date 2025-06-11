# Molatech Disbursements Service

Molatech is a system to automate the calculation of merchant disbursements and Molatech commissions for new and existing orders (found in the CSV files included) and prepare it to handle new orders in the future.

## Getting Started

Follow the steps below to set up the application locally:

### Prerequisites

Ensure the following tools are installed on your system:

1. **Git**
2. **Ruby on Rails** (latest version recommended)
3. **PostgreSQL**
4. **Redis**

### Installation Steps

1. Clone the repository:

   ```bash
   git clone git@github.com:fcrosa/molatech.git
   cd molatech
   ```

2. Install the required gems:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. Import initial data into the database:

   * Import merchants:

     ```bash
     rails runner script/import_merchants.rb
     ```

   * Import Orders:

     ```bash
     rails runner script/import_orders.rb
     ```


5.  Setting Up the Scheduler

When you download the project, the scheduler will be configured to run automatically.
You can find the configuration in:

   ```bash
    /config/schedule.rb
   ```

6.  Generating the Annual Report

to generate the yearly report, run:
   ```bash
    rails runner script/generate_yearly_report.rb
   ```


## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

Happy cooking with Recipe Finder App! If you encounter any issues, feel free to open an issue on the repository or contact the maintainers.
