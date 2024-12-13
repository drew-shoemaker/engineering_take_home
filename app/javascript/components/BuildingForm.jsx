import React, { useState, useEffect } from 'react';
import styles from './BuildingForm.module.css';
import FlashMessage from './FlashMessage';

const BuildingForm = ({ isEditing, building, onComplete }) => {
  const [clients, setClients] = useState([]);
  const [selectedClient, setSelectedClient] = useState(null);
  const [customFields, setCustomFields] = useState([]);
  const [formData, setFormData] = useState({
    address: '',
    state: '',
    city: '',
    zip: '',
    client_id: '',
    custom_fields: {}
  });
  const [errors, setErrors] = useState([]);
  const [successMessage, setSuccessMessage] = useState('');

  useEffect(() => {
    fetchClients();
  }, []);

  useEffect(() => {
    if (building) {
      setFormData({
        address: building.address || '',
        state: building.state || '',
        city: building.city || '',
        zip: building.zip || '',
        client_id: building.client_id || '',
        custom_fields: building.custom_fields || {}
      });
      setSelectedClient(building.client_id);
    }
  }, [building]);

  useEffect(() => {
    if (selectedClient) {
      fetchCustomFields(selectedClient);
    }
  }, [selectedClient]);

  const fetchClients = async () => {
    try {
      const response = await fetch('/api/clients');
      const data = await response.json();
      if (data.status === 'success') {
        setClients(data.clients);
      }
    } catch (error) {
      setErrors(['Failed to fetch clients']);
    }
  };

  const fetchCustomFields = async (clientId) => {
    try {
      const response = await fetch(`/api/clients/${clientId}/custom_fields`);
      const data = await response.json();
      if (data.status === 'success') {
        setCustomFields(data.custom_fields);
      }
    } catch (error) {
      setErrors(['Failed to fetch custom fields']);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleCustomFieldChange = (fieldId, value, fieldType) => {
    // Clear previous errors
    setErrors([]);

    // Validate based on field type
    switch (fieldType) {
      case 'number':
        if (isNaN(value)) {
          setErrors(['Please enter a valid number']);
          return;
        }
        break;
      case 'enum':
        const field = customFields.find(f => f.id === fieldId);
        if (value && field && !field.options.includes(value)) {
          setErrors(['Please select a valid option']);
          return;
        }
        break;
    }

    setFormData(prev => ({
      ...prev,
      custom_fields: {
        ...prev.custom_fields,
        [fieldId]: value
      }
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrors([]);
    setSuccessMessage('');

    const url = isEditing 
      ? `/api/buildings/${building.id}`
      : '/api/buildings';
    
    const method = isEditing ? 'PATCH' : 'POST';

    try {
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ building: formData })
      });
      
      const data = await response.json();
      if (data.status === 'success') {
        setSuccessMessage(data.message);
        setTimeout(() => {
          resetForm();
          onComplete();
        }, 2000);
      } else {
        setErrors(Array.isArray(data.errors) ? data.errors : [data.errors]);
      }
    } catch (error) {
      setErrors(['Network error occurred']);
    }
  };

  const renderCustomFieldInput = (field) => {
    const value = formData.custom_fields[field.id] || '';

    switch (field.field_type) {
      case 'number':
        return (
          <input
            type="number"
            step="0.01"
            value={value}
            onChange={(e) => handleCustomFieldChange(field.id, e.target.value, 'number')}
          />
        );
      case 'enum':
        return (
          <select
            value={value}
            onChange={(e) => handleCustomFieldChange(field.id, e.target.value, 'enum')}
          >
            <option value="">Select {field.name}</option>
            {field.options.map(option => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
        );
      default:
        return (
          <input
            type="text"
            value={value}
            onChange={(e) => handleCustomFieldChange(field.id, e.target.value, 'freeform')}
          />
        );
    }
  };

  const resetForm = () => {
    setFormData({
      address: '',
      state: '',
      city: '',
      zip: '',
      client_id: '',
      custom_fields: {}
    });
    setSelectedClient(null);
    setCustomFields([]);
    setErrors([]);
  };

  const isFormValid = () => {
    return formData.client_id && formData.address && formData.state && 
           formData.city && formData.zip;
  };

  return (
    <form onSubmit={handleSubmit} className={styles.form}>
      <h2>{isEditing ? 'Edit Building' : 'New Building'}</h2>
      
      {errors.length > 0 && (
        <div className={styles.errorMessages}>
          {errors.map((error, index) => (
            <p key={index} className={styles.error}>{error}</p>
          ))}
        </div>
      )}

      <div className={styles.formGroup}>
        <label className={styles.label} htmlFor="client_id">Client:</label>
        <select
          className={styles.select}
          id="client_id"
          name="client_id"
          value={formData.client_id}
          onChange={(e) => {
            handleInputChange(e);
            setSelectedClient(e.target.value);
          }}
          disabled={isEditing}
        >
          <option value="">Select a client</option>
          {clients.map(client => (
            <option key={client.id} value={client.id}>
              {client.name}
            </option>
          ))}
        </select>
      </div>

      <div className={styles.formGroup}>
        <label className={styles.label} htmlFor="building_address">Address:</label>
        <input
          className={styles.input}
          id="building_address"
          type="text"
          name="address"
          value={formData.address}
          onChange={handleInputChange}
          required
        />
      </div>

      <div className={styles.formGroup}>
        <label className={styles.label} htmlFor="building_city">City:</label>
        <input
          className={styles.input}
          id="building_city"
          type="text"
          name="city"
          value={formData.city}
          onChange={handleInputChange}
          required
        />
      </div>

      <div className={styles.formGroup}>
        <label className={styles.label} htmlFor="building_state">State:</label>
        <input
          className={styles.input}
          id="building_state"
          type="text"
          name="state"
          value={formData.state}
          onChange={handleInputChange}
          required
        />
      </div>

      <div className={styles.formGroup}>
        <label className={styles.label} htmlFor="building_zip">ZIP:</label>
        <input
          className={styles.input}
          id="building_zip"
          type="text"
          name="zip"
          value={formData.zip}
          onChange={handleInputChange}
          required
        />
      </div>

      {customFields.length > 0 && (
        <div className={styles.customFieldsSection}>
          <h3>Custom Fields</h3>
          {customFields.map(field => (
            <div key={field.id} className={styles.formGroup}>
              <label className={styles.label} htmlFor={`custom_field_${field.id}`}>
                {field.name}:
              </label>
              <div id={`custom_field_${field.id}`}>
                {renderCustomFieldInput(field)}
              </div>
            </div>
          ))}
        </div>
      )}

      <div className={styles.formActions}>
        <button 
          type="submit" 
          className={styles.button}
          disabled={!isFormValid()}
        >
          {isEditing ? 'Update Building' : 'Create Building'}
        </button>
      </div>

      {successMessage && (
        <FlashMessage 
          message={successMessage}
          type="success"
          onClose={() => setSuccessMessage('')}
        />
      )}
    </form>
  );
};

export default BuildingForm; 