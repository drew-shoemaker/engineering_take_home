import React from 'react';
import styles from './BuildingCard.module.css';

const BuildingCard = ({ building, onEdit }) => {
  const { id, client, address, city, state, zip, custom_field_values } = building;
  
  // Create a map of existing values
  const valueMap = {};
  custom_field_values?.forEach(fieldValue => {
    valueMap[fieldValue.custom_field.id] = fieldValue.value;
  });

  return (
    <div className={styles.card}>
      <h3 className={styles.title}>{address}</h3>
      <p className={styles.address}>
        {city}, {state} {zip}
      </p>
      <p className={styles.clientName}>Client: {client?.name}</p>
      
      <div className={styles.customFields}>
        {client?.custom_fields?.map(field => (
          <div key={field.id} className={styles.field}>
            <span className={styles.fieldName}>{field.name}:</span>
            <span className={styles.fieldValue}>
              {valueMap[field.id] || 'N/A'}
            </span>
          </div>
        ))}
      </div>

      <button onClick={() => onEdit(building)} className={styles.editButton}>
        Edit Building
      </button>
    </div>
  );
};

export default BuildingCard; 