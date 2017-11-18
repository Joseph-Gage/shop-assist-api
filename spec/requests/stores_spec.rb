require 'rails_helper'

RSpec.describe 'Stores API', type: :request do
  let!(:stores) { create_list(:store, 5) }
  let(:store_id) { stores.first.id }

  describe 'GET /stores' do
    before { get '/stores' }

    it 'returns stores' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /stores/:id' do
    before { get "/stores/#{store_id}" }

    context 'when record exists' do
      it 'returns store' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(store_id)
      end

      it 'returns 200 OK' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      let(:store_id) { 6 }

      it 'returns 404 NOT FOUND' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Store/)
      end
    end
  end

  describe 'POST /stores' do
    let(:valid_attributes) { { name: 'Game Stop', address: 'next door' } }

    context 'when request valid' do
      before { post '/stores', params: valid_attributes }

      it 'creates store' do
        expect(json['name']).to eq('Game Stop')
        expect(json['address']).to eq('next door')
      end

      it 'returns 201 CREATED' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request invalid' do
      before { post '/stores', params: { name: 'NotEnough' } }

      it 'returns 422 UNPROCESSABLE ENTITY' do
        expect(response).to have_http_status(422)
      end

      it 'returns validation failure message' do
        expect(response.body).to match(/Validation failed: Address can't be blank/)
      end
    end
  end

  describe 'PUT /stores/:id' do
    let(:valid_attributes) { { name: 'Changed Game Stop' } }

    context 'when record exists' do
      before { put "/stores/#{store_id}", params: valid_attributes }

      it 'updates record' do
        expect(response.body).to be_empty
      end

      it 'returns 204 NO CONTENT' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /stores/:id' do
    before { delete "/stores/#{store_id}" }

    it 'returns 204 NO CONTENT' do
      expect(response).to have_http_status(204)
    end
  end
end