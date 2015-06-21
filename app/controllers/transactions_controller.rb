class TransactionsController < ApplicationController
  include DateHelper
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]


  def index
    date_ranges = date_range
    @transactions = current_user.transactions
      .since(date_range.first)
      .until(date_range.last)
      .oldest_first
      .all
    @current_balance = @transactions.inject(0){|acc, t| acc += t.amount}
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

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        @categories = current_user.categories.debits_first
        format.html { render :new }
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

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:date, :amount, :category_id, :payee)
    end

end
