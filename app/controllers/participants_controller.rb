# frozen_string_literal: true

class ParticipantsController < ApplicationController

	skip_before_action :require_login, only: %i[show_users]

	def index
		params.deep_transform_keys!(&:underscore)
		@participants = Participant.joins([{ event_detail: [:event, :event_type] }, :user])
		@participants = @participants.where(event: { brand_id: params[:brand_id] }) if params[:brand_id].present?
		@participants = @participants.where(event_detail: { event_id: params[:event_id] }) if params[:event_id].present?
		@participants = @participants.where(event_detail: { event_type_id: params[:event_type_id] }) if params[:event_type_id].present?
		@participants = @participants.where(user_id: params[:user_id]) if params[:user_id].present?
		@participants = @participants.where(event: { date: params[:date_start]..}) if params[:date_start].present?
		@participants = @participants.where(event: { date: ..params[:date_end]}) if params[:date_end].present?
		@participants.order(Arel.sql('events.date DESC'), Arel.sql('users.last_name ASC'), Arel.sql('participants.participation_day DESC'), Arel.sql('event_types.display_order ASC'))
		render :show
	end

	def create
		@participant = Participant.new(participant_params)
		@current_user = User.find(current_user_id)
		@participant.created_by = @current_user
		@participant.updated_by = @current_user
		unless @participant.save
			puts @participant.errors.full_messages
			render json: { message: 'An unexpected error has occurred.' }, status: :internal_server_error
		end
	end

	def update
		@participant = Participant.find(params[:id])
		@current_user = User.find(current_user_id)
		@participant.updated_by = @current_user
		unless @participant.update(participant_params.merge(updated_by: @current_user))
			puts @participant.errors.full_messages
			render json: { message: 'An unexpected error has occurred.' }, status: :internal_server_error
		end
	end

	def destroy
		@participant = Participant.find(params[:id])
		unless @participant.destroy
			puts @participant.errors.full_messages
			render json: { message: 'An unexpected error has occurred.' }, status: :internal_server_error
		end
	end

	def legionnaire_count
		@count = Participant.joins(event_detail: :event_type).where(user_id: params[:id], event_type: { legionnaire_eligible: true }).distinct.count
		render plain: @count
	end

	private

	def participant_params
		params.deep_transform_keys!(&:underscore).require(:participant).permit(:id, :user_id, { event_detail_attributes: %i[event_id event_type_id] }, :participation_day, :additional_laps)
	end

end
