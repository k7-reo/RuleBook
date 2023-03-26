class MeetingsController < ApplicationController

  def show
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
  end

  def new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
    @meeting = Meeting.new
  end

  def create
    @community = Community.find(params[:community_id])
    meeting = Meeting.new(meeting_params)
    meeting.community_id = @community.id
    meeting.user_id = current_user.id
    meeting.status = 0
    meeting.save
    redirect_to community_meetings_path(@community.id)
  end

  def pre_edit
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
    @meeting = Meeting.find(params[:meeting_id])
  end

  def edit
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
    @meeting = Meeting.find(params[:id])
  end

  def update
    @community = Community.find(params[:community_id])
    meeting = Meeting.find(params[:id])
    if meeting.users.present?
      oldUserIds = meeting.users.pluck(:id)#もともと登録されているユーザーの#idを配列で取得
    end
    newUserIds = params[:meeting][:user_ids] #新しく登録されるユーザー
    if params[:change]
      meeting.update(meeting_params)
      redirect_to community_meetings_path(@community.id)
    elsif params[:save] #一時保存だったら
      meeting.status = 1
      if oldUserIds.present?
        oldUserIds.each do |userId|
          user = MeetingUser.find_by(meeting_id: meeting.id, user_id: userId.to_i)
          user.destroy
        end
      end
      if newUserIds.present?
        newUserIds.each do |user_id| #user_idsで配列されているuser一人一人をruleに関連づける。(MeetingUser中間テーブルに保存。)
          user = User.find(user_id.to_i)
          meeting.users << user #関連付ける。
        end
      end
      meetingUsers = MeetingUser.where(meeting_id: meeting.id) #中間テーブルの各community_idの保存。
      meetingUsers.each do |user|
        user.community_id = params[:community_id]
        user.save
      end
      meeting.update(meeting_params)
      redirect_to community_meetings_path(@community.id)
    elsif params[:done] #MTG終了だったら
      meeting.status = 2
      if oldUserIds.present?
        oldUserIds.each do |userId|
          user = MeetingUser.find_by(meeting_id: meeting.id, user_id: userId.to_i)
          user.destroy
        end
      end
      if newUserIds.present?
        newUserIds.each do |user_id| #user_idsで配列されているuser一人一人をruleに関連づける。(MeetingUser中間テーブルに保存。)
          user = User.find(user_id.to_i)
          meeting.users << user #関連付ける。
        end
      end
      meetingUsers = MeetingUser.where(meeting_id: meeting.id) #中間テーブルの各community_idの保存。
      meetingUsers.each do |user|
        user.community_id = params[:community_id]
        user.save
      end
      if meeting.update(meeting_params)
        redirect_to community_meetings_path(@community.id)
        if meeting.next_name.present? || meeting.next_agenda.present? || meeting.next_date.present?
          nextMeeting = Meeting.new
          nextMeeting.community_id = @community.id
          nextMeeting.user_id = current_user.id
          nextMeeting.name = meeting.next_name
          nextMeeting.date = meeting.next_date
          nextMeeting.agenda = meeting.next_agenda
          nextMeeting.place = meeting.next_place
          nextMeeting.save
        end
      end
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    meeting = Meeting.find(params[:id])
    meeting.destroy
    redirect_to community_meetings_path(@community.id)
  end

  def index
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
    @nextMeeting = Meeting.find_by(community_id:  params[:community_id], status: 0) #実施前のMTG
    if @nextMeeting.present?
      if @nextMeeting.date.present? #次のミーティングまでのカウントダウン実装javascriptに使う数値を定義。
        gon.year = @nextMeeting.date.year
        gon.month = @nextMeeting.date.month
        gon.day = @nextMeeting.date.day
      end
    end
    @meetingsInProgress = Meeting.where(community_id: params[:community_id], status: 1) #実施中のMTG
    @pastMeetings = Meeting.where(community_id: params[:community_id], status: 2).order(updated_at: :desc)
  end

  private

  def meeting_params
    params.require(:meeting).permit(:name, :next_name, :community_id, :user_id, :content, :todo, :agenda, :next_agenda, :date, :next_date, :status, :place, :next_place)
  end

end
