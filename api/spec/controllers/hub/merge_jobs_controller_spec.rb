require 'spec_helper'

RSpec.describe Hub::MergeJobsController do
  describe '/latest' do
    let(:request_object) do
      {
        request_id: 1,
        parameters: {
          last_imported_id: selected_but_incomplete_merge_job.id,
          import_size: 100,
          last_imported_timestamp: last_imported_timestamp
        },
        format: :json
      }
    end

    let(:last_imported_timestamp) do
      selected_but_incomplete_merge_job.updated_at.strftime('%H:%M:%S:%L %d/%m/%Y')
    end

    let!(:completed_merge_job) do
      create(
        :merge_job,
        from_sku_id: 1,
        from_internal_sku: '1234-4',
        from_sku_size: 'l',
        to_sku_id: 2,
        to_internal_sku: '1234-5',
        to_sku_size: 'L',
        barcode: '1234567890123',
        completed_at: Time.current
      )
    end

    let!(:selected_but_incomplete_merge_job) do
      create(
        :merge_job,
        from_sku_id: 3,
        from_internal_sku: '4321-6',
        from_sku_size: 's',
        to_sku_id: 4,
        to_internal_sku: '4321-7',
        to_sku_size: 'S',
        barcode: '87654321'
      )
    end

    let!(:pending_merge_job) do
      create(
        :merge_job,
        from_sku_id: 6,
        from_internal_sku: '9876-1',
        from_sku_size: 'm',
        to_sku_id: 7,
        to_internal_sku: '9876-2',
        to_sku_size: 'M',
        barcode: '192837465',
        updated_at: selected_but_incomplete_merge_job.updated_at
      )
    end

    context 'valid payload' do
      before { post :latest, request_object }

      it 'selects the correct merge jobs' do
        expect(MergeJob.count).to eq 3
        jobs = JSON.load(response.body)['merge_jobs']
        expect(jobs.length).to eq 1
        job = jobs.first
        expect(job.length).to eq 4
        expect(job['from_internal_sku']).to eq '9876-1'
        expect(job['to_internal_sku']).to eq '9876-2'
        expect(job['barcode']).to eq '192837465'
      end

      it 'renders an object with a request id' do
        expect(JSON.load(response.body)['request_id']).to eq 1
      end

      it 'contains a summary' do
        expect(JSON.load(response.body)['summary']).to eq 'Returned 1 merge_jobs.'
      end
    end

    context 'invalid payload' do
      it 'wont work without a request_id' do
        expect { post :completed, request_object.except(:request_id) }
          .to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe '/completed' do
    let(:request_object) do
      {
        merge_job: {
          id: 1,
          completed_at: timestamp,
          from_internal_sku: 2,
          to_internal_sku: 3,
          barcode: 4
        },
        parameters: {},
        request_id: 2,
        format: :json
      }
    end

    let!(:timestamp) { Time.current.strftime('%H:%M:%S:%L %d/%m/%Y') }

    before { create(:merge_job) }

    context 'valid payload' do
      it 'marks the given merge_job as complete with the timestamp given' do
        expect(MergeJob.first.completed_at).to eq nil
        expect { post :completed, request_object }
          .to change { MergeJob.first.completed_at }.from(nil).to(timestamp)
      end

      it 'renders an object with a request id' do
        post :completed, request_object
        expect(JSON.load(response.body)['request_id']).to eq 2
      end

      it 'contains a summary' do
        post :completed, request_object
        expect(JSON.load(response.body)['summary']).to eq 'merge_job 1 has been marked as complete'
      end
    end

    context 'invalid payload' do
      it 'wont work without a request_id' do
        expect { post :completed, request_object.except(:request_id) }
          .to raise_error ActionController::ParameterMissing
      end
    end
  end
end
