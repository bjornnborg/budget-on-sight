class TransactionsController < ApplicationController
  include DateHelper
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]


  def index
    date_ranges = date_range(params)
    @transactions = current_user.transactions
      .since(date_ranges.first)
      .until(date_ranges.last)
      .oldest_first
      .all
    @credits_count = @transactions.count{|t| t.category.credit?}
    @credits_total = @transactions.select{|t| t.category.credit?}.inject(0) {|sum, t| sum + t.amount}

    @debits_count = @transactions.count{|t| t.category.debit?}
    @debits_total = @transactions.select{|t| t.category.debit?}.inject(0) {|sum, t| sum + t.amount}

    @current_balance = @transactions.balance
  end

  def show
  end

  def new
    @transaction = Transaction.new
    @transaction.date = Time.now
    @categories = current_user.categories.debits_first
  end

  def edit
    @categories = current_user.categories.debits_first
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user
    creating_missing = "true" == params["missing_transactions_flag"]

    respond_to do |format|
      if @transaction.save
        format.html {
          if creating_missing
            redirect_to missing_transactions_path, notice: 'Transaction was successfully created.' 
          else
            redirect_to @transaction, notice: 'Transaction was successfully created.' 
          end
        }
        format.json { render :show, status: :created, location: @transaction }
      else
        @categories = current_user.categories.debits_first
        format.html { 
          if creating_missing
            redirect_to missing_transactions_path, flash: {error: @transaction.errors.full_messages}
          else
            render :new
          end
        }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @transaction.user = current_user
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        @categories = current_user.categories.debits_first
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def missing
    date_ranges = date_range(params)
    @missing_transactions = TransactionService.compute_missing_transactions_for_date(current_user, date_ranges.first.to_datetime.to_date..date_ranges.last.to_datetime.to_date)
    @transaction = Transaction.new
    @transaction.date = Time.now
    @categories = current_user.categories.debits_first
  end

  def report
    @existing_params = params.to_unsafe_h.slice("year", "month")

    date_ranges = date_range(params)
    @transactions = current_user.transactions
      .since(date_ranges.first)
      .until(date_ranges.last)
      .oldest_first
      .all

    @report = {}
    @report[:debit] = Hash[@transactions.select{|t| t.debit?}.group_by{|t| t.category.group}.sort_by{|k,v| v.sum(&:amount)}]
    @report[:credit] = Hash[@transactions.select{|t| t.credit?}.group_by{|t| t.category.group}.sort_by{|k, v| v.sum(&:amount)}.reverse]

    @debits_total = @report[:debit].values.flat_map{|a| a}.sum{|t| t.amount}
    @credits_total = @report[:credit].values.flat_map{|a| a}.sum{|t| t.amount}

    @current_balance = @transactions.balance

    @investments_total = @transactions.select{|t| t.category.investment?}.sum{|t| t.amount}
  end

  def report_detail
    @existing_params = params.to_unsafe_h.slice("year", "month")

    date_ranges = date_range(params)
    @transactions = current_user.transactions
      .since(date_ranges.first)
      .until(date_ranges.last)
      .from_group(params[:group_name])

    @current_balance = @transactions.balance
    @transactions_count = @transactions.size
  end

  def dismiss
    TransactionService.dismiss(dismiss_params[:missing_hash], current_user)
    redirect_to missing_transactions_path, notice: 'Suggestion was successfully dismissed.' 
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:date, :amount, :category_id, :payee)
    end

    def dismiss_params
      params.require(:dismiss_hash).permit(:missing_hash)
    end    

end
