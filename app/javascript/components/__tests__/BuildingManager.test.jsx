import React from 'react';
import { render, screen, waitFor, fireEvent } from '@testing-library/react';
import BuildingManager from '../BuildingManager';

describe('BuildingManager', () => {
  const mockBuildings = [
    { id: '1', address: '123 Test St', client_name: 'Client 1' },
    { id: '2', address: '456 Test Ave', client_name: 'Client 2' }
  ];

  beforeEach(() => {
    global.fetch = jest.fn((url) => {
      if (url.includes('/api/buildings')) {
        return Promise.resolve({
          json: () => Promise.resolve({ status: 'success', buildings: mockBuildings })
        });
      } else if (url.includes('/api/clients')) {
        return Promise.resolve({
          json: () => Promise.resolve({ status: 'success', clients: [
            { id: '1', name: 'Client 1' },
            { id: '2', name: 'Client 2' }
          ]})
        });
      }
    });
  });

  it('fetches and displays buildings on mount', async () => {
    render(<BuildingManager />);
    
    expect(screen.getByText('Loading buildings...')).toBeInTheDocument();
    
    await waitFor(() => {
      expect(screen.getByText(mockBuildings[0].address)).toBeInTheDocument();
    });
  });

  it('handles fetch errors correctly', async () => {
    global.fetch.mockRejectedValueOnce(new Error('Network error'));

    render(<BuildingManager />);

    await waitFor(() => {
      expect(screen.getByText('Error connecting to server')).toBeInTheDocument();
    });
  });

  it('handles edit mode correctly', async () => {
    render(<BuildingManager />);

    await waitFor(() => {
      expect(screen.getByText(mockBuildings[0].address)).toBeInTheDocument();
    });

    const editButtons = await screen.findAllByRole('button', { name: /edit/i });
    fireEvent.click(editButtons[0]);

    await waitFor(() => {
      expect(screen.getByRole('heading', { name: /edit building/i })).toBeInTheDocument();
    });
  });
}); 