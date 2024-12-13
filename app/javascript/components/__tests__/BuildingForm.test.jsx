import React from 'react';
import { render, fireEvent, screen, waitFor } from '@testing-library/react';
import BuildingForm from '../BuildingForm';

describe('BuildingForm', () => {
  const mockOnComplete = jest.fn();
  
  beforeEach(() => {
    global.fetch = jest.fn();
    mockOnComplete.mockClear();
  });

  it('loads and displays client options', async () => {
    global.fetch.mockResolvedValueOnce({
      json: () => Promise.resolve({
        status: 'success',
        clients: [
          { id: 1, name: 'Client 1' },
          { id: 2, name: 'Client 2' }
        ]
      })
    });

    render(<BuildingForm onComplete={mockOnComplete} />);
    
    await waitFor(() => {
      expect(screen.getByText('Client 1')).toBeInTheDocument();
      expect(screen.getByText('Client 2')).toBeInTheDocument();
    });
  });

  // Add more test cases for form validation, submission, etc.
}); 