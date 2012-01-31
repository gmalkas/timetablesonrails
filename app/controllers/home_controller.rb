# encoding: utf-8
class HomeController < ApplicationController
  def index
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
  end
end
