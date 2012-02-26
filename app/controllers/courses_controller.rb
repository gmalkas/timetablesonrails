# encoding: utf-8
class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all

		laurence = {:name => "L. Rozé"}
		marin = {:name => "M. Bertier"}
		yvan = {:name => "Y. Leplumey"}
		daniele = {:name => "D. Quichaud"}
		maud = {:name => "M. Marchal"}
    yann = {:name => "Y. Ricquebourg"}
		abdelly = {:name => "A. Leguesdron"}
    eric = {:name => "E. Anquetil"}
		edouard = {:name => "E. Monnier"}

		sem5 = {
			:id => '5',
			:courses => [
				{:name => 'Assembleur', :postulants => [laurence]},
				{:name => 'Logique séquentielle', :postulants => [marin, yvan]},
				{:name => 'Langages et grammaires', :postulants => [daniele]},
				{:name => 'Modélisation', :postulants => [maud]},
				{:name => 'Structures de données', :postulants => [yann]},
				{:name => 'Modèles stochastiques', :postulants => []}
		  ]
    }

		sem6 = { 
			:id => '6',
			:courses => [
				{:name => 'Base de données', :postulants => []},
				{:name => 'Ruby on Rails', :postulants => [marin, daniele, yann, yvan]},
				{:name => 'Architecture des systèmes', :postulants => [daniele]},
				{:name => 'Modélisation', :postulants => []},
				{:name => 'Structure de données', :postulants => [yann]},
				{:name => 'Gestion du risque II', :postulants => [yvan, marin]}
			]
    }

		sem7 = { :id => '7', :courses => [] }
		sem8 = {
      :id => '8',
			:courses => [
        {:name => 'Programmation en logique', :postulants => [edouard]},
				{:name => 'Prog. Orientée objets', :postulants => [eric, abdelly]},
				{:name => 'Systèmes', :postulants => [eric, marin]}
			]
		}

		@semesters = [sem5, sem6, sem7, sem8]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end
end
