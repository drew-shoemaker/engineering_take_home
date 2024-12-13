import React, { useState, useEffect } from 'react';
import BuildingList from './BuildingList';
import BuildingForm from './BuildingForm';
import styles from './BuildingManager.module.css';

const BuildingManager = () => {
  const [buildings, setBuildings] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  const [selectedBuilding, setSelectedBuilding] = useState(null);

  const fetchBuildings = async (page = 1) => {
    try {
      setIsLoading(true);
      setError(null);
      const response = await fetch(`/api/buildings?page=${page}`);
      const data = await response.json();
      if (data.status === 'success') {
        setBuildings(data.buildings);
      } else {
        setError('Failed to fetch buildings');
      }
    } catch (err) {
      setError('Error connecting to server');
      setBuildings([]);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchBuildings(currentPage);
  }, [currentPage]);

  const handlePageChange = (newPage) => {
    setCurrentPage(newPage);
  };

  const handleEditBuilding = (building) => {
    setSelectedBuilding(building);
    setIsEditing(true);
  };

  return (
    <div className={styles.container}>
      <h1 className={styles.title}>Welcome to Perchwell Building Managment</h1>
      {error && (
        <div className={styles.errorMessage} role="alert">
          {error}
        </div>
      )}
      
      {!error && !isLoading && (
        <BuildingForm 
          isEditing={isEditing}
          building={selectedBuilding}
          onComplete={() => {
            setIsEditing(false);
            setSelectedBuilding(null);
            fetchBuildings(currentPage);
          }}
        />
      )}

      {isLoading ? (
        <div className={styles.loadingContainer}>
          <div className={styles.loadingSpinner}></div>
          <p className={styles.loadingText}>Loading buildings...</p>
        </div>
      ) : !error && (
        <BuildingList 
          buildings={buildings}
          onEdit={handleEditBuilding}
          currentPage={currentPage}
          onPageChange={handlePageChange}
        />
      )}
    </div>
  );
};

export default BuildingManager; 