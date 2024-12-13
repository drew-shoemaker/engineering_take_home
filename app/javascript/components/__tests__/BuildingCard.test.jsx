import React from 'react';
import { render, fireEvent, screen } from '@testing-library/react';
import BuildingCard from '../BuildingCard';

describe('BuildingCard', () => {
  const mockBuilding = {
    id: '1',
    client_name: 'Test Client',
    address: '123 Test St',
    rock_wall_size: '15'
  };

  const mockOnEdit = jest.fn();

  beforeEach(() => {
    mockOnEdit.mockClear();
  });

  it('renders building information correctly', () => {
    render(<BuildingCard building={mockBuilding} onEdit={mockOnEdit} />);
    
    expect(screen.getByText('123 Test St')).toBeInTheDocument();
    expect(screen.getByText('Client: Test Client')).toBeInTheDocument();
    expect(screen.getByText('rock_wall_size:')).toBeInTheDocument();
    expect(screen.getByText('15')).toBeInTheDocument();
  });

  it('calls onEdit when edit button is clicked', () => {
    render(<BuildingCard building={mockBuilding} onEdit={mockOnEdit} />);
    
    fireEvent.click(screen.getByText('Edit Building'));
    expect(mockOnEdit).toHaveBeenCalledTimes(1);
  });
}); 