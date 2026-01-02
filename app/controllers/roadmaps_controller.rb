class RoadmapsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # 道しるべ（年ごとの目標）
    @roadmap_items = parse_roadmap(@user.roadmap_text)

    # 年間スケジュール（1〜12月） ※結果は扱わない（予定・目標のみ）
    @yearly_schedule = parse_yearly_schedule(@user.annual_schedule_text)

    # 道しるべの年セレクト用（2030年とかのところ）
    @roadmap_year_options = (Date.current.year..Date.current.year + 10).to_a

    # 年間スケジュールの「2026年」セレクト用
    @schedule_year = params[:year].present? ? params[:year].to_i : Date.current.year
    @schedule_year_options = (Date.current.year..Date.current.year + 10).to_a
  end

  def update
    @user = current_user

    # 道しるべの更新
    if params[:roadmap].present?
      @user.roadmap_text = build_roadmap(params[:roadmap])
    end

    # 年間スケジュールの更新（予定・目標のみ）
    if params[:schedule].present?
      @user.annual_schedule_text = build_yearly_schedule(params[:schedule])
    end

    if @user.save
      redirect_to roadmap_path, notice: "道しるべを更新しました。"
    else
      @roadmap_items        = parse_roadmap(@user.roadmap_text)
      @yearly_schedule      = parse_yearly_schedule(@user.annual_schedule_text)
      @roadmap_year_options = (Date.current.year..Date.current.year + 10).to_a
      flash.now[:alert]     = "保存に失敗しました。"
      render :show, status: :unprocessable_entity
    end
  end

  private

  # ==== 道しるべ（年ごとの目標） ===============================

  # "2030年 目標" のようなテキストを
  # { year: 2030, title: "目標" } の配列に変換
  def parse_roadmap(text)
    lines = text.to_s.split("\n").reject(&:blank?)

    items = lines.map do |line|
      if line.strip =~ /\A(\d{4})年[[:space:]]*(.+)\z/
        { year: Regexp.last_match(1).to_i, title: Regexp.last_match(2).strip }
      else
        { year: Date.current.year, title: line.strip }
      end
    end

    # 何もなければ、先の年を埋める形で 5 行分用意
    (0...5).map do |i|
      items[i] || { year: Date.current.year + i, title: "" }
    end
  end

  def build_roadmap(roadmap_param)
    roadmap_hash =
      if roadmap_param.respond_to?(:to_unsafe_h)
        roadmap_param.to_unsafe_h
      else
        roadmap_param
      end

    roadmap_hash
      .sort_by { |idx, _| idx.to_i } # "0","1","2" の順に
      .map { |_, row| row }
      .map do |row|
        year  = (row[:year]  || row["year"]).to_s.strip
        title = (row[:title] || row["title"]).to_s.strip
        next if year.blank? && title.blank?

        "#{year}年 #{title}"
      end
      .compact
      .join("\n")
  end

  # ==== 年間スケジュール（1〜12月 × 予定・目標） =================

  # 保存形式（2列）:
  # "1月,予定,目標"
  #
  # 旧形式（3列）:
  # "1月,予定,目標,結果"
  #
  # どっちが来ても読み込みできるようにする（結果は無視）
  def parse_yearly_schedule(text)
    months = {}
    (1..12).each do |m|
      months[m] = { plan: "", target: "" }
    end

    text.to_s.split("\n").each do |line|
      parts = line.split(",", 4).map(&:strip) # 最大4つまで取って、結果があっても無視できる
      next if parts[0].blank?

      if parts[0] =~ /\A(\d{1,2})月\z/
        month = Regexp.last_match(1).to_i
        next unless (1..12).cover?(month)

        months[month] = {
          plan:   parts[1] || "",
          target: parts[2] || ""
        }
      end
    end

    months
  end

  # フォームの params[:schedule] を
  # "1月,予定,目標\n2月,..." 形式の文字列に変換（結果なし）
  def build_yearly_schedule(schedule_param)
    (1..12).map do |month|
      row    = schedule_param[month.to_s] || {}
      plan   = (row[:plan]   || row["plan"]).to_s.strip
      target = (row[:target] || row["target"]).to_s.strip

      # 何も入ってない月は保存しない
      next if plan.blank? && target.blank?

      "#{month}月,#{plan},#{target}"
    end.compact.join("\n")
  end
end