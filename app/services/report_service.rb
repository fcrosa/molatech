# app/services/report_service.rb
class ReportService
  def self.generate_yearly_report
    report = []

    # Agrupar por año basado en `disbursed_on`
    years = Disbursement.pluck(:disbursed_on).map(&:year).uniq

    years.each do |year|
      disbursements = Disbursement.where("EXTRACT(YEAR FROM disbursed_on) = ?", year)

      # Métricas
      total_disbursements = disbursements.count
      total_disbursed = disbursements.sum(:amount).round(2)
      total_fees = disbursements.sum(:commission).round(2)

      # Cuotas mensuales (simulación)
      merchants = Merchant.where("EXTRACT(YEAR FROM live_on) <= ?", year)
      months_with_fees = merchants.count * 12 # Suponiendo cuotas para todos los meses
      monthly_fee_amount = merchants.sum(:minimum_monthly_fee).round(2) * months_with_fees

      report << {
        year: year,
        number_of_disbursements: total_disbursements,
        amount_disbursed_to_merchants: total_disbursed,
        amount_of_order_fees: total_fees,
        number_of_monthly_fees_charged: months_with_fees,
        amount_of_monthly_fees_charged: monthly_fee_amount
      }
    end

    report
  end
end
