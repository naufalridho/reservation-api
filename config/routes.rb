Rails.application.routes.draw do
  scope path: 'reservations', controller: 'reservations' do
    put '/import' => 'reservations#import'
  end
end
