import React from 'react';
import { render, fireEvent, screen } from '@testing-library/react';
import BuildingList from '../BuildingList';

describe('BuildingList', () => {
  const generateMockBuildings = (count) => {
    return Array.from({ length: count }, (_, index) => ({
      id: String(index + 1),
      address: `${index + 1}23 Test St`,
      client_name: `Client ${index + 1}`
    }));
  };

  const mockOnEdit = jest.fn();
  const mockOnPageChange = jest.fn();

  beforeEach(() => {
    mockOnEdit.mockClear();
    mockOnPageChange.mockClear();
  });

  it('renders all buildings as cards', () => {
    const mockBuildings = generateMockBuildings(2);
    render(
      <BuildingList
        buildings={mockBuildings}
        onEdit={mockOnEdit}
        currentPage={1}
        onPageChange={mockOnPageChange}
      />
    );

    expect(screen.getByText('123 Test St')).toBeInTheDocument();
    expect(screen.getByText('223 Test St')).toBeInTheDocument();
  });

  it('handles pagination correctly when there are enough buildings', () => {
    const mockBuildings = generateMockBuildings(12); // More than 10 buildings
    render(
      <BuildingList
        buildings={mockBuildings}
        onEdit={mockOnEdit}
        currentPage={1}
        onPageChange={mockOnPageChange}
      />
    );

    fireEvent.click(screen.getByText('Next'));
    expect(mockOnPageChange).toHaveBeenCalledWith(2);
  });

  it('disables pagination buttons appropriately', () => {
    const mockBuildings = generateMockBuildings(5); // Less than 10 buildings
    render(
      <BuildingList
        buildings={mockBuildings}
        onEdit={mockOnEdit}
        currentPage={1}
        onPageChange={mockOnPageChange}
      />
    );

    const previousButton = screen.getByText('Previous');
    const nextButton = screen.getByText('Next');

    expect(previousButton).toBeDisabled();
    expect(nextButton).toBeDisabled();

    // Verify that clicking disabled buttons doesn't trigger onPageChange
    fireEvent.click(previousButton);
    fireEvent.click(nextButton);
    expect(mockOnPageChange).not.toHaveBeenCalled();
  });
}); 