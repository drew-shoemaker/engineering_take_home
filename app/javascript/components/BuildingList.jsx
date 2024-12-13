import React from 'react';
import BuildingCard from './BuildingCard';
import styles from './BuildingList.module.css';

const BuildingList = ({ buildings, onEdit, currentPage, onPageChange }) => {
  return (
    <div className={styles.container}>
      <div className={styles.grid}>
        {buildings.map(building => (
          <BuildingCard 
            key={building.id}
            building={building}
            onEdit={() => onEdit(building)}
          />
        ))}
      </div>
      
      <div className={styles.pagination}>
        <button 
          className="pagination-button"
          onClick={() => onPageChange(currentPage - 1)}
          disabled={currentPage === 1}
        >
          Previous
        </button>
        <span className={styles.pageNumber}>Page {currentPage}</span>
        <button 
          className="pagination-button"
          onClick={() => onPageChange(currentPage + 1)}
          disabled={buildings.length < 10}
        >
          Next
        </button>
      </div>
    </div>
  );
};

export default BuildingList; 