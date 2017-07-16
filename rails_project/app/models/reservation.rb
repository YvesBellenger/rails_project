class Reservation < ApplicationRecord
  resourcify

  belongs_to :user
  belongs_to :book

  #L'enregistrement d'une réservation
  def self.setup_reservation(book,reservation,user)
    reservation.user = user
    reservation.book = book
    reservation.date_debut = DateTime.now
    reservation.rendu = false
    reservation.save
  end
end
