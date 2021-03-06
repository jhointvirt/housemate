require 'rails_helper'

RSpec.describe "Api::V1::RentedAccommodations", type: :request do
  it "returns status 200 when get all (index) without filter" do
    @rented_accommodation_first = generate_rented_accommodation
    @rented_accommodation_second = generate_rented_accommodation
    @all = RentedAccommodation.all

    get '/api/v1/rented_accommodation'
    expect(response.status).to eq(200)
    expect(response.body).to eq(@all.to_json)
  end

  it "returns status 200 when get all (index) with filters" do
    30.times do
      generate_rented_accommodation
    end
    @all = RentedAccommodation.all
    @cost_more = @all.where("cost >= ?", 700)
    @cost_less = @all.where("cost <= ?", 700)

    get '/api/v1/rented_accommodation?cost_more=700'
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body).length).to eq(@cost_more.length)

    get '/api/v1/rented_accommodation?cost_less=700'
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body).length).to eq(@cost_less.length)
  end

  it "returns status 200 when get by id (show)" do
    @rented_accommodation = generate_rented_accommodation

    get '/api/v1/rented_accommodation/' + @rented_accommodation[:id].to_s
    expect(response.status).to eq(200)
    expect(response.body).to eq(@rented_accommodation.to_json)
  end

  it "returns status 200 when create" do
    @user = create_user_with_profile
    @headers = { "Authorization": "Bearer " + get_access_token(@user) }

    post '/api/v1/rented_accommodation/', :headers => @headers, :params => { rented_accommodation: {
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 80.0,
      latitude: 80.0,
      link: 'example.com',
      photos: [Rack::Test::UploadedFile.new('spec/images/test.jpg'), Rack::Test::UploadedFile.new('spec/images/test.jpg')]
    }}
    
    length = RentedAccommodation.find(JSON.parse(response.body)['id']).photos_attachments.length
    expect(length).to eq(2)
    expect(response.status).to eq(200)
  end

  it "returns status 200 when update" do
    @user = create_user_with_profile
    @headers = { "Authorization": "Bearer " + get_access_token(@user) }
    @rented_accommodation = generate_rented_accommodation

    put '/api/v1/rented_accommodation/' + @rented_accommodation[:id].to_s, :headers => @headers , :params => { rented_accommodation: {
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 80.0,
      latitude: 80.0,
      link: 'example.com'
    }}

    expect(response.status).to eq(200)
  end

  it "returns status 400 with error messages when create" do
    @user = create_user_with_profile
    @headers = { "Authorization": "Bearer " + get_access_token(@user) }
    
    post '/api/v1/rented_accommodation/', :headers => @headers, :params => { rented_accommodation: {
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 181.0,
      latitude: 91.0,
      link: 'example.com'
    }}

    expect(response.status).to eq(400)
    @body = JSON.parse(response.body)
    expect(@body['latitude']).to eq(['must be less than 90.0'])
    expect(@body['longitude']).to eq(['must be less than 180.0'])
  end

  it "returns status 400 when update" do
    @user = create_user_with_profile
    @headers = { "Authorization": "Bearer " + get_access_token(@user) }
    @rented_accommodation = generate_rented_accommodation

    put '/api/v1/rented_accommodation/' + @rented_accommodation[:id].to_s, :headers => @headers , :params => { rented_accommodation: {
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 181.0,
      latitude: 91.0,
      link: 'example.com'
    }}

    expect(response.status).to eq(400)
  end

  it "returns status 401 unautorized when create" do
    post '/api/v1/rented_accommodation/', :params => { rented_accommodation: {
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 80.0,
      latitude: 80.0,
      link: 'example.com'
    }}

    expect(response.status).to eq(401)
    @body = JSON.parse(response.body)
    expect(@body['exception']).to eq("Unauthorized")
  end

  it "returns status 401 unautorized when update" do
    @rented_accommodation = generate_rented_accommodation

    put '/api/v1/rented_accommodation/' + @rented_accommodation[:id].to_s , :params => { rented_accommodation: {
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 80.0,
      latitude: 80.0,
      link: 'example.com'
    }}

    expect(response.status).to eq(401)
    @body = JSON.parse(response.body)
    expect(@body['exception']).to eq("Unauthorized")
  end

  it "returns status 200 when new" do
    @user = create_user_with_profile
    @headers = { "Authorization": "Bearer " + get_access_token(@user) }

    post '/api/v1/rented_accommodation/new', :headers => @headers, :params => { longitude: 28.432478900156728, latitude: 49.230942410934205 }
    expect(response.status).to eq(200)
    @body = JSON.parse(response.body)
    expect(@body['address']).to eq('26, Liali Ratushnoi Street, Slovyanka, Vinnytsia, Vinnytsia Urban Hromada, Vinnytsia Raion, Vinnytsia Oblast, 21036, Ukraine')
    expect(@body['city']).to eq('Vinnytsia')
    expect(@body['country_code']).to eq('ua')
    expect(@body['country']).to eq('Ukraine')
    expect(@body['longitude']).to eq('28.43220800399061')
    expect(@body['latitude']).to eq('49.2310982')
  end
end
